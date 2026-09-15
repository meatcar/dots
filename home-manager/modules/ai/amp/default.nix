{
  config,
  lib,
  pkgs,
  llm-agents,
  osConfig,
  ...
}:
let
  profiles = config.me.amp.profiles;
  wrappers = lib.mapAttrs (
    name: profile:
    pkgs.writeShellApplication {
      name = "amp-${profile.alias}";
      runtimeInputs = [
        pkgs.bubblewrap
        pkgs.coreutils
      ];
      text =
        builtins.replaceStrings
          [ "@amp@" "@account@" ]
          [ "${llm-agents.amp}/bin/amp" (lib.escapeShellArg name) ]
          (builtins.readFile ./amp-account.sh);
    }
  ) profiles;
in
{
  options.me.amp.profiles = lib.mkOption {
    default = { };
    description = "Isolated Amp profiles and optional background runners.";
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, config, ... }:
        {
          options = {
            alias = lib.mkOption {
              type = lib.types.strMatching "[a-zA-Z0-9][a-zA-Z0-9-]*";
              default = name;
              description = "Command suffix for amp-<alias>.";
            };
            runner = {
              directory = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Working directory to serve; null disables the runner.";
              };
              id = lib.mkOption {
                type = lib.types.strMatching "[a-zA-Z0-9][a-zA-Z0-9-]*";
                readOnly = true;
                default = "${osConfig.networking.hostName}";
                description = "Runner ID derived from the hostname.";
              };
              exclude = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Directory discovery exclusions.";
              };
            };
          };
        }
      )
    );
  };

  config = {
    assertions = [
      {
        assertion = lib.all (name: builtins.match "[a-zA-Z0-9][a-zA-Z0-9-]*" name != null) (
          builtins.attrNames profiles
        );
        message = "Amp profile names must contain only letters, digits and hyphens, starting with a letter or digit.";
      }
      {
        assertion =
          let
            aliases = map (profile: profile.alias) (builtins.attrValues profiles);
          in
          builtins.length aliases == builtins.length (lib.unique aliases);
        message = "Amp profile aliases must be unique.";
      }
    ];

    home.packages = builtins.attrValues wrappers;
    systemd.user.services = lib.mapAttrs' (
      name: profile:
      lib.nameValuePair "amp-runner-${name}" {
        Unit = {
          Description = "Amp ${name} runner";
          StartLimitIntervalSec = 0;
        };
        Service = {
          Type = "exec";
          WorkingDirectory = profile.runner.directory;
          ExecStart = lib.escapeShellArgs (
            [
              (lib.getExe wrappers.${name})
              "--no-tui"
              "--runner-id"
              profile.runner.id
              "--discover-dirs=${profile.runner.directory}"
              "--discover-depth"
              "5"
              "--remote-control-terminal"
              "--amp-env"
            ]
            ++ lib.concatMap (pattern: [
              "--discover-exclude"
              pattern
            ]) profile.runner.exclude
          );
          Environment = [ "AMP_SKIP_UPDATE_CHECK=1" ];
          Restart = "always";
          RestartSec = 15;
        };
        Install.WantedBy = [ "default.target" ];
      }
    ) (lib.filterAttrs (_: profile: profile.runner.directory != null) profiles);
  };
}
