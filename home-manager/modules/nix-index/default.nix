{ pkgs, specialArgs, ... }: {
  imports = [
    specialArgs.nix-index-database.hmModules.nix-index
  ];
  programs.nix-index.enable = true;
}
