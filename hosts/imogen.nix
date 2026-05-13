{ pkgs, self, ... }:
{
  imports = [ ../modules/darwin/homebrew.nix ];

  environment.systemPackages = with pkgs; [
    neovim
    nil
    nixfmt
    nh
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

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  system.primaryUser = "denys";
  nixpkgs.hostPlatform = "aarch64-darwin";
}
