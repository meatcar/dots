{...}: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      font-family = "Iosevka NF";
      font-size = 10;
      font-feature = "ss07";
      freetype-load-flags = "no-force-autohint";
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
      link-url = true;
    };
  };
}
