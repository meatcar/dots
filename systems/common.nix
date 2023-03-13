{ config, pkgs, lib, ... }:
{
  imports = [
    ../modules/cachix.nix
    ../modules/nix.nix
  ];

  # using nix-index instead in home-manager
  programs.command-not-found.enable = false;

  documentation = {
    enable = true;
    man.enable = true;
    man.generateCaches = true;
    nixos.enable = true;
    dev.enable = true;
  };

  hardware.opengl.enable = true;

  fonts = {
    fontconfig = {
      enable = lib.mkOptionDefault true;
      defaultFonts = {
        monospace = [ "GoMono Nerd Font" ];
        sansSerif = [ "Inter" ];
        serif = [ "Liberation Serif" ];
      };
    };
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = builtins.attrValues {
      inherit (pkgs)
        # icons
        font-awesome_4
        # proportional
        inter
        # monospace
        go-font
        emacs-all-the-icons-fonts
        ;
      nerdfonts = pkgs.nerdfonts.override {
        fonts = [ "Go-Mono" ];
      };
    };
  };

  gtk.iconCache.enable = true;

  environment.enableAllTerminfo = true;

  xdg = {
    icons.enable = true;
    mime.enable = true;
    menus.enable = true;
    portal.enable = true;
    portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    sounds.enable = true;
  };
}
