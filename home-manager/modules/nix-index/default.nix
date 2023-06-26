{ pkgs, specialArgs, ... }: {
  imports = [
    specialArgs.inputs.nix-index-database.hmModules.nix-index
  ];
  programs.nix-index.enable = true;
}
