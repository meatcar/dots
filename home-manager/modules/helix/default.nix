{ config, pkgs, ... }: 
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "bogster";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          select = "underline";
        };
        lsp.display-messages = true;
      }; 
    };
  };
}
