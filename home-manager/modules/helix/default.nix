{ config, pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        auto-pairs = true;
        auto-save = true;
        auto-format = true;
        indent-guides.render = true;
        cursorline = true;
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          select = "underline";
        };
        lsp.display-messages = true;
        statusline = {
          left = [ "mode" "spinner" ];
          center = [ "file-name" ];
          right = [ "selections" "primary-selection-length" "diagnostics" "workspace-diagnostics" "file-encoding" "file-line-ending" "file-type" "position-" ];
          mode.normal = "N";
          mode.insert = "I";
          mode.select = "S";
        };
      };
    };
    languages = [
      {
        name = "nix";
        auto-format = true;
      }
    ];
  };
}
