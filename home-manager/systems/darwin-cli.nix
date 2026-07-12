# The dots CLI stack (neovim, fish, jj, tmux, ...) adapted for darwin hosts.
# Linux hosts get these modules via ./common.nix; darwin users import this
# file instead, since common.nix also carries Linux-only concerns (podman,
# the agenix-backed nix.nix, direnv's systemd helpers, ...).
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/me.nix
    ../modules/fish
    ../modules/starship
    ../modules/git
    ../modules/jujutsu
    ../modules/hunk
    ../modules/neovim
    ../modules/helix
    ../modules/tmux
    ../modules/yazi
    ../modules/bat
    ../modules/lsd
    ../modules/btop
    ../modules/television
    ../modules/nix-index
    ../modules/man
  ];

  # Where this flake is checked out on darwin machines (mkOutOfStoreSymlink
  # targets, e.g. the live-editable neovim config).
  me.PRJ_ROOT = lib.mkDefault "${config.home.homeDirectory}/git/hub/meatcar/dots";

  home.sessionVariables.EDITOR = lib.mkDefault "nvim";

  # darkman (Linux-only) provides get-theme on NixOS; answer from the macOS
  # appearance setting instead so the bat wrapper & friends keep working.
  home.packages = [
    (pkgs.writeShellScriptBin "get-theme" ''
      if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
        echo dark
      else
        echo light
      fi
    '')
  ];

  # 1Password-backed commit signing isn't set up on this machine yet; drop
  # these overrides once `op-ssh-sign` works here.
  programs.git.settings.commit.gpgsign = lib.mkForce false;
  programs.jujutsu.settings.git.sign-on-push = lib.mkForce false;

  # The jujutsu module ships its own jjui wrapper via home.packages; keep the
  # baseline's programs.jjui (stable pkg) from adding a second bin/jjui.
  programs.jjui.enable = lib.mkForce false;
}
