{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.me.calendar.accounts;
  khalMeetings = pkgs.writeShellApplication {
    name = "khal-meetings";
    runtimeInputs = [
      pkgs.khal
      pkgs.gawk
    ];
    text = builtins.readFile ./khal-meetings.sh;
  };
in
{
  options.me.calendar.accounts =
    let
      account.primaryCollection = lib.mkOption {
        type = lib.types.str;
        description = "Primary calendar";
      };
      account.primary = lib.mkOption {
        type = lib.types.bool;
        description = "Whether this account is primary";
        default = false;
      };
      account.addresses = lib.mkOption {
        type = with lib.types; listOf str;
        description = "Addresses associated with this account";
      };
      account.collections = lib.mkOption {
        type = with lib.types; nullOr (listOf str);
        default = null;
        description = "Explicit vdirsyncer collection ids to sync. null syncs all (from a/from b).";
      };
    in
    lib.mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          options = account;
        });
      description = "An attrset of <account nickname> => <account props>";
    };
  config =
    let
      accounts = builtins.mapAttrs (name: account: {
        inherit (account) primary primaryCollection;
        remote.type = "google_calendar";
        khal = {
          inherit (account) addresses;
          enable = true;
          color = "auto";
          type = "discover";
        };
        vdirsyncer = {
          enable = true;
          clientIdCommand = [
            "cat"
            "${config.age.secrets.gcalClientId.path}"
          ];
          clientSecretCommand = [
            "cat"
            "${config.age.secrets.gcalClientSecret.path}"
          ];
          tokenFile = "${config.xdg.dataHome}/vdirsyncer/${name}.token";
          conflictResolution = "remote wins";
          metadata = [
            "color"
            "displayname"
          ];
          collections =
            if account.collections != null then
              account.collections
            else
              [
                "from a"
                "from b"
              ];
        };
      }) cfg;
    in
    {
      accounts.calendar = {
        inherit accounts;
        basePath = "${config.xdg.dataHome}/calendars";
      };

      services.vdirsyncer.enable = true;
      systemd.user.services.vdirsyncer.Unit = {
        After = [ "agenix.service" ];
        Requires = [ "agenix.service" ];
      };
      # metasync fails on Google Workspace accounts (PROPPATCH rejected by Google CalDAV).
      # Prefix with '-' so failures are non-fatal and sync always runs.
      systemd.user.services.vdirsyncer.Service.ExecStart = lib.mkForce [
        "-${config.services.vdirsyncer.package}/bin/vdirsyncer metasync"
        "${config.services.vdirsyncer.package}/bin/vdirsyncer sync"
      ];
      programs.vdirsyncer.enable = true;

      programs.khal = {
        enable = true;
        locale = rec {
          timeformat = "%H:%M";
          dateformat = "%d/%m/%Y";
          datetimeformat = "${dateformat} ${timeformat}";
          longdateformat = "'%A, %d %B %Y'";
          longdatetimeformat = "'%A, %d %B %Y ${timeformat}'";
        };
        settings = {
          view =
            let
              fmt = time: "{calendar-color}{cancelled}${time} {title}{repeat-symbol}{alarm-symbol} {url}{reset}";
            in
            {
              agenda_day_format = "{bold}{name} - {date}{reset}";
              agenda_event_format = fmt "{start-end-time-style}";
              event_format = fmt "{start}-{end}";
              blank_line_before_day = true;
              frame = "width";
              theme = "light";
            };
          keybindings = {
            delete = "d";
            down = "j";
            up = "k";
            left = "h";
            right = "l";
            duplicate = "D";
            export = "x";
            external_edit = "e";
            log = "L";
            mark = "m";
            new = "n";
            other = "o";
            save = "ctrl s";
            search = "/";
            today = "t";
            view = "enter";
          };
        };
      };
      systemd.user.services.khal = {
        Unit = {
          Description = "Run khal after vdirsyncer to update khal cache";
          After = [ "vdirsyncer.service" ];
        };
        Service = {
          ExecStart = "${pkgs.khal}/bin/khal at";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "vdirsyncer.service" ];
        };
      };

      home.packages = [ khalMeetings ];

      programs.television.channels.khal-meetings = {
        metadata = {
          name = "khal-meetings";
          description = "Upcoming calendar events (14d); fuzzy-filter on title + description, open meeting links";
        };
        source = {
          command = "${khalMeetings}/bin/khal-meetings";
          # Columns: LINK \t TIME \t CALENDAR \t TITLE \t DESCRIPTION
          output = "{split:\t:0}";
          display = "{split:\t:1}  {split:\t:3}  ({split:\t:2})";
          no_sort = true;
        };
        preview = {
          command = "printf '%s\\n%s  %s\\n\\n%s\\n\\n%s\\n' '{split:\t:3}' '{split:\t:1}' '({split:\t:2})' '{split:\t:0}' '{split:\t:4}'";
        };
        keybindings = {
          "ctrl-o" = "actions:open-link";
        };
        actions = {
          "open-link" = {
            description = "Open meeting link in browser";
            command = "${pkgs.xdg-utils}/bin/xdg-open '{split:\t:0}'";
            mode = "fork";
          };
        };
      };
    };
}
