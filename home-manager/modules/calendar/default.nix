{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.me.calendar.accounts;
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
          collections = [
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
    };
}
