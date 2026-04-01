NixOS/Home Manager dotfiles repo.

- Entry: `flake.nix`
- Systems: `systems/` (NixOS) + `home-manager/systems/` (Home Manager)

- Dev shell: `nix develop`
- Flake checks: `nix flake check` | `nix build .#checks.x86_64-linux.<name>`
- Format/lint: `treefmt` (required for commit)
- Build NixOS: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
- Build HM: `nix build .#homeConfigurations.<host>.activationPackage`
- List outputs: `nix flake show`

Nix Conventions:

- Nixpkgs conventions.
- New modules: directory + `default.nix`, consistent with neighbors.
- Composition: `imports = [ ./path ];`
- Separate NixOS vs Home Manager concerns.
- `specialArgs` only for values shared across modules.

Shell Conventions:

- POSIX shell preferred. `#!/usr/bin/env bash` only if needed.
- Quote variables: `"${var}"`.
- Use `set -euo pipefail`.
- No silent failures; print actionable errors.

Git: Conventional Commits.

Safety:

- Don't edit encrypted files without keys. Use agenix/ragenix patterns.
- Don't commit secrets or build outputs.
- Build the specific host you touched for verification.
- When unsure: `nix flake check`, ask for target host, mirror closest config.
