NixOS/nix-darwin/Home Manager dotfiles repo.

- Entry: `flake.nix`
- Systems: `systems/` (NixOS + nix-darwin hosts) + `home-manager/systems/` (Home Manager)

- Dev shell: `nix develop`
- Flake checks: `nix flake check` | `nix build .#checks.x86_64-linux.<name>`
- Format/lint: `nix fmt` (required for commit)
- Build NixOS: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
- Build darwin: `nix build .#darwinConfigurations.<host>.system` (apply: `nh darwin switch`)
- Build HM: `nix build .#homeConfigurations.<host>.activationPackage`
- List outputs: `nix flake show`
- Update input: `nix flake lock --override-input <input> <url+rev>`

Nix Conventions:

- Nixpkgs conventions.
- New modules: directory + `default.nix`, consistent with neighbors.
- Composition: `imports = [ ./path ];`
- Separate NixOS vs Home Manager concerns.
- `specialArgs` only for values shared across modules.
- Multi-line scripts in standalone files.
- Package source: first one that is current enough, in order: stable nixpkgs, `nixpkgs-unstable`, existing flake input, own package in `pkgs/`. Desktop apps may use Flatpak or a Gear Lever AppImage instead of an own package.
- Flatpaks: declare in `home-manager/modules/flatpak`.
- New flake input: ask first, with alternatives. Candidates: the app maintainer's own flake, or one updated as often as `llm-agents`.
- Strict impermanence: see `home-manager/systems/watson/impermanence.nix` and `modules/impermanence/default.nix` and its imports for paths that survive reboot.

Structure:

- Hosts: `flake-modules/nixos.nix` (watson, iso), `flake-modules/darwin.nix` (imogen), `flake-modules/home.nix` (deck). Same mkSystem/mkHost shape; shared plumbing (nixpkgsConfig, unstableFor) comes from flake.nix via `_module.args`.
- `home-manager/systems/common.nix` is the cross-platform CLI stack, imported per-user on every host. HM modules are platform-aware and self-contained: they import their own deps (bat -> theme) and guard Linux-only parts internally (podman, audio-record, ssh, direnv). To bring a tool to another platform, fix its module — never guard at the import site.
- `me.*` options (`home-manager/modules/me.nix`) carry cross-cutting intent: `me.identity.{name,email,username}` (mapped into git/jj there — never hardcode identity in modules), `me.signing.enable` (hosts opt in), `me.PRJ_ROOT` (live checkout path; nh and mkOutOfStoreSymlink targets use it).
- Multi-user hosts: per-host baseline via `home-manager.sharedModules` (e.g. `home-manager/systems/imogen.nix`), per-user files in `home-manager/users/` built on `mkUser.nix` (sets me.identity + light git/jj).

Darwin (macOS):

- Host `imogen` (aarch64-darwin): `systems/imogen/`, users denys + amanda.
- Darwin hosts track the darwin-gated channels (`nixpkgs-darwin`, `nixpkgs-unstable-darwin` inputs); Linux hosts keep `nixos-*`.
- GUI apps and mac-only tools go in `homebrew.*` (`modules/darwin/homebrew/`); the shared brew wrapper records ad-hoc installs in `brew-extras.json`. `homebrew.masApps` is intentionally empty — see the comment there.

Shell Conventions:

- POSIX shell preferred. `#!/usr/bin/env bash` only if needed.
- Love shellcheck.
- No silent failures; print actionable errors.

Git: atomic Conventional Commits.

Safety:

- Don't edit encrypted files without keys. Use agenix/ragenix patterns.
- Don't commit secrets or build outputs.
- Build the specific host you touched for verification.
- When unsure: `nix flake check`, ask for target host, mirror closest config.
