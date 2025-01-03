{
  config,
  pkgs,
  lib,
  ...
}: {
  nix.settings.trusted-users = ["meatcar"];
  users.mutableUsers = false;
  users.users.meatcar = {
    isNormalUser = true;
    useDefaultShell = false;
    shell = "/run/current-system/sw/bin/fish";
    # nix-shell -p mkpasswd --command 'mkpasswd -m sha-512'trustedUsers
    hashedPassword = "$6$d60LJzot5J$PeWx9sU6rPNEy39uSewpJiV5CfOh9McENT5Crl4WCFyvwL/5jyH7Jn2pENG6pEWPNNFl2Xnp4WGEJEMAU2Mym0";
    extraGroups = ["wheel" "video" "docker" "networkmanager" "power" "input"];
  };

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.meatcar = {pkgs, ...}: {
    imports = [
      ../home-manager/systems/single-user.nix
      ../home-manager/modules/gtk.nix
      ../home-manager/modules/gnome-keyring.nix
      ../home-manager/modules/egpu.nix
      ../home-manager/modules/sway
      ../home-manager/modules/kanshi
      ../home-manager/modules/alacritty
      ../home-manager/modules/firefox
      ../home-manager/modules/mpv.nix
      ../home-manager/modules/spotifyd.nix
      ../home-manager/modules/gammastep.nix
      ../home-manager/modules/email
      ../home-manager/modules/neomutt
      ../home-manager/modules/qutebrowser
    ];

    config = {
      home = {
        username = "meatcar";
        homeDirectory = "/home/meatcar";
        packages = [
          pkgs.dconf # dconf.settings
        ];
      };

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

      programs.neovim.package = lib.mkForce pkgs.neovim-unwrapped;
      programs.zathura.enable = true;
    };
  };
}
