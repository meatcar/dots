{ config, pkgs, ... }:
{
  programs.nix-search-tv.enable = true;
  programs.television = {
    enable = true;
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
    enableFishIntegration = config.programs.fish.enable;
  };
}
