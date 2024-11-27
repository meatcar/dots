{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ../common.nix
    ../../modules/docker.nix
    inputs.vscode-server.nixosModule
  ];
  services.vscode-server.enable = true;
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };

  wsl = {
    enable = true;
    defaultUser = "meatcar";
    nativeSystemd = true;
    interop.register = true;
    useWindowsDriver = true;
    wrapBinSh = false;
    wslConf = {
      network.hostname = "nixos";
      interop.enabled = true;
      interop.appendWindowsPath = false; # slows down some apps
    };
  };

  time.timeZone = "America/Toronto";

  networking.firewall.enable = true;

  services.openssh.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sudo.enableGnomeKeyring = true;
  security.pam.services.sshd.enableGnomeKeyring = true;

  hardware.opengl.extraPackages = [pkgs.mesa.drivers];
  hardware.opengl.driSupport32Bit = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  programs.fish.enable = true;
  users.users.${config.wsl.defaultUser} = {
    shell = pkgs.fish;
    extraGroups = ["docker"];
    isNormalUser = true;
  };

  # BUG: https://github.com/moby/moby/issues/48056#issuecomment-2315995230
  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
  };

  # override nixos-wsl startMenuLaunchers to pull in home-manager ones
  wsl.startMenuLaunchers = false; # we do it ourselves
  system.activationScripts.copy-launchers = pkgs.lib.stringAfter [] ''
    for x in applications icons; do
      echo -n "setting up /usr/share/''${x}..."
      systemdir=$systemConfig/sw/share/$x
      userdir=/nix/var/nix/profiles/per-user/${config.wsl.defaultUser}/home-manager/home-path/share/$x
      if [[ -d $systemdir ]]; then
        mkdir -p /usr/share/$x
        echo -n " system..."
        ${pkgs.rsync}/bin/rsync -ar --delete $systemdir/. /usr/share/$x
        if [[ -d $userdir ]]; then
          echo -n " home-manager..."
          ${pkgs.rsync}/bin/rsync -ar $userdir/ /usr/share/$x/
        fi
      else
        rm -rf /usr/share/$x
      fi
      echo
    done
  '';

  fonts.fontconfig = {
    hinting.style = "full";
    subpixel.rgba = "rgb";
  };

  environment.systemPackages = [
    pkgs.wget
    pkgs.wslu
    (pkgs.writeShellScriptBin "wslpath" ''
      ${pkgs.wslu}/bin/wslupath "$@"
    '')
    (pkgs.writeShellScriptBin "powershell.exe" ''
      /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NonInteractive –ExecutionPolicy Bypass "$@"
    '')
    (pkgs.writeShellScriptBin "x-www-browser" ''
      ${pkgs.wsl-open}/bin/wsl-open "$@"
    '')
  ];
}
