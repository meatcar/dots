{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            neovim
            nil
            nixfmt
            nh
          ];
          nix.settings = {
            # Necessary for using flakes on this system.
            experimental-features = "nix-command flakes";
            always-allow-substitutes = true;
            max-jobs = "auto";
            extra-trusted-substituters = [ "https://cache.lix.systems" ];
            extra-trusted-public-keys = [
              "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
            ];
            bash-prompt-prefix = "(nix:$name)\\040";
            extra-nix-path = [ "nixpkgs=flake:nixpkgs" ];
          };

          # Enable alternative shell support in nix-darwin.
          programs.fish.enable = true;
          programs.fish.interactiveShellInit = ''
            if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
              source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
            end
          '';

          users.users.denys = {
            home = "/Users/denys";
            shell = pkgs.fish;
          };

          environment.variables.NH_FLAKE = "/Users/Shared/nix-darwin";

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

          launchd.user.agents.syncthing = {
            command = "/opt/homebrew/bin/syncthing serve --no-browser --no-restart --logflags=0";
            serviceConfig = {
              KeepAlive = true;
              RunAtLoad = true;
              StandardOutPath = "/Users/denys/Library/Logs/syncthing.log";
              StandardErrorPath = "/Users/denys/Library/Logs/syncthing.log";
            };
          };

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;
          system.primaryUser = "denys";

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Amandas-MacBook-Air
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;

      darwinConfigurations."imogen" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "denys";
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.users.denys =
              { pkgs, ... }:
              let
                userName = "Denys Pavlov";
                userEmail = "github@denys.me";
              in
              {
                home.stateVersion = "25.11";
                programs.fish = {
                  enable = true;
                  shellInit = ''
                    fish_add_path "$HOME/.local/bin"
                    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
                  '';
                };
                programs.yazi = {
                  enable = true;
                  enableFishIntegration = true;
                };
                programs.jujutsu = {
                  enable = true;
                  settings.user = {
                    name = userName;
                    email = userEmail;
                  };
                };
                programs.bat.enable = true;
                programs.git = {
                  enable = true;
                  settings.user.name = userName;
                  settings.user.email = userEmail;
                };
                programs.gh.enable = true;
                programs.starship = {
                  enable = true;
                  enableFishIntegration = true;
                };
                programs.lazygit.enable = true;
                programs.jjui.enable = true;
                programs.direnv = {
                  enable = true;
                  nix-direnv.enable = true;
                };
              };
          }
        ];
      };
    };
}
