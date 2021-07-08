{ config, pkgs, ... }:
{
  home.packages = [ pkgs.nixUnstable ];

  home.file.nixConf.text = ''
    experimental-features = nix-command flakes
  '';

  programs.direnv = {
    stdlib = ''
      use_flake() {
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
      }
    '';
  };
}
