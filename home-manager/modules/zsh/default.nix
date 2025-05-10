{
  imports = [ ../starship ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    historySubstringSearch.enable = true;
    dotDir = ".config/zsh";
    initExtra = ''
      ${builtins.readFile ./keybinds.zsh}
    '';
  };
}
