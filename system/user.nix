{ config, pkgs, lib, ... }:
{
  imports = [
    <home-manager/nixos>
  ];

  users.mutableUsers = false;
  users.users.meatcar = {
    isNormalUser = true;
    useDefaultShell = false;
    shell = "/run/current-system/sw/bin/fish";
    # nix-shell -p mkpasswd --command 'mkpasswd -m sha-512'
    hashedPassword = "$6$d60LJzot5J$PeWx9sU6rPNEy39uSewpJiV5CfOh9McENT5Crl4WCFyvwL/5jyH7Jn2pENG6pEWPNNFl2Xnp4WGEJEMAU2Mym0";
    extraGroups = [ "wheel" "video" "docker" "networkmanager" "power" ];
  };

  home-manager.users.meatcar = { pkgs, ... }: {
    imports = [
      ../home-manager
      ../home-manager/modules/gnome-keyring.nix
      ../home-manager/modules/sway
      ../home-manager/modules/kanshi
      ../home-manager/modules/alacritty
      ../home-manager/modules/firefox
      ../home-manager/modules/mpv.nix
      ../home-manager/modules/spotifyd.nix
      ../home-manager/modules/redshift.nix
      ../home-manager/modules/email
      ../home-manager/modules/neomutt
      ../home-manager/modules/emacs
      ../home-manager/modules/qutebrowser
    ];

    nixpkgs.config = config.nixpkgs.config;
    nixpkgs.overlays = config.nixpkgs.overlays;

    xdg.configFile = {
      "swaylock".source = ../conf/sway/.config/swaylock;
      "wldash".source = ../conf/sway/.config/wldash;
      "waybar".source = ../conf/waybar/.config/waybar;
      "mako".source = ../conf/mako/.config/mako;
    };

    services = {
      syncthing.enable = true;
      keybase.enable = true;
      kbfs.enable = true;
      udiskie.enable = true;
    };

    gtk = {
      enable = true;
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus-Dark";
      theme.package = pkgs.plata-theme;
      theme.name = "Plata-Noir-Compact";
      font.package = pkgs.google-fonts;
      font.name = "Roboto 9";
    };

    programs.neovim.package = lib.mkForce pkgs.neovim-unwrapped;
    programs.zathura.enable = true;
  };
}
