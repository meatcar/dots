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
    startMenuLaunchers = false; # we do it ourselves
    wslConf = {
      network.hostname = "nixos";
      interop.appendWindowsPath = false; # slows down some apps
    };
  };

  networking.firewall.enable = true;

  hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
  hardware.opengl.driSupport32Bit = true;

  users.users.${config.wsl.defaultUser} = {
    shell = pkgs.fish;
    extraGroups = [ "docker" ];
  };

  system.activationScripts.copy-launchers =
    pkgs.lib.stringAfter [ ] ''
      for x in applications icons; do
        echo "Copying /usr/share/$x"
        mkdir -p /usr/share/$x
        ${pkgs.rsync}/bin/rsync -a --delete $systemConfig/sw/share/$x/. /usr/share/$x
        ${pkgs.rsync}/bin/rsync -a /nix/var/nix/profiles/per-user/${config.wsl.defaultUser}/home-manager/home-path/share/$x/. /usr/share/$x
      done
    '';

  environment.systemPackages = [
    pkgs.wget
    (pkgs.writeShellScriptBin "powershell.exe" ''
      /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NonInteractive –ExecutionPolicy Bypass "$@"
    '')
  ];
}
