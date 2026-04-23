# WiFi Slow Speed Diagnosis — watson (ThinkPad T14s Gen4)

**Date:** 2026-04-23 (re-investigated same day after a wrong root-cause)
**Symptom:** WiFi slow on laptop, fast on phone connected to the same network.

---

## Observed Logs

The kernel logged this on every connection attempt:

```
ath11k_pci: Failed to set the requested Country regulatory setting
ath11k_pci: failed to process regulatory info -22
wlp1s0: required MCSes not supported, disabling HT
```

The first two lines are initialization noise — the ath11k firmware pushes its
regulatory domain to cfg80211 twice before it's ready, both fail with `EINVAL`,
and a later successful push sets the device to the US regulatory domain. These
errors are benign.

The third line is the actual problem. It fires during every association and
demotes the connection to legacy 802.11a (no HT, no VHT, no HE), 20 MHz,
54 Mbps max.

A second related kernel message was seen once for the same AP:

```
wlp1s0: Wrong control channel: center-freq: 5785 ht-cfreq: 5220
        ht->primary_chan: 44 band: 1 - Disabling HT
```

The AP's HT Operation IE claimed primary channel 44 while the beacon was
arriving on 5785 MHz (channel 157). That's a different mac80211 check and a
different bug in the AP's IE — strong evidence that this AP's HT Operation IE
is broadly malformed, not just its Basic MCS Set.

---

## Actions Taken

**Initial (wrong) hypothesis — regulatory domain not loaded:**
Added `hardware.wirelessRegulatoryDatabase = true` and
`options cfg80211 ieee80211_regdom=CA` to `systems/watson/default.nix`. Built
and rebooted. No change. Reverted.

**Why it didn't work:**
The `ath11k` driver registers as a _self-managed_ regulatory device
(`REGULATORY_WIPHY_SELF_MANAGED`). It ignores the global cfg80211 domain
entirely. `iw reg get` confirmed: global domain was CA (our setting applied),
but `phy#0 (self-managed)` was US (from firmware).

**Second (also wrong) hypothesis — Broadcom AP requires MCS rates above 15:**
Traced `required MCSes not supported, disabling HT` to
`ieee80211_verify_sta_ht_mcs_support()` in `net/mac80211/mlme.c`. The AP
advertises `HT RX MCS 0–76` (an unusual range that includes MCS 32 and
unequal-modulation rates typical of Broadcom-based APs). The hypothesis was
that the AP marks rates above MCS 15 as required in its Basic MCS Set, which
the WCN6855 (2x2, MCS 0–15) cannot satisfy.

**Why it was wrong (or rather, incomplete):**

- "RX MCS 0–76" is from the **HT Capabilities IE** — it's what the AP can
  _receive_, not what it requires of clients. The Basic MCS Set lives in a
  _different_ IE (HT Operation, 16-byte `basic_set` field) which `iw scan
dump` does not print and which we could not capture without monitor mode
  (broken on WCN6855: `Operation not supported -95`).
- The "disabling HT → fall back to legacy" cascade described above is wrong
  in mechanism: each protocol layer (HT/VHT/HE/EHT) has its own independent
  verifier. When HT verification fails, mac80211 sets `conn->mode = LEGACY`
  and the higher checks are _skipped_ (gated on `conn->mode >= ...`), not
  failed. End result is the same — 54 Mbps — but it's "demote then skip",
  not a cascade.
- The framing "WCN6855-specific because 2x2" missed that this is a generic
  mac80211 issue affecting every 2x2 chip on the market.

**Confirming test:**
The network has two APs with SSID `dragon25`:

| Device                  | Vendor                      | Real MAC            | Scan BSSID                                                | Channel            | Signal |
| ----------------------- | --------------------------- | ------------------- | --------------------------------------------------------- | ------------------ | ------ |
| Rogers CGM4331COM modem | Technicolor (Broadcom WiFi) | `48:BD:CE:4B:52:E0` | `4A:BD:CE:53:52:E6` and `4A:BD:CE:4C:52:E5` (multi-BSSID) | seen on 44 and 157 | 100%   |
| Repeater (Eero)         | Amazon (Qualcomm WiFi)      | `70:7D:A1:95:B7:0C` | `F2:7D:A1:95:B7:10`                                       | 157                | 84%    |

