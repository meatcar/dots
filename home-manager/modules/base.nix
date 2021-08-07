{ config, pkgs, lib, ... }:
{
  home.stateVersion = "20.09";
  home.packages = builtins.attrValues {
    inherit (pkgs)
      curl htop mosh eternal-terminal neomutt isync msmtp ripgrep jq
      docker docker-compose entr nox nixpkgs-fmt nixfmt binutils
      gcc gnumake openssl pkgconfig imgcat hydra-check;
  };

  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    NOTES_DIR = "~/Sync/notes";
  };
  nixpkgs.config = import ./config.nix;
  xdg.configFile."nixpkgs/config.nix".text =
    let
      seqToString = lib.generators.toPretty { };
      nixpkgsConfig = lib.filterAttrs (n: v: n != "packageOverrides") config.nixpkgs.config;
    in
    seqToString nixpkgsConfig;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.fzf.enable = true;
  programs.lsd.enable = true;
  programs.lsd.enableAliases = true;
  programs.dircolors.enable = true;
}
