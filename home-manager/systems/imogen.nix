{ pkgs, config, ... }:
let
  # Shared `brew` wrapper — see brew.sh for what it does and why.
  brewWrapper = pkgs.writeShellApplication {
    name = "brew";
    runtimeInputs = [ pkgs.jq ];
    text = builtins.readFile ./brew.sh;
  };
in
{
  home.packages = [
    (pkgs.mactop.overrideAttrs (_: {
      doCheck = false;
    }))
    brewWrapper
  ];

  # /opt/homebrew/bin sits ahead of the per-user profile in fish's PATH, so
  # alias the wrapper in for fish users; zsh picks it up from PATH order.
  programs.fish.shellAliases.brew = "${config.home.profileDirectory}/bin/brew";

  programs.fish = {
    enable = true;
    shellInit = ''
      fish_add_path "$HOME/.local/bin"
      fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
    '';
  };
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish.shellAliases.yy = "y";
  programs.man.generateCaches = false;
  programs.bat.enable = true;
  programs.gh.enable = true;
  programs.git.ignores = [ ".DS_Store" ];
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    sensibleOnTop = true;
    baseIndex = 1;
    mouse = true;
  };
  programs.lazygit.enable = true;
  programs.jjui.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  targets.darwin.defaults.NSGlobalDomain.NSStatusItemSpacing = 8;
}
