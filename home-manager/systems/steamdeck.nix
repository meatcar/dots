{ pkgs, ... }:
{
  imports = [ ./single-user.nix ];
  home.packages = with pkgs; [
    gocryptfs
    fuse-overlayfs
    wireguard-tools
  ];

  programs.ssh.settings."*".IdentityFile = "~/.ssh/keys/id_ed25519";
}
