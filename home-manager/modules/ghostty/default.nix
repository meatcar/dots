{ nixpkgs-unstable, ... }:
{
  programs.ghostty = {
    enable = true;
    package = nixpkgs-unstable.ghostty;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      font-family = "Iosevka Term SS07";
      font-size = 10;
      font-feature = "ss07";
      freetype-load-flags = "no-force-autohint"; # let the font hint itself
      theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
      link-url = true;
      window-padding-x = 4;
      window-padding-y = 1;
      window-padding-balance = true;
      window-padding-color = "extend";
      window-theme = "ghostty";
      quit-after-last-window-closed = false;
      shell-integration-features = true;
    };
  };
}
