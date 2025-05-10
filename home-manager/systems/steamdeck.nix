{ pkgs, ... }:
{
  imports = [ ./single-user.nix ];
  home.packages = with pkgs; [
    gocryptfs
    fuse-overlayfs
    wireguard-tools
  ];

  programs.ssh.matchBlocks = {
    "*" = {
      identityFile = "~/.ssh/keys/id_ed25519";
    };
  };
}
