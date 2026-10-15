let
  # Ad-hoc `brew install`s recorded by the shared brew wrapper in
  # home-manager/modules/brew/brew.sh, so onActivation.cleanup doesn't remove them.
  extras = builtins.fromJSON (builtins.readFile ./brew-extras.json);
in
{
  environment.variables.HOMEBREW_UPGRADE_GREEDY = "1";

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "uninstall";
    taps = [
      "ampcode/tap"
      "oven-sh/bun"
      "theboredteam/boring-notch"
    ];
    brews = extras.brews ++ [
      "ampcode/tap/ampcode"
      "container"
      "mas"
      "neovim"
      "node@22"
      "oven-sh/bun/bun"
      "syncthing"
    ];
    casks = extras.casks ++ [
      "1password"
      "1password-cli"
      "activitywatch"
      "amp-app"
      "appcleaner"
      "applite"
      "omniwm"
      "bitwarden"
      "claude"
      "claude-code"
      "cmux"
      "codex"
      "codex-app"
      "docker-desktop"
      "gitfiend"
      "github"
      "helium-browser"
      "hiddenbar"
      "karabiner-elements"
      "microsoft-edge"
      "obsidian"
      "raycast"
      "shortcat"
      "sourcetree"
      "stats"
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
