{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # Upstream's scripts/trace-daemon.mjs harvests node-pty's native addon via a
  # single glob pinned to the *hoisted* path (node_modules/node-pty/...). npm's
  # hoisting is not a contract: the beta.11->beta.15 bump de-hoisted node-pty to
  # packages/server/node_modules, so the glob matched nothing and pty.node
  # silently dropped from $out -> "Terminal worker is not running" at runtime.
  # See getpaseo/paseo scripts/trace-daemon.mjs. Two fixes, upstreamable:
  #   1. self-heal: also harvest node-pty's native at any depth (hoisted or not),
  #      covering both prebuilds/ (prebuild.js) and build/Release (node-gyp).
  #   2. fail-loud: abort the build if no pty.node lands in the closure, so this
  #      whole class of missing-native regressions can never ship silently.
  # npm-deps.hash in the paseo repo is computed against their nixpkgs; our pin
  # produces a different fetchNpmDeps hash, so override it (the package exposes
  # npmDepsHash for exactly this — overrideAttrs can't reach it).
  paseo =
    (inputs.paseo.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      npmDepsHash = "sha256-oXz8hMk+5DlTYK8OndUAjB+RJMDbPqobVGXLFeoH++o=";
    }).overrideAttrs
      (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace scripts/trace-daemon.mjs \
            --replace-fail \
              '`node_modules/node-pty/prebuilds/''${process.platform}-''${process.arch}/**`,' \
              '`node_modules/node-pty/prebuilds/''${process.platform}-''${process.arch}/**`,
            `**/node_modules/node-pty/prebuilds/''${process.platform}-''${process.arch}/**`,
            `**/node_modules/node-pty/build/Release/*.node`,'
        '';
        postInstall = (old.postInstall or "") + ''
          if [ -z "$(find "$out" -name pty.node -path '*node-pty*' -print -quit)" ]; then
            echo "FATAL: node-pty native (pty.node) missing from closure; terminals would fail" >&2
            exit 1
          fi
        '';
      });
  envFile = config.age.secrets.paseoEnv.path;

  # source the daemon's env at exec time so PASEO_PASSWORD stays out of shells.
  # NOTE: password rides in websocket subprotocol paseo.bearer.<pw>, so it must
  # be an RFC7230 token — base64 with '/' kills the client before it connects
  paseoCli = pkgs.symlinkJoin {
    name = "paseo-cli";
    paths = [ paseo ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/paseo \
        --run 'if [ -r "${envFile}" ]; then set -a; . "${envFile}"; set +a; fi'
    '';
  };
in
{
  home.packages = [ paseoCli ];

  programs.fish.completions.paseo.body = ''
    function __fish_paseo_subcommands
      set -l command ${paseo}/bin/paseo
      set -l words (commandline -opc)
      set -e words[1]

      for word in $words
        string match -q -- '-*' $word; and continue
        set -l subcommands ($command --help 2>/dev/null | string match -rg '^\s{2}([a-z][a-z0-9-]*)\s')
        contains -- $word $subcommands; or continue
        set -a command $word
      end

      $command --help 2>/dev/null | string match -rg '^\s{2}([a-z][a-z0-9-]*)\s'
    end

    complete -c paseo -f -a '(__fish_paseo_subcommands)'
  '';

  systemd.user.services.paseo = {
    Unit = {
      Description = "Paseo daemon";
      # Wants, not Requires: HM restarts agenix every activation, and
      # Requires would stop us with it and never start us back
      After = [ "agenix.service" ];
      Wants = [ "agenix.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${paseo}/bin/paseo-server";
      EnvironmentFile = config.age.secrets.paseoEnv.path;
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "PASEO_HOME=${config.home.homeDirectory}/.paseo"
        "PASEO_LISTEN=127.0.0.1:6767"
        # serve the bundled web UI from the daemon itself (defaults off); accessed
        # over localhost only, so UI packets never reach app.paseo.sh
        "PASEO_WEB_UI_ENABLED=true"
        "PASEO_RELAY_ENABLED=true"
        "PASEO_RELAY_USE_TLS=true"
        "PASEO_RELAY_PUBLIC_USE_TLS=true"
      ];
      Restart = "on-failure";
      RestartSec = 5;
      KillSignal = "SIGTERM";
      TimeoutStopSec = 15;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
