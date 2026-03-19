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
          config.treefmt.build.devShell
        ];

        buildInputs = with pkgs; [
          (import inputs.home-manager { inherit pkgs; }).home-manager
          git
          gnupg
          (pkgs.writeShellScriptBin "agenix" ''
            exec ${inputs.agenix.packages.${system}.default}/bin/agenix \
              -i ~/.config/age/age-plugin-1p-identity.txt \
              "$@"
          '')
          age-plugin-1p
          nil # nix lsp server
          nixd
        ];
        NIX_PATH = builtins.concatStringsSep ":" [
          "nixpkgs=${inputs.nixpkgs}"
          "home-manager=${inputs.home-manager}"
        ];
        NIXOS_CONFIG = ../configuration.nix;
        shellHook = ''
          if [ ! -f crypt/hm-me.nix ]; then
            if which op 2>&1 >/dev/null; then
              echo "WARN: importing secrets from 1password"
              mkdir -p crypt/
              op document get 'crypt dots' --force --out-file crypt/hm-me.nix
            else
              echo "ERROR: `op` command missing, can't import secrets" >&2
            fi
          fi
        '';
      };
    };
}
