{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ../common.nix
    ../../modules/agenix
    ../../modules/gtk.nix
    ../../modules/gnome-keyring.nix
    ../../modules/firefox
    ../../modules/gnome-shell
    ../../modules/1password
    # ../../modules/docker
    ../../modules/activitywatch
    ../../modules/ghostty
    ../../modules/obsidian
    ../../modules/vscode
    # ../../modules/zed
    ./impermanence.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    pciutils
    code-cursor
    (
      pkgs.writeShellScriptBin "aider" ''
        source ${config.age.secrets.aienv.path}
        ${pkgs.aider-chat}/bin/aider "$@"
      ''
    )
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["vivaldi" "vscode"];

  programs.chromium.enable = true;

  services.syncthing.enable = true;
  home.file."/git".source = config.lib.file.mkOutOfStoreSymlink "/git";
}
