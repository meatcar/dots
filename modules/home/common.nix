{
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
