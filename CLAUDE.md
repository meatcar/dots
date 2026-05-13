# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Single-file `nix-darwin` flake for one host: `imogen` (aarch64-darwin, user `denys`). Everything lives in `flake.nix`.

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

`homebrew.masApps` is intentionally empty — see the comment in `flake.nix` before adding any.
