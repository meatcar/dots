# AGENTS.md

This repository contains NixOS/Home Manager configs plus stow-managed dotfiles.
Use these notes when making changes in this repo.

## Quick Orientation

- Primary entry: `flake.nix`.
- NixOS configs live under `systems/`.
- Home Manager configs live under `home-manager/`.
- Legacy stow-managed files live in `conf/` (avoid editing).
- Development shell: `nix develop` (installs tools + git hooks).

## Build / Lint / Test Commands

### Enter dev environment

- `nix develop`
  - Installs git hooks, `treefmt`, `nixfmt`, `statix`, `deadnix`, `shellcheck`, etc.
  - Also sets `NIX_PATH` and `NIXOS_CONFIG` for rebuilds.

### Formatting / Linting

- `treefmt`
  - Formats and lints via treefmt (required before committing).
  - Includes: `nixfmt`, `statix`, `deadnix`, `actionlint`, `shfmt`, `shellcheck`.
- Run `treefmt --fail-on-change` to check formatting without editing.

### Nix flake checks

- `nix flake check`
  - Runs configured flake checks and hook validation.
- `nix build .#checks.x86_64-linux.<check-name>`
  - Run a single check (use `nix flake show` to list checks).

### Build configs (manual verification)

- NixOS system build:
  - `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
- Home Manager build:
  - `nix build .#homeConfigurations.<host>.activationPackage`

### Single config smoke test

- Prefer building the specific host you touched.
- Use `nix flake show` to find available `nixosConfigurations` or `homeConfigurations`.

## Repository Conventions

### Nix modules

- Prefer a directory + `default.nix` for new modules.
- Keep module structure consistent with neighboring modules.
- Use `imports = [ ./path ];` for composition.
- Use `lib.mkIf` / `lib.mkMerge` for conditional config.
- Use `lib.mkDefault` for defaults; avoid overriding by force.
- Explicitly separate NixOS vs Home Manager concerns.

### Nix formatting

- Nix code is formatted with `nixfmt` through `treefmt`.
- Use 2-space indentation (nixfmt default).
- Keep lists and attrsets tidy; align braces with surrounding style.

### Options / types

- When adding options, use `lib.types` and `lib.mkOption`.
- Prefer `types.str`, `types.bool`, `types.int`, `types.listOf`.
- Provide `description` for new options when applicable.

### Naming

- Attribute names: `camelCase` unless upstream requires otherwise.
- File names: match existing module naming patterns.
- Host names: follow existing host folder names and flake outputs.

## Shell / Script Conventions

- Use POSIX shell when possible.
- Prefer `#!/usr/bin/env bash` only if bashisms are required.
- Always quote variables: `"${var}"`.
- Use `set -euo pipefail` in scripts that run multiple commands.
- Avoid silent failures; print actionable error messages.

## Error Handling

- Prefer early exits with clear messages for missing deps.
- Avoid swallowing errors (no `|| true` unless required and documented).
- In Nix, prefer `assert`/`lib.assertMsg` for invariants.

## Imports and Dependencies

- Keep Nix `inputs` usage minimal and scoped to required files.
- Use `specialArgs` only for values shared by multiple modules.
- Avoid duplicate `nixpkgs` imports within a single module.

## Git Hooks and Commit Style

- Pre-commit hooks: `treefmt`, `commitizen`, `flake-checker`.
- Commit messages follow Conventional Commits.
- Use `git commit` (commitizen is configured via hooks).

## Cursor / Copilot Rules

- No `.cursor/rules`, `.cursorrules`, or `.github/copilot-instructions.md` found.

## Additional Notes

- The repo expects Nix installed for any build/test workflow.
- `nix develop` is the canonical entrypoint for tooling.
- Large changes should be validated with `nix build` on affected hosts.
- Keep changes focused; avoid unrelated refactors.

## Single-test / Single-check Recipes

- List checks:
  - `nix flake show`
- Run a single check:
  - `nix build .#checks.x86_64-linux.<check-name>`
- Build one NixOS host:
  - `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
- Build one Home Manager host:
  - `nix build .#homeConfigurations.<host>.activationPackage`

## Editing Tips

- Search for module entrypoints before adding new files.
- Use existing host configs as templates.
- Follow local patterns for variable names and ordering.
- Keep attribute ordering stable within modules.

## Safety

- Avoid editing encrypted files unless you have keys.
- Handle secrets with agenix/ragenix patterns already in use.
- Do not commit secret material or generated build outputs.

## When in Doubt

- Run `treefmt` and `nix flake check`.
- Ask for the target host name if unknown.
- Mirror the closest existing config as a template.
