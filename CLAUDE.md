# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

`nix-darwin` flake. Currently one host: `imogen` (aarch64-darwin), one user: `denys`. Laid out for multi-user.

## Layout

- `flake.nix` — inputs, outputs wiring.
- `hosts/<host>.nix` — per-host darwin system config. Imports darwin modules.
- `modules/darwin/` — system-level darwin modules (homebrew, etc.).
- `modules/home/common.nix` — home-manager modules shared by every user.
- `lib/mkUser.nix` — helper that builds an HM module from `{ fullName, email }`.
- `users/<user>.nix` — per-user HM config; imports `mkUser` + user-specific extras.

To add a user: create `users/<name>.nix` (model on `users/denys.nix`), add a `users.users.<name>` block to `hosts/imogen.nix`, and add `home-manager.users.<name> = import ./users/<name>.nix;` in `flake.nix`.

## Commands

`NH_FLAKE` is set system-wide, so `nh` works from anywhere.

- Apply: `nh darwin switch`
- Build only: `nh darwin build`
- Update inputs: `nix flake update`
- Format: `nix fmt`

## Where things go

- `programs.<tool>` (home-manager or nix-darwin) when a module exists — preferred.
- `homebrew.{brews,casks}` for GUI apps and tools Nix can't supply well.
- `environment.systemPackages` / `home.packages` only as a last resort.
- System-wide, user-agnostic → `hosts/<host>.nix` or `modules/darwin/`.
- Shared across all users → `modules/home/common.nix`.
- Per-user only → `users/<name>.nix`.

`homebrew.masApps` is intentionally empty — see the comment in `modules/darwin/homebrew.nix` before adding any.
