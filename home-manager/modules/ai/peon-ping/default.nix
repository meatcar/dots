{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.peon-ping;

  configJson = builtins.toJSON {
    active_pack = cfg.activePack;
    inherit (cfg) volume;
    enabled = true;
    desktop_notifications = true;
    inherit (cfg) categories;
    annoyed_threshold = cfg.annoyedThreshold;
    annoyed_window_seconds = cfg.annoyedWindowSeconds;
    pack_rotation = cfg.packRotation;
    pack_rotation_mode = cfg.packRotationMode;
  };

  hookEvents = [
    "SessionStart"
    "Stop"
    "Notification"
    "UserPromptSubmit"
    "PermissionRequest"
  ];

  peonBin = lib.getExe cfg.package;

  # Manages peon-ping hook entries in ~/.claude/settings.json.
  # Usage: python3 script.py register <peon-bin> <events...>
  #        python3 script.py unregister <events...>
  manageHooksScript = pkgs.writeText "peon-ping-manage-hooks.py" ''
    import json, os, sys

    settings_path = os.path.expanduser("~/.claude/settings.json")

    settings = {}
    if os.path.isfile(settings_path):
        with open(settings_path) as f:
            settings = json.load(f)

    hooks = settings.get("hooks", {})

    def is_peon(h):
        return h.get("type") == "command" and "peon-ping" in h.get("command", "")

    def clean_event(event):
        entries = hooks.get(event, [])
        if isinstance(entries, dict):
            entries = [entries]
        for entry in entries:
            entry["hooks"] = [h for h in entry.get("hooks", []) if not is_peon(h)]
        entries = [e for e in entries if e.get("hooks")]
        return entries

    action = sys.argv[1]

    if action == "register":
        peon_bin = sys.argv[2]
        events = sys.argv[3:]
        for event in events:
            entries = clean_event(event)
            entries.append({
                "matcher": "",
                "hooks": [{
                    "type": "command",
                    "command": f"{peon_bin} {event}",
                    "timeout": 10,
                }],
            })
            hooks[event] = entries

    elif action == "unregister":
        events = sys.argv[2:]
        for event in events:
            entries = clean_event(event)
            if entries:
                hooks[event] = entries
            else:
                hooks.pop(event, None)

    settings["hooks"] = hooks

    os.makedirs(os.path.dirname(settings_path), exist_ok=True)
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
  '';
in
{
  options.programs.peon-ping = {
    enable = lib.mkEnableOption "peon-ping gaming audio notifications for Claude Code";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.peon-ping;
      description = "The peon-ping package to use.";
    };

    volume = lib.mkOption {
      type = lib.types.float;
      default = 0.5;
      description = "Playback volume (0.0 to 1.0).";
    };

    activePack = lib.mkOption {
      type = lib.types.str;
      default = "peon";
      description = "Active sound pack name.";
    };

    categories = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = {
        "session.start" = true;
        "task.acknowledge" = true;
        "task.complete" = true;
        "task.error" = true;
        "input.required" = true;
        "resource.limit" = true;
        "user.spam" = true;
      };
      description = "Notification categories to enable.";
    };

    packRotation = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of pack names for rotation.";
    };

    packRotationMode = lib.mkOption {
      type = lib.types.enum [
        "random"
        "sequential"
      ];
      default = "random";
      description = "Pack rotation mode.";
    };

    annoyedThreshold = lib.mkOption {
      type = lib.types.int;
      default = 3;
      description = "Number of rapid prompts before annoyed response.";
    };

    annoyedWindowSeconds = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Time window (seconds) for annoyed threshold.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];

      # symlink store packs into the runtime directory
      home.file.".claude/hooks/peon-ping/packs".source = "${cfg.package}/share/peon-ping/packs";

      # write config and register hooks in settings.json
      home.activation.peonPingSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PEON_DIR="$HOME/.claude/hooks/peon-ping"
        mkdir -p "$PEON_DIR"

        cat > "$PEON_DIR/config.json" << 'PEON_CONFIG_EOF'
        ${configJson}
        PEON_CONFIG_EOF

        run ${lib.getExe pkgs.python3} ${manageHooksScript} \
          register ${peonBin} ${lib.concatStringsSep " " hookEvents}
      '';
    })
    (lib.mkIf (!cfg.enable) {
      # remove peon-ping hooks from settings.json and clean up runtime dir
      home.activation.peonPingCleanup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${lib.getExe pkgs.python3} ${manageHooksScript} \
          unregister ${lib.concatStringsSep " " hookEvents}

        rm -rf "$HOME/.claude/hooks/peon-ping"
      '';
    })
  ];
}
