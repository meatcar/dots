{
  pkgs,
  lib,
  ...
}: {
  imports = [
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

  hardware.graphics.enable = true;

  fonts = {
    fontconfig = {
      enable = lib.mkOptionDefault true;
      # render embedded emojis
      useEmbeddedBitmaps = true;
      subpixel.rgba = "rgb";
      defaultFonts = {
        monospace = ["Iosevka Term SS07" "Symbols Nerd Font"];
        sansSerif = ["Inter"];
        serif = ["Liberation Serif"];
      };
    };
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      # icons
      noto-fonts-emoji
      font-awesome_4
      nerd-fonts.symbols-only
      # web
      corefonts
      # proportional
      inter
      # monospace
      go-font
      (iosevka-bin.override {variant = "SS07";})
    ];
  };

  gtk.iconCache.enable = true;

  environment.enableAllTerminfo = lib.mkDefault true;

  xdg = {
    icons.enable = true;
    mime.enable = true;
    menus.enable = true;

    sounds.enable = true;
  };
}
