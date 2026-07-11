{
  pkgs,
  self,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/darwin/homebrew
    ../../modules/darwin/auto-update
  ];

  environment.systemPackages = with pkgs; [
    neovim
    nil
    nixfmt
    nh
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.oxfmt
  ];

  nix.settings = {
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

  nix.optimise = {
    automatic = true;
    interval = {
      Hour = 3;
      Minute = 15;
      Weekday = 0;
    };
  };
  nix.gc = {
    automatic = true;
    interval = {
      Hour = 3;
      Minute = 30;
      Weekday = 0;
    };
    options = "--delete-older-than 30d";
  };

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    end
  '';

  # Homebrew lives under denys's UID, so its zsh fpath dirs trip compinit's
  # insecure-owner check for other users (e.g. amanda). Take over nix-darwin's
  # default init so we can pass `-u` (use insecure dirs without prompting).
  programs.zsh.enableCompletion = false;
  programs.zsh.enableBashCompletion = false;
  programs.zsh.interactiveShellInit = ''
    autoload -U compinit && compinit -u
    autoload -U bashcompinit && bashcompinit
  '';

  users.users.denys = {
    home = "/Users/denys";
    shell = pkgs.fish;
  };
  users.users.amanda.home = "/Users/amanda";

  environment.variables.NH_FLAKE = "/Users/denys/git/hub/meatcar/darwin";

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 7;
  system.primaryUser = "denys";
  nixpkgs.hostPlatform = "aarch64-darwin";
}
