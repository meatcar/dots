{ config, pkgs, specialArgs, ... }:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      theme = "catppuccin";
    };
    # use third-party zellij package that provides plugins until issue is fixed:
    # https://github.com/NixOS/nixpkgs/issues/197377
    package = specialArgs.inputs.zellij.packages."${pkgs.system}".default;
  };
}
