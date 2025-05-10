{ inputs, ... }:
{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "dots";
        inputsFrom = [
          config.pre-commit.devShell
          config.treefmt.build.devShell
        ];

        buildInputs = with pkgs; [
          (import inputs.home-manager { inherit pkgs; }).home-manager
          nixVersions.stable
          git
          git-crypt
          (nixos-rebuild.override { nix = nixVersions.stable; })
          stow
          inputs.agenix.packages.${system}.default
          nil # nix lsp server
          nixd
        ];
        NIX_PATH = builtins.concatStringsSep ":" [
          "nixpkgs=${inputs.nixpkgs}"
          "home-manager=${inputs.home-manager}"
        ];
        NIXOS_CONFIG = ../configuration.nix;
        shellHook = ''
          if [ ! -f .git/git-crypt/keys/default ]; then
            if which op 2>&1 >/dev/null; then
              echo "WARN: importing git-crypt key from 1password"
              mkdir -p .git/git-crypt/keys
              op document get git-crypt-dots --force --out-file .git/git-crypt/keys/default
            else
              echo "ERROR: `op` command missing, can't import git-crypt key" >&2
            fi
          fi
        '';
      };
    };
}