Both Rogers BSSIDs trigger `required MCSes not supported`. Forcing a connection
to the Eero immediately produced **780 Mbit/s VHT 80MHz 2-stream** with no
HT-disable message. (Note: the Eero occasionally times out on auth — seen in
the journal — so it isn't a perfectly reliable workaround on its own.)

**Second-pass investigation:**

- Read kernel source of `ieee80211_verify_sta_ht_mcs_support()` to confirm
  exactly what it checks: bytes 0–9 of the AP's Basic MCS Set vs the STA's
  `ht_cap.mcs.rx_mask`, with the predicate
  `(basic_set[i] & rx_mask[i]) == basic_set[i]`. WCN6855's mask is
  `[0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0]`, so any non-zero bit in `basic_set[2..9]`
  fails the check (MCS 16-31, MCS 32, or MCS 33-76).
- Mined `journalctl -k`: confirmed the failure fires for both Rogers BSSIDs,
  and surfaced the separate "Wrong control channel" failure on the same AP.
- Inspected `/sys/kernel/debug/ieee80211/phy0/netdev:wlp1s0/stations/<bssid>/`:
  `ht_capa`, `vht_capa`, `he_capa` all read `not supported` for the connected
  Rogers AP — confirming mac80211 actively disabled all three modes at assoc
  time.
- Researched upstream history: the verifier was added by Benjamin Berg
  (Intel) in [v1 Jan 2025](https://patches.linaro.org/project/linux-wireless/patch/20250101070249.6d5444ee6255.I66bcf6c2de3b9d3325e4ffd9f573f4cd26ce5685@changeid/),
  [v2 Feb 2025](https://patchwork.kernel.org/project/linux-wireless/patch/20250204193721.7dfdeb1235bb.I66bcf6c2de3b9d3325e4ffd9f573f4cd26ce5685@changeid/),
  implementing 802.11REVme/D7.0 §6.5.4.2.4. During review, Johannes Berg
  flagged that "many APs are incorrectly advertising an all-zero value... so
  check it only in strict mode" and the **VHT** branch was gated behind
  `IEEE80211_HW_STRICT`. The **HT** branch was not. That asymmetry is the bug.
- Same symptom is reported on iwlwifi (7265, AX200/210), MediaTek MT7922,
  Realtek RTL8852BE/rtw89 — purely a mac80211 regression, driver-independent.
  WCN6855 is reporting its capabilities correctly.

---

## Root Cause

A January 2025 mac80211 patch (`ieee80211_verify_sta_ht_mcs_support`) strictly
enforces the 802.11 spec language requiring a station to support every rate in
the AP's HT Operation Basic MCS Set. The Rogers CGM4331COM (Technicolor,
Broadcom 4x4 WiFi chipset, sibling to the Xfinity XB8 — the canonical
reproducer for this bug) sets multi-stream MCS rates as basic. Any 2x2 client
fails the check, and mac80211 demotes the connection to legacy 802.11a / 20
MHz / 54 Mbps.

This is a kernel regression, not a hardware or driver issue. The same patch's
VHT counterpart was gated behind `IEEE80211_HW_STRICT` after review pushback;
the HT counterpart was not. The clean upstream fix mirrors the VHT pattern:
return `true` early from the HT verifier unless the driver opts into STRICT
mode.

The Rogers AP also exhibits at least one _other_ HT Operation IE bug (the
"Wrong control channel" event), so its IE generator is broadly unreliable. But
the day-to-day failure is the basic-MCS check.

---

## Resolution

Carry an out-of-tree mac80211 patch via `boot.kernelPatches` in
`systems/watson/default.nix`. The patch ([WoodyWoodster/mac80211-mcs-patch](https://github.com/WoodyWoodster/mac80211-mcs-patch))
adds an early `return true;` to `ieee80211_verify_sta_ht_mcs_support()`,
restoring pre-2025 behavior. See the FIXME comment in `default.nix` for what
to watch for upstream and when to remove the patch.

Confirmed working: ~960 Mbps on a 2x2 MT7922 against the sibling Xfinity XB8
AP (project README); same fix applies to ath11k/WCN6855 since the patch is in
generic `mac80211`.

**Fallback if the patch ever regresses:** pin the `dragon25` NetworkManager
profile to the Eero's BSSID, accepting that it occasionally fails auth and
falls back to one of the Rogers BSSIDs:

```
sudo nmcli connection modify dragon25 802-11-wireless.bssid F2:7D:A1:95:B7:10
```

---

## Longer-Term Options

- **Upstream fix.** Submit a patch gating the HT branch behind `IEEE80211_HW_STRICT`
  to mirror the VHT branch. Track the [linux-wireless thread](https://lore.kernel.org/linux-wireless/?q=ieee80211_verify_sta_ht_mcs_support).
  Once merged, drop the local patch.
- **Disable the 5GHz radio on the Rogers modem** so all 5GHz traffic flows
  through the Eero. Sidesteps the AP entirely.
- **Request a firmware update from Rogers.** The CGM4331COM should not be
  including 3/4-stream MCS rates in its Basic MCS Set. Long shot.
