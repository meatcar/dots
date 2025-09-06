{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./common.nix
    ../modules/gtk.nix
    ../modules/gnome-keyring.nix
    ../modules/email
  ];

  home.sessionVariables = {
    BROWSER = "x-www-browser";
  };

  home.packages = [
    (lib.mkForce (
      pkgs.writeShellScriptBin "get-theme" ''
        THEME_FILE=''${THEME_FILE:-/mnt/c/Users/${config.home.username}/.config/theme}
        cat "$THEME_FILE" 2>&1 || echo dark
      ''
    ))
  ];

  # fish is the default shell. hide it.
  programs.starship.settings.shell.fish_indicator = "";

  programs.fish.plugins = [
    {
      name = "fish-ssh-agent";
      src = inputs.fish-ssh-agent;
    }
  ];

  programs.fish.interactiveShellInit = "set -x COLORTERM truecolor";

  programs.fish.functions.osc7_prompt = {
    onEvent = "fish_prompt";
    body = ''
      if grep -q Microsoft /proc/version
        printf "\033]7;file://%s\033\\" (wslpath -w "$PWD")
      end
    '';
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=10";
        pad = "8x8center";
      };
    };
  };
}
