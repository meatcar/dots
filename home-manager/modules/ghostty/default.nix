{...}: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      font-family = "Iosevka NF";
      font-size = 10;
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
      link-url = true;
    };
  };
}
