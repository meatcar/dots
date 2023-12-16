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

  wsl = {
    enable = true;
    defaultUser = "meatcar";
    nativeSystemd = true;
    interop.register = true;
    wslConf = {
      network.hostname = "nixos";
      interop.enabled = true;
      interop.appendWindowsPath = false; # slows down some apps
    };
  };

  time.timeZone = "America/Toronto";

  networking.firewall.enable = true;

  services.sshd.enable = true;

  hardware.opengl.extraPackages = [pkgs.mesa.drivers];
  hardware.opengl.driSupport32Bit = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  programs.fish.enable = true;
  users.users.${config.wsl.defaultUser} = {
    shell = pkgs.fish;
    extraGroups = ["docker"];
    isNormalUser = true;
  };

  # TODO fix for https://github.com/nix-community/NixOS-WSL/issues/185
  systemd.services.nixs-wsl-systemd-fix = {
    description = "Fix the /dev/shm symlink to be a mount";
    unitConfig = {
      DefaultDependencies = "no";
      Before = ["sysinit.target" "systemd-tmpfiles-setup-dev.service" "systemd-tmpfiles-setup.service" "systemd-sysctl.service"];
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils-full}/bin/rm /dev/shm"
        "/run/wrappers/bin/mount --bind -o X-mount.mkdir /run/shm /dev/shm"
      ];
    };
    wantedBy = ["sysinit.target"];
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
