#!/usr/bin/env bash
set -eu -o pipefail

# The eGPU is the amdgpu device whose PCI "removable" reads "removable".
gpu=
for dev in /sys/bus/pci/drivers/amdgpu/*/; do
  [ "$(cat "$dev/removable" 2>/dev/null)" = removable ] || continue
  gpu=$dev
  break
done
if [ -z "$gpu" ]; then
  echo "egpu-undock: no removable amdgpu device found" >&2
  exit 1
fi
bdf=$(basename "$gpu")

# Authenticate while the screen is still on, so the removal below cannot block
# on a sudo prompt after the display is gone.
sudo -v || {
  echo "egpu-undock: need sudo to remove the device" >&2
  exit 1
}

# niri renders on the iGPU and only scans out to the eGPU, so it survives the
# removal once the eGPU's outputs are off. Skipped without a reachable session.
if command -v niri >/dev/null 2>&1 && niri msg outputs >/dev/null 2>&1; then
  # Light the internal panel first so undocking does not leave a blank screen.
  for conn in /sys/class/drm/card*-eDP-*; do
    [ "$(cat "$conn/status" 2>/dev/null)" = connected ] || continue
    out=$(basename "$conn" | cut -d- -f2-)
    niri msg output "$out" on || true
  done

  # Turn off every connected output on the eGPU.
  for conn in "$gpu"drm/card*/card*-*; do
    [ "$(cat "$conn/status" 2>/dev/null)" = connected ] || continue
    out=$(basename "$conn" | cut -d- -f2-)
    echo "egpu-undock: niri output $out off" >&2
    niri msg output "$out" off || true
  done

  # Spin until niri releases the CRTCs (enabled -> disabled), so the bus removal
  # is not a surprise removal of an active device. Capped at 5s.
  tries=0
  while grep -qsx enabled "$gpu"drm/card*/card*-*/enabled; do
    if [ "$tries" -ge 50 ]; then
      echo "egpu-undock: outputs still active after wait; removing anyway" >&2
      break
    fi
    sleep 0.1
    tries=$((tries + 1))
  done
else
  echo "egpu-undock: niri IPC unavailable; removing without graceful teardown" >&2
fi

echo "egpu-undock: removing $bdf" >&2
echo 1 | sudo tee "$gpu/remove" >/dev/null
