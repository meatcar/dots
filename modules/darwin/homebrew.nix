{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    taps = [
      "barutsrb/tap"
      "oven-sh/bun"
      "steipete/tap"
      "theboredteam/boring-notch"
    ];
    brews = [
      "container"
      "mas"
      "neovim"
      "node@22"
      "oven-sh/bun/bun"
      "syncthing"
    ];
    casks = [
      "1password"
      "1password-cli"
      "activitywatch"
      "appcleaner"
      "applite"
      "barutsrb/tap/omniwm"
      "claude"
      "claude-code"
      "cmux"
      "codex"
      "docker-desktop"
      "font-iosevka-nerd-font"
      "helium-browser"
      "hiddenbar"
      "microsoft-edge"
      "obsidian"
      "raycast"
      "stats"
      "steipete/tap/codexbar"
      "t3-code"
      "tailscale-app"
      "theboredteam/boring-notch/boring-notch"
      "visual-studio-code"
      "warp"
      "whatsapp"
      "zed"
      "zen"
    ];
    # No masApps: the Mac App Store apps on this machine (Pages,
    # Synctrain, Sink It for Reddit, uBlock Origin Lite, 1Password for
    # Safari) were installed under amanda's Apple ID. mas runs as
    # system.primaryUser (denys) and can't reinstall apps it doesn't
    # own, so brew bundle fails. Leave them unmanaged.
  };
}
