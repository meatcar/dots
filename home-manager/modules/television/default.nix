{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  programs.nix-search-tv.enable = true;
  programs.television = {
    enable = true;
    package = nixpkgs-unstable.television;
    settings = {
      ui = {
        use_nerd_font_icons = true;
      };
      shell_integration.channel_triggers.zoxide = [ "z" ];
    };
    channels.git-dirs = {
      metadata = {
        description = "A channel to select git directories";
        name = "zoxide";
      };
      preview = {
        command = "ls -la '{0}'";
      };
      source = {
        command = "${pkgs.zoxide}/bin/zoxide query --list";
      };
    };
    channels.git-ignore = {
      metadata = {
        description = "Select .gitignore templates from github/gitignore";
        name = "git-ignore";
      };
      preview = {
        command = "${pkgs.gibo}/bin/gibo dump '{0}'";
      };
      source = {
        command = "${pkgs.gibo}/bin/gibo list";
      };
    };
    enableFishIntegration = config.programs.fish.enable;
  };
  # Ctrl+R override lives in modules/fish (binds to fzf.fish).
}
