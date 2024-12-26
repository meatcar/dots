{
  config,
  pkgs,
  ...
}: {
  imports = [../starship];
  home.packages = [pkgs.fzf pkgs.bat];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    initExtra = ''
      ${builtins.readFile ./keybinds.zsh}
    '';
  };
}
