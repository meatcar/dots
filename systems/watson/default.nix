{...}: {
  imports = [
    ./disko.nix
    ../../modules/impermanence
    ../common.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ];
  system.stateVersion = "24.11";
}
