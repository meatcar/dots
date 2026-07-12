# Home-manager baseline shared by every user on imogen
# (wired via home-manager.sharedModules in flake-modules/darwin.nix).
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/me.nix
    ../modules/brew
  ];

  # where this flake is checked out on imogen
  me.PRJ_ROOT = lib.mkDefault "${config.home.homeDirectory}/git/hub/meatcar/dots";

  home.packages = [
    (pkgs.mactop.overrideAttrs (_: {
      doCheck = false;
    }))
  ];

  programs.fish = {
    enable = true;
    shellInit = ''
      fish_add_path "$HOME/.local/bin"
      fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
    '';
  };
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish.shellAliases.yy = "y";
  programs.man.generateCaches = false;
  programs.bat.enable = true;
  programs.gh.enable = true;
  programs.git.ignores = [ ".DS_Store" ];
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    sensibleOnTop = true;
    baseIndex = 1;
    mouse = true;
  };
  programs.lazygit.enable = true;
  programs.jjui.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  targets.darwin.defaults.NSGlobalDomain.NSStatusItemSpacing = 8;
}
