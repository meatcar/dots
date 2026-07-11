{
  imports = [
    (import ./mkUser.nix {
      fullName = "Denys Pavlov";
      email = "github@denys.me";
    })
  ];

  # Caps Lock → Escape on tap, Left Control on hold.
  home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
    profiles = [
      {
        name = "Default profile";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        complex_modifications.rules = [
          {
            description = "Caps Lock → Escape (tap) / Left Control (hold)";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers.optional = [ "any" ];
                };
                to = [
                  {
                    key_code = "left_control";
                    lazy = true;
                  }
                ];
                to_if_alone = [ { key_code = "escape"; } ];
              }
            ];
          }
        ];
      }
    ];
  };

  targets.darwin.defaults = {
    NSGlobalDomain = {
      AppleLanguages = [ "en-CA" ];
      AppleLocale = "en_CA";
      AppleInterfaceStyleSwitchesAutomatically = true;
      ApplePressAndHoldEnabled = false; # hold key = repeat (vs accent popup)
      InitialKeyRepeat = 25;
      KeyRepeat = 2;
      AppleMiniaturizeOnDoubleClick = false;
      AppleShowAllExtensions = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false; # no double-space → "."
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      # *2 variants cover newer-API apps; both keys needed for full coverage
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
    "com.apple.dock" = {
      autohide = true;
      "expose-group-apps" = true; # Mission Control groups windows by app
      "show-recents" = false;
      "mru-spaces" = false; # don't reorder spaces by recency
      "autohide-delay" = 0.0;
      "autohide-time-modifier" = 0.5; # show/hide animation duration multiplier
    };
    "com.apple.finder" = {
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXSortFoldersFirst = true;
      FXPreferredViewStyle = "clmv"; # Nlsv list, clmv column, icnv icon, Flwv coverflow
    };
    "com.apple.screencapture" = {
      location = "/Users/denys/Pictures/Screenshots";
      type = "png";
      "disable-shadow" = true;
    };
    "com.apple.menuextra.clock" = {
      ShowDate = 0; # 0 = when space allows, 1 = always, 2 = never
      ShowDayOfWeek = true;
    };
    "com.apple.WindowManager" = {
      HideDesktop = true; # hide desktop icons (click wallpaper to reveal)
    };
    # tap-to-click off — both domains needed: built-in + Bluetooth (Magic Trackpad)
    "com.apple.AppleMultitouchTrackpad" = {
      Clicking = false;
    };
    "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
      Clicking = false;
    };
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };

  launchd.agents.syncthing = {
    enable = true;
    config = {
      ProgramArguments = [
        "/opt/homebrew/bin/syncthing"
        "serve"
        "--no-browser"
        "--no-restart"
        "--logflags=0"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/Users/denys/Library/Logs/syncthing.log";
      StandardErrorPath = "/Users/denys/Library/Logs/syncthing.log";
    };
  };
}
