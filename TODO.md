# TODO

Codebase audit, 2026-08-15. Pointers only; verify before fixing.

## Features

- [ ] can `dms open` browser picker use shortcuts to pick an option?
- [ ] offline email (work + personal)

## Confirmed, live impact

- [ ] bump ghostty to 1.3.2 to fix middleclick bug in neovim
- [ ] `home-manager/modules/vscode/default.nix:11` — `.ssh/config` onChange chmods 400 after write; later regenerations fail, live config stale since 2025-02. ssh module never applied.
- [ ] `systems/watson/default.nix:290` — password hash committed; wire `age.secrets.userPassword` to `hashedPasswordFile` instead.
- [ ] `.github/workflows/flake-check.yml:32-37` — still runs `git-crypt unlock` (removed); ssh-agent socket not exported to later steps. CI never reaches `nix flake check`.
- [ ] `home-manager/modules/fish/config.fish:46` — `set -U --append __done_exclude` in shellInit grows unboundedly per shell.
- [ ] `home-manager/modules/niri/default.nix:15,22` — edit-screenshot: `writeScript` has no shebang (niri spawn ENOEXEC); satty gets basename without `$DIRECTORY`.
- [ ] `home-manager/modules/niri/default.nix:114` — Mod+Shift+S mirror: `$output=` stray `$`, assignment never happens.
- [ ] `home-manager/modules/direnv/default.nix:3` — `ENV_STORE="~/..."` literal tilde; env-store helpers can't resolve.
- [ ] `home-manager/modules/tmux/tmux.conf:150` — version guard uses `bc` (absent); C-\ binding never installed.
- [ ] `home-manager/modules/neovim/nvim/lua/init.lua:9-12` — `not isdirectory()` never true (0 truthy); `dir$` gsub misses `directory`.
- [ ] `home-manager/modules/television/default.nix:26` — git-dirs channel `metadata.name = "zoxide"` shadows builtin.
- [ ] `flake-modules/devshell.nix:36,41` — backticks in echo run `op`; `which` redirect order wrong.
- [ ] `systems/watson/t14s-micmuteled.sh:24` — multi-line jq output compared to `"true"`; LED wrong on multi-route devices.
- [ ] `home-manager/modules/jujutsu/default.nix:195` — `unmerged()` calls undefined `dev()`.
- [ ] `home-manager/modules/niri/config.kdl:139-144` — J/K inverted for move-window/column-to-monitor.
- [ ] `home-manager/modules/bat/default.nix:33`, `git/default.nix:138` — call `get-theme`; `common.nix:83` ships `get-theme-default`. Breaks `deck`.
- [ ] `home-manager/modules/agenix/default.nix:34` — `op read > key` bypasses `run`, 0644 before chmod. Same unwrapped-activation pattern in `ai/cli-proxy-api/{default,pi-bridge/default}.nix`.

## Impermanence gaps (watson)

- [ ] `home-manager/systems/watson/impermanence.nix:129` — `.config/pavucontrol.ini` in `directories`, mounted as dir; also stale.
- [ ] Slack/calibre/gimp/inkscape `~/.config` not persisted (`home-manager/systems/watson/default.nix:59`).
- [ ] `/var/lib/libvirt` not persisted though `modules/vm` enabled (`modules/impermanence/`).
- [ ] Lower priority: rbw (`.cache/rbw`, `.local/share/rbw`), `/var/lib/flatpak`, restic cache `/var/cache/restic-backups-persist`, `~/.local/state/netdata-notify`; stale `.cache/ssh` entry (:313).
- [ ] `home-manager/modules/impermanence-copy-paths/default.nix:107` — save `.path` and restore `.service` unordered; empty tmpfs copy can clobber persisted file.
- [ ] `home-manager/systems/watson/impermanence.nix:18` — `readlink -f` → `-m` so precreation runs on fresh `/persist`.

## Docs drift

- [ ] `docs/wifi-slow-speed-diagnosis.md:142` — describes a `boot.kernelPatches` fix that doesn't exist.
- [ ] `docs/1password-agenix-boot-issues.md:67` — describes units/ordering that don't exist.
- [ ] `home-manager/modules/podman/CONTAINERS.md:13` — dashboard is `traefik.localhost:80`, not `:8080`.
- [ ] `home-manager/modules/podman/default.nix:9` — `podman-bridged` comment claims network placement; wrapper does nothing.

## Dead / bit-rotted code (fails eval if re-enabled — fix or delete)

- [ ] `configuration.nix` — imports `./system` (dir is `systems/`); README + devshell `NIXOS_CONFIG` still point at it.
- [ ] `modules/vfio/` — removed option `qemuOvmf`, missing `scream-receivers`, user unit on `multi-user.target`/`pulseaudio.service`.
- [ ] `modules/opensnitch/rules/` — wrong binary paths (tailscale, geoclue2), `pkgs._1password` throw, timesyncd gated on automatic-timezoned.
- [ ] `modules/bluetooth/default.nix:21` — `pulseaudio-modules-bt` gone; landmine if pulseaudio enabled.
- [ ] `modules/power/untune-hid.sh:3` — `^` anchor vs absolute paths, always empty.
- [ ] `home-manager/modules/clojure` (`import`, wrong path), `email` (`../neomutt` missing), `emacs:77` (mangled vterm fish body), `opensnitch` (unmergeable unit override).
- [ ] Unwired: `pkgs/showboat`, `home-manager/modules/voice/pocket-tts`, `home-manager/modules/opencode/pushover.js`, `secrets/git-crypt/hm-me.nix`, `niri/winswitch.py`, `gitu` merge-tool w/o package.
- [ ] `allowUnfreePredicate` defs (`modules/netdata`, `modules/steam`, `home-manager/systems/watson/default.nix:93`) are dead under `allowUnfree = true` and clobber each other.

## Hardening / style

- [ ] `modules/podman/default.nix:4` — `ip_unprivileged_port_start=80` opens 80–1023; consider `CAP_NET_BIND_SERVICE` scoping.
- [ ] `scripts/find-cached-cachyos-kernel.sh:13` — add `pipefail`; curl failure masked by jq.
- [ ] `home-manager/modules/voice/handy/ptt.py:18` — toggle result unchecked; TIMEOUT is idle, not max-duration.
- [ ] Inline multi-line scripts → standalone files: `modules/laptop:19`, `modules/ddcci:37`, `modules/impermanence:75` (fs-diff, dead shebang, no unmount).
- [ ] `home-manager/modules/ai/default.nix:40` — `allow-remote = true` overrides a commented safety default; document or drop.
- [ ] `systems/watson/t14s-micmuteled.nix:36` — `Restart=always` w/o `RestartSec`, waits on user pipewire.

## Darwin (imogen)

- [-] configure raycast per-user
  - impossible, explore sync later.
- [x] reorganize using flake-parts
- [x] integrated with `meatcar/dots`
- [x] update to 26.05
- [ ] drop `doCheck = false` mactop override in `home-manager/systems/imogen.nix` once nixpkgs-26.05-darwin ships mactop ≥ 2.1.3 (PR NixOS/nixpkgs#523550, merged 2026-05-30)
- [ ] enable 1Password `op-ssh-sign` commit signing on imogen, then set `me.signing.enable = true` in `home-manager/systems/imogen.nix`
- [ ] imogen: git author email is github@denys.me (carried over from the darwin repo) while watson uses me@denys.me; decide whether to align (jj is github@denys.me everywhere via `me.identity.jjEmail`)
