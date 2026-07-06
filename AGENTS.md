NixOS/Home Manager dotfiles repo.

- Entry: `flake.nix`
- Systems: `systems/` (NixOS) + `home-manager/systems/` (Home Manager)

- Dev shell: `nix develop`
- Flake checks: `nix flake check` | `nix build .#checks.x86_64-linux.<name>`
- Format/lint: `nix fmt` (required for commit)
- Build NixOS: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
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
- Strict impermanence: see `home-manager/systems/watson/impermanence.nix` and `modules/impermanence/default.nix` and its imports for paths that survive reboot.

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
