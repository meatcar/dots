{
  config,
  lib,
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
    enableFishIntegration = config.programs.fish.enable;
  };

  # Restore fish's built-in ctrl-r history search; tv binds it unconditionally
  programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.enable (
    lib.mkAfter ''
      bind --mode default ctrl-r history-pager
      bind --mode insert ctrl-r history-pager
    ''
  );
}
