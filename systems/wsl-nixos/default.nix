{ lib, pkgs, config, modulesPath, inputs, ... }:
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    inputs.nixos-wsl.nixosModules.wsl
    ../common.nix
    ../../modules/docker.nix
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "meatcar";
    startMenuLaunchers = true;
    wslConf = {
      network.hostname = "nixos";
    };
  };

  networking.firewall.enable = true;

  users.users.${config.wsl.defaultUser} = {
    shell = pkgs.fish;
    extraGroups = [ "docker" ];
  };
}
