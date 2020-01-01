{ config, pkgs, lib, ... }:
let
  sources = import ../nix/sources.nix;
in
{
  imports = [ "${sources.home-manager}/nixos" ];

  users.mutableUsers = false;
  users.users.meatcar = {
    isNormalUser = true;
    useDefaultShell = false;
    shell = "/run/current-system/sw/bin/fish";
    # nix-shell -p mkpasswd --command 'mkpasswd -m sha-512'
    hashedPassword = "$6$d60LJzot5J$PeWx9sU6rPNEy39uSewpJiV5CfOh9McENT5Crl4WCFyvwL/5jyH7Jn2pENG6pEWPNNFl2Xnp4WGEJEMAU2Mym0";
    extraGroups = [ "wheel" "video" "docker" "networkmanager" ];
  };

  home-manager.users.meatcar = { pkgs, ... }: {
    imports = [
      ../home-manager
      ../home-manager/modules/gnome-keyring.nix
      ../home-manager/modules/alacritty
      ../home-manager/modules/firefox
      ../home-manager/modules/email
      ../home-manager/modules/neomutt
    ];

    xdg.configFile = {
      "sway" = {
        source = ../conf/sway/.config/sway;
        onChange = "swaymsg -qt send_tick && swaymsg reload";
      };
      "swaylock".source = ../conf/sway/.config/swaylock;
      "wldash".source = ../conf/sway/.config/wldash;
      "waybar".source = ../conf/waybar/.config/waybar;
      "mako".source = ../conf/mako/.config/mako;
      "redshift".source = ../conf/redshift/.config/redshift;
    };

    services = {
      syncthing.enable = true;
      keybase.enable = true;
      kbfs.enable = true;
    };

    gtk = {
      enable = true;
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus-Dark";
      theme.package = pkgs.plata-theme;
      theme.name = "Plata-Noir-Compact";
      font.package = pkgs.roboto;
      font.name = "Roboto 9";
    };

    programs.neovim.package = lib.mkForce pkgs.neovim-unwrapped;
    programs.zathura.enable = true;
  };
}
