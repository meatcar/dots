{ pkgs, ... }:
{
  # Allow rootless podman/traefik to bind port 80 for local container routing
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  virtualisation.containers = {
    enable = true;

    # Default to docker.io for unqualified image names so podman doesn't
    # prompt interactively (which hangs non-interactive tools like devcontainers).
    registries.search = [ "docker.io" ];

    # Use file-based event logger instead of journald. The journald backend
    # drops new events when streaming with --filter event=<type>, which causes
    # devcontainers to hang waiting for container start events.
    # TODO: remove when fixed upstream https://github.com/containers/podman/issues/21685
    containersConf.settings.engine.events_logger = "file";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # NixOS sets a default PATH for systemd user services that excludes
  # /run/wrappers/bin. The podman pause process needs newuidmap/newgidmap
  # (setuid binaries in /run/wrappers/bin) for rootless subordinate UID/GID
  # mappings. Without them, the pause process gets size=1 mappings and all
  # subsequent podman operations (including builds) fail.
  systemd.user.services.podman.path = [ "/run/wrappers" ];

  # Suppress per-request access logs from the podman API socket service.
  # The package unit uses $LOGGING as the log-level flag; override it here
  # rather than rewriting ExecStart.
  systemd.services.podman.environment.LOGGING = "--log-level=warning";
  systemd.user.services.podman.environment.LOGGING = "--log-level=warning";

  environment.systemPackages = with pkgs; [
    runc
    conmon
    skopeo
    fuse-overlayfs
    passt
    slirp4netns
  ];
}
