{ config, pkgs, lib, ... }:
{
  imports = [
    ../modules/cachix.nix
    ../modules/nix.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

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
        google-fonts
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

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

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
