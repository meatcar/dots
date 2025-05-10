{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wakatime
    (writeShellScriptBin "wakatime-wrapper" ''
      ${wakatime}/bin/wakatime-cli "$@"
    '')
  ];

  programs.fish.plugins = [
    {
      name = "wakatime";
      # TODO: remove when 0.0.6 is in nixpkgs
      src = pkgs.fishPlugins.wakatime-fish.override (o: {
        buildFishPlugin =
          attr:
          o.buildFishPlugin (
            attr
            // rec {
              version = "0.0.6";
              src = pkgs.fetchFromGitHub {
                owner = "ik11235";
                repo = "wakatime.fish";
                rev = "v${version}";
                hash = "sha256-Hsr69n4fCvPc64NztgaBZQuR0znkzlL8Uotw9Jf2S1o=";
              };
            }
          );
      });
    }
  ];
}
