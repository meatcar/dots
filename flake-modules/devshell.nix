{ inputs, ... }:
{
  perSystem =
    {
      system,
      pkgs,
      config,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "dots";
        inputsFrom = [
          config.pre-commit.devShell
          config.treefmt.build.devShell
        ];

        buildInputs = with pkgs; [
          (import inputs.home-manager { inherit pkgs; }).home-manager
          git
          gnupg
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
          if [ ! -f git-crypt/hm-me.nix ]; then
            if which op 2>&1 >/dev/null; then
              echo "WARN: importing secrets from 1password"
              mkdir -p git-crypt/
              op document get 'crypt dots' --force --out-file git-crypt/hm-me.nix
            else
              echo "ERROR: `op` command missing, can't import secrets" >&2
            fi
          fi
        '';
      };
    };
}
