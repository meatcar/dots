# Contributing to meatcar's dotfiles

First off, thank you for considering contributing! Your help is appreciated.

This document provides guidelines for contributing to this repository.

## Table of Contents
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Pull Requests](#pull-requests)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Style Guides](#style-guides)
  - [Nix Code](#nix-code)
  - [Commit Messages](#commit-messages)

## How Can I Contribute?

### Reporting Bugs

If you find a bug, please open an issue and provide as much information as possible, including:
- Your operating system and environment.
- Steps to reproduce the bug.
- The expected behavior and what happened instead.

### Suggesting Enhancements

If you have an idea for an enhancement, feel free to open an issue to discuss it.

### Pull Requests

Pull Requests are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or fix: `git checkout -b my-awesome-feature`.
3. Make your changes.
4. Format your code (see [Style Guides](#style-guides)).
5. Commit your changes with a descriptive commit message.
6. Push your branch to your fork: `git push origin my-awesome-feature`.
7. Open a Pull Request.

## Development Setup

The setup is similar to the installation instructions in `README.md`. You will need Nix installed.

1. Fork and clone the repository.
2. Enter the development environment by running `nix develop`. This will install git hooks and provide all necessary tools.

To test your changes, you can build a specific configuration.

To build a NixOS configuration (e.g., for `watson`):
```bash
nix build .#nixosConfigurations.watson.config.system.build.toplevel
```

To build a Home Manager configuration (e.g., for `deck`):
```bash
nix build .#homeConfigurations.deck.activationPackage
```

## Project Structure

The repository is organized as follows:

- `flake.nix`: The main entrypoint for the Nix flake, defining dependencies and outputs.
- `README.md`: Provides an overview and installation instructions.
- `systems/`: Contains NixOS-specific configurations for different machines. Each subdirectory corresponds to a host.
- `home-manager/`: Contains Home Manager configurations, structured similarly to the `systems/` directory.
- `conf/`: Contains dotfiles managed with GNU Stow for applications not managed through Nix.
- `flake-modules/`: Reusable modules for the flake, such as `devshell.nix`, `treefmt.nix`, and `git-hooks.nix`.

## Style Guides

### Nix Code

All Nix code is formatted using `treefmt`. Before committing, please run the formatter:

```bash
treefmt
```

This command is available in the development shell. It is also enforced by a pre-commit hook.

When creating new Nix modules, please follow the established structure. Prefer creating a directory for a module with a `default.nix` file inside it (e.g., `modules/my-module/default.nix`) rather than a single file (e.g., `modules/my-module.nix`). This helps keep related files together as the module grows.

### Commit Messages

This repository uses [Conventional Commits](https://www.conventionalcommits.org/) for commit messages. This is enforced with a pre-commit hook using `commitizen`.

To make a commit, stage your changes and then run `git commit`. The `commitizen` tool will guide you through creating a compliant commit message.
