{ lib, pkgs, config, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ../common.nix
    ../../modules/docker.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "meatcar";
    nativeSystemd = true;
    wslConf = {
      network.hostname = "nixos";
      interop.enabled = true;
      interop.appendWindowsPath = false; # slows down some apps
    };
  };

  networking.firewall.enable = true;

  hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
  hardware.opengl.driSupport32Bit = true;

  programs.fish.enable = true;
  users.users.${config.wsl.defaultUser} = {
    shell = pkgs.fish;
    extraGroups = [ "docker" ];
    isNormalUser = true;
  };

  # override nixos-wsl startMenuLaunchers to pull in home-manager ones
  wsl.startMenuLaunchers = false; # we do it ourselves
  system.activationScripts.copy-launchers =
    pkgs.lib.stringAfter [ ] ''
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
    (pkgs.writeShellScriptBin "powershell.exe" ''
      /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NonInteractive –ExecutionPolicy Bypass "$@"
    '')
    (pkgs.writeShellScriptBin "x-www-browser" ''
      ${pkgs.wsl-open}/bin/wsl-open "$@"
    '')
  ];
}
