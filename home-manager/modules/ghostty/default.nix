{ config, nixpkgs-unstable, ... }:
{
  # NOTE: HM links the shipped unit but leaves starting it to D-Bus activation.
  # Bind it to the session instead: `ghostty +new-window` is an IPC client, so
  # Mod+Return needs a primary instance already alive to talk to.
  xdg.configFile."systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source =
    "${config.programs.ghostty.package}/share/systemd/user/app-com.mitchellh.ghostty.service";

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
      gtk-single-instance = true;
    };
  };
}
