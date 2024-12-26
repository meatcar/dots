{
  pkgs,
  specialArgs,
  ...
}: {
  imports = [
    specialArgs.inputs.nix-index-database.hmModules.nix-index
  ];
  programs.nix-index.enable = true;
  # TODO: fixes https://github.com/nix-community/nix-index-database/issues/134
  # programs.nix-index-database.comma.enable = true;
}
