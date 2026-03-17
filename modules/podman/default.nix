{
  nixpkgs-unstable,
  ...
}:
{
  virtualisation.containers.enable = true;
  virtualisation.containers.storage.settings.storage = {
    # driver = "fuse-overlayfs";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
    package = nixpkgs-unstable.podman;
  };

  # NixOS sets a default PATH for systemd user services that excludes
  # /run/wrappers/bin. The podman pause process needs newuidmap/newgidmap
  # (setuid binaries in /run/wrappers/bin) for rootless subordinate UID/GID
  # mappings. Without them, the pause process gets size=1 mappings and all
  # subsequent podman operations (including builds) fail.
  systemd.user.services.podman.path = [ "/run/wrappers" ];

  environment.systemPackages = with nixpkgs-unstable; [
    runc
    conmon
    skopeo
    fuse-overlayfs
    passt
    slirp4netns
  ];
}
