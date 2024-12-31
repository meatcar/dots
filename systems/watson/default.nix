{...}: {
  imports = [
    ./disko.nix
    ../../modules/impermanence
    ../common.nix
  ];
  system.stateVersion = "24.11";
}
