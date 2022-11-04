{ config, pkgs, ... }: 
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        auto-pairs = true;
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          select = "underline";
        };
        lsp.display-messages = true;
      }; 
    };
  };
}
