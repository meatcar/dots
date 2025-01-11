{...}: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      font-family = "Iosevka NF";
      font-size = 11;
      font-feature = "ss07";
      freetype-load-flags = "no-force-autohint"; # let the font hint itself
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
      link-url = true;
      window-padding-x = 4;
      window-padding-y = 1;
      window-padding-balance = true;
      window-padding-color = "extend";
      window-theme = "ghostty";
    };
  };
}
