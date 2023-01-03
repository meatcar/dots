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
    startMenuLaunchers = true; # we do it ourselves
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
