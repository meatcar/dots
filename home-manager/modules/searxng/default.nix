# Socket-activated SearXNG in a rootless quadlet container. Nothing starts it
# at login. The socket starts the container; the proxy stops it when idle.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.searxng;

  # inside the container netns; the host uses cfg.{port,backendPort}
  internalPort = 8888;

  cacheDir = "${config.xdg.cacheHome}/searxng";
  cacheMount = "/cache";

  settingsFile = (pkgs.formats.yaml { }).generate "searxng-settings.yml" (
    lib.recursiveUpdate {
      use_default_settings = true;
      general = {
        instance_name = "searxng";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
      };
      server = {
        # all interfaces in the container netns; only the published port on
        # 127.0.0.1 reaches the host
        bind_address = "0.0.0.0";
        port = internalPort;
        # bot protection for public instances; it needs valkey for its
        # counters, and this instance is private
        limiter = false;
        public_instance = false;
      };
      # local agents query the json format
      search.formats = [
        "html"
        "json"
      ];
      # The first query after a start also runs each engine's bootstrap. The
      # upstream 3s then reports healthy engines as timed out.
      outgoing.request_timeout = 6.0;
      # Measured at this IP: only duckduckgo and bing answer a residential
      # single-user instance.
      engines = [
        # upstream disables bing; it gives half the results here
        {
          name = "bing";
          disabled = false;
        }
        # captcha at the first query
        {
          name = "startpage";
          disabled = true;
        }
        # HTTP 429, then self-suspends
        {
          name = "brave";
          disabled = true;
        }
        # access denied
        {
          name = "qwant";
          disabled = true;
        }
        # NOTE: google is enabled and silently parses to zero results
      ];
    } cfg.settings
  );

  # searxng-run is Flask's dev server; granian serves the same app over WSGI.
  # searx exposes no python package, so the deps come off the application
  # derivation and PYTHONPATH adds searx itself.
  pythonEnv = pkgs.python3.withPackages (ps: cfg.package.propagatedBuildInputs ++ [ ps.granian ]);

  healthCmd = builtins.toJSON [
    "/bin/curl"
    "-fsS"
    "-o"
    "/dev/null"
    "http://localhost:${toString internalPort}/healthz"
  ];

  image = pkgs.dockerTools.buildLayeredImage {
    name = "localhost/searxng";
    tag = "latest";
    contents = [
      pythonEnv
      pkgs.curl # health check
      pkgs.cacert
    ];
    config = {
      Entrypoint = [
        "/bin/granian"
        "--interface"
        "wsgi"
        "--no-ws"
        "--host"
        "0.0.0.0"
        "--port"
        (toString internalPort)
        "searx.webapp:app"
      ];
      Env = [
        "PYTHONPATH=${cfg.package}/${pkgs.python3.sitePackages}"
        "SEARXNG_SETTINGS_PATH=${settingsFile}"
        "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
        "HOME=/tmp"
        # searx writes its sqlite caches (engine traits, tokens) to $TMPDIR and
        # has no setting to move them. On tmpfs each idle stop drops them and
        # the next start re-bootstraps every engine.
        "TMPDIR=${cacheMount}"
      ];
    };
  };
in
{
  imports = [ ../quadlet ];

  options.services.searxng = {
    enable = lib.mkEnableOption "on-demand SearXNG metasearch";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.searxng;
      defaultText = lib.literalExpression "pkgs.searxng";
      description = "The searxng package the container image is built from.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = ''
        Port on 127.0.0.1 the activation socket listens on. This is the one to
        browse to and to hand to search clients.
      '';
    };

    backendPort = lib.mkOption {
      type = lib.types.port;
      default = 8889;
      description = ''
        Port on 127.0.0.1 the container publishes. Only the proxy talks to it;
        it exists because the socket already holds `port`.
      '';
    };

    idleTimeout = lib.mkOption {
      type = lib.types.str;
      default = "10min";
      description = "How long without a connection before proxy and container stop.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to an environment file defining SEARXNG_SECRET, e.g. an agenix
        secret. Required: searx refuses to start without a secret key.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings merged into settings.yml.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.quadlet = {
      images.searxng.imageConfig = {
        image = "docker-archive:${image}";
        tag = "localhost/searxng:latest";
      };

      containers.searxng = {
        # searxng-proxy.service starts this unit; with no active referrer
        # StopWhenUnneeded stops it within a second.
        autoStart = false;
        unitConfig = {
          StopWhenUnneeded = true;
          # Wants, not Requires: agenix restarts at each activation, and
          # Requires would stop this unit with it and never start it back
          After = [ "agenix.service" ];
          Wants = [ "agenix.service" ];
        };
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 5;
        };
        containerConfig = {
          image = config.virtualisation.quadlet.images.searxng.ref;
          name = "searxng";
          publishPorts = [ "127.0.0.1:${toString cfg.backendPort}:${toString internalPort}" ];
          environmentFiles = [ cfg.environmentFile ];
          volumes = [ "${cacheDir}:${cacheMount}" ];

          # notify = "healthy" holds the unit in activating until searxng
          # answers, so the proxy never connects to a dead port. The startup
          # probe runs each second; the regular interval would delay every
          # start by a full period.
          notify = "healthy";
          inherit healthCmd;
          healthInterval = "1m";
          healthStartupCmd = healthCmd;
          healthStartupInterval = "1s";
          healthStartupSuccess = 1;
          healthStartupRetries = 0; # probe forever; never restart the container

          dropCapabilities = [ "all" ];
          noNewPrivileges = true;
          readOnly = true; # the sqlite cache goes to quadlet's default ReadOnlyTmpfs
        };
      };
    };

    systemd.user.sockets.searxng-proxy = {
      Unit.Description = "SearXNG activation socket";
      Socket.ListenStream = "127.0.0.1:${toString cfg.port}";
      Install.WantedBy = [ "sockets.target" ];
    };

    systemd.user.services.searxng-proxy = {
      Unit = {
        Description = "SearXNG socket-activated proxy";
        Requires = [
          "searxng.service"
          "searxng-proxy.socket"
        ];
        After = [
          "searxng.service"
          "searxng-proxy.socket"
        ];
      };
      Service = {
        Type = "notify";
        ExecStart = lib.concatStringsSep " " [
          "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd"
          "--exit-idle-time=${cfg.idleTimeout}"
          "127.0.0.1:${toString cfg.backendPort}"
        ];
        PrivateTmp = true;
      };
    };
  };
}
