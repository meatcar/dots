# AGENTS.md

This file provides guidance to coding agents (Claude Code, Codex, etc.) when working with code in this repository.

`nix-darwin` flake. Currently one host: `imogen` (aarch64-darwin), users: `denys`, `amanda`.

> macOS note: copying to non-Apple filesystems (FAT, exFAT, most network shares) scatters `._*` AppleDouble sidecar files to store xattrs. Plain `rsync` (no `-X`/`-A`) avoids the `copyfile()` path that `cp`/`mv` use and is less prone to this, but doesn't eliminate it — existing `._*` files copy through as-is, and some configurations still produce new ones. Run `dot_clean <path>` afterward to merge/remove them.

## Layout

Built with [flake-parts](https://flake.parts). `flake.nix` is a minimal `mkFlake` entry point that imports the modules under `flakeModules/`.

- `flake.nix` — inputs and `mkFlake` entry point; imports the modules under `flakeModules/`.
- `flakeModules/darwin.nix` — declares `darwinConfigurations`; list new hosts here.
- `flakeModules/dev.nix` — `nix develop` shell and `treefmt` formatter config.
- `hosts/<host>.nix` — per-host darwin system config. Imports darwin modules.
- `modules/darwin/` — system-level darwin modules (homebrew, etc.).
- `modules/home/common.nix` — home-manager modules shared by every user.
- `lib/mkUser.nix` — helper that builds an HM module from `{ fullName, email }`.
- `users/<user>.nix` — per-user HM config; imports `mkUser` + user-specific extras.

- To add a user: create `users/<name>.nix` (model on `users/denys.nix`), add a `users.users.<name>` block to the host file, and add `home-manager.users.<name> = import ../users/<name>.nix;` inside `mkHost` in `flakeModules/darwin.nix`.
- To add a host: create `hosts/<name>.nix`, then add `<name> = mkHost ../hosts/<name>.nix;` to `flake.darwinConfigurations` in `flakeModules/darwin.nix`.

## Commands

`NH_FLAKE` is set system-wide, so `nh` works from anywhere.

- Apply: `nh darwin switch`
- Build only: `nh darwin build`
- Update inputs: `nix flake update`
- Format: `nix fmt`
- Dev shell: `nix develop`

## Where things go

- `programs.<tool>` (home-manager or nix-darwin) when a module exists — preferred.
- `homebrew.{brews,casks}` for GUI apps and tools Nix can't supply well.
- `environment.systemPackages` / `home.packages` only as a last resort.
- System-wide, user-agnostic → `hosts/<host>.nix` or `modules/darwin/`.
- Shared across all users → `modules/home/common.nix`.
- Per-user only → `users/<name>.nix`.

`homebrew.masApps` is intentionally empty — see the comment in `modules/darwin/homebrew.nix` before adding any.
