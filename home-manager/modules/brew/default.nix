{ pkgs, config, ... }:
let
  brewWrapper = pkgs.writeShellApplication {
    name = "brew";
    runtimeInputs = [ pkgs.jq ];
    text = builtins.readFile ./brew.sh;
  };
in
{
  imports = [ ./no-self-update.nix ];

  home.packages = [ brewWrapper ];

  # /opt/homebrew/bin sits ahead of the per-user profile in fish's PATH, so
  # alias the wrapper in for fish users; zsh picks it up from PATH order.
  programs.fish.shellAliases.brew = "${config.home.profileDirectory}/bin/brew";
}
