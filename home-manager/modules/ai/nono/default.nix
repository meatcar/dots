{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    optional
    optionalAttrs
    types
    ;

  cfg = config.me.ai.nono;

  agents = {
    claude = {
      command = "claude";
      groups = [
        "node_runtime"
        "rust_runtime"
        "python_runtime"
        "linux_sysfs_read"
        "nix_runtime"
        "unlink_protection"
      ];
      openUrls = [
        "https://claude.ai"
        "https://claude.com"
        "https://api.anthropic.com"
        "https://platform.claude.com"
      ];
    };
    codex = {
      command = "codex";
      groups = [
        "node_runtime"
        "rust_runtime"
        "python_runtime"
        "linux_sysfs_read"
        "nix_runtime"
        "unlink_protection"
      ];
      openUrls = [ "https://auth.openai.com" ];
    };
    pi = {
      command = "pi";
      groups = [
        "node_runtime"
        "rust_runtime"
        "python_runtime"
        "linux_sysfs_read"
        "nix_runtime"
        "unlink_protection"
      ];
      openUrls = [
        "https://auth.openai.com"
        "https://claude.ai"
        "https://github.com"
      ];
    };
    amp = {
      command = "amp";
      groups = [
        "node_runtime"
        "linux_sysfs_read"
        "nix_runtime"
        "unlink_protection"
      ];
      openUrls = [ "https://ampcode.com" ];
    };
  };

  agentNames = builtins.attrNames agents;

  contextRoot =
    contextName: agentName: "${config.xdg.dataHome}/nono-agent-profiles/${contextName}/${agentName}";

  contextRoots = lib.flatten (
    lib.mapAttrsToList (
      contextName: _context: map (agentName: contextRoot contextName agentName) agentNames
    ) cfg.contexts
  );

  profileFor =
    contextName: context: agentName:
    let
      agent = agents.${agentName};
      root = contextRoot contextName agentName;
      workCredentials = context.infisical.credentials;
      workNetwork = {
        credentials = map (credential: credential.service) workCredentials;
        custom_credentials = builtins.listToAttrs (
          map (credential: {
            name = credential.service;
            value = {
              inherit (credential) upstream;
              credential_key = "cmd://${credential.service}";
              env_var = credential.envVar;
              inject_header = credential.injectHeader;
              credential_format = credential.credentialFormat;
            }
            // optionalAttrs (credential.endpointRules != [ ]) {
              endpoint_rules = credential.endpointRules;
            };
          }) workCredentials
        );
      };
      workCapture = builtins.listToAttrs (
        map (credential: {
          name = credential.service;
          value = {
            command = [
              (lib.getExe pkgs.infisical)
              "secrets"
              "get"
              "--plain"
              "--silent"
              "--projectId"
              context.infisical.projectId
              "--env"
              context.infisical.environment
              "--path"
              context.infisical.path
            ]
            ++ optional (context.infisical.domain != null) "--domain"
            ++ optional (context.infisical.domain != null) context.infisical.domain
            ++ [ credential.secretName ];
            timeout_secs = 30;
            cache_ttl_secs = 900;
          };
        }) workCredentials
      );
    in
    {
      meta = {
        name = "${contextName}-${agentName}";
        description = "${contextName} authentication and configuration state for ${agent.command}";
      };
      extends = "default";
      groups.include = agent.groups;
      filesystem.allow = [ root ];
      workdir.access = "readwrite";
      environment = {
        # Credentials come only from the nono mechanisms below. An inherited
        # cloud or SSH variable must not become a second auth context.
        allow_vars = [
          "CI"
          "COLORTERM"
          "EDITOR"
          "FORCE_COLOR"
          "GIT_EDITOR"
          "GIT_PAGER"
          "LANG"
          "LC_*"
          "NO_COLOR"
          "PAGER"
          "PATH"
          "TERM"
          "TZ"
          "VISUAL"
        ];
        deny_vars = [
          "ANTHROPIC_*"
          "AWS_*"
          "GITHUB_*"
          "GH_*"
          "INFISICAL_*"
          "OPENAI_*"
          "SSH_*"
        ];
        set_vars = {
          HOME = "${root}/home";
          XDG_CACHE_HOME = "${root}/cache";
          XDG_CONFIG_HOME = "${root}/config";
          XDG_DATA_HOME = "${root}/data";
          XDG_STATE_HOME = "${root}/state";
          GIT_CONFIG_GLOBAL = "${root}/config/git/config";
          GIT_CONFIG_NOSYSTEM = "1";
        }
        // optionalAttrs (agentName == "amp") {
          AMP_SETTINGS_FILE = "${root}/config/amp/settings.json";
          AMP_LOG_FILE = "${root}/state/amp/amp.log";
        };
      };
      open_urls = {
        allow_origins = agent.openUrls;
        allow_localhost = true;
      };
    }
    //
      optionalAttrs (context.credentialProvider == "onepassword" && context.onePasswordCredentials != { })
        {
          env_credentials = context.onePasswordCredentials;
        }
    // optionalAttrs (context.credentialProvider == "infisical" && workCredentials != [ ]) {
      network = workNetwork;
      credential_capture = workCapture;
    };

  profiles = builtins.listToAttrs (
    lib.flatten (
      lib.mapAttrsToList (
        contextName: context:
        map (agentName: {
          name = "${contextName}-${agentName}";
          value = profileFor contextName context agentName;
        }) agentNames
      ) cfg.contexts
    )
  );

  contextType = types.submodule {
    options = {
      credentialProvider = mkOption {
        type = types.enum [
          "onepassword"
          "infisical"
        ];
        description = "Credential mechanism for this context.";
      };

      onePasswordCredentials = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          "op://Personal/Anthropic/API key" = "ANTHROPIC_API_KEY";
        };
        description = ''
          1Password references mapped to environment variables for this
          context. Only valid for onepassword contexts.
        '';
      };

      infisical = {
        projectId = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "00000000-0000-0000-0000-000000000000";
          description = "Infisical project ID used by supervisor-side credential capture.";
        };
        environment = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "prod";
          description = "Infisical environment slug used by supervisor-side credential capture.";
        };
        path = mkOption {
          type = types.str;
          default = "/";
          description = "Infisical secret folder path used by supervisor-side credential capture.";
        };
        domain = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "https://infisical.example.com/api";
          description = "Optional self-hosted Infisical API URL.";
        };
        credentials = mkOption {
          default = [ ];
          type = types.listOf (
            types.submodule {
              options = {
                service = mkOption {
                  type = types.str;
                  example = "anthropic";
                  description = "Unique nono credential-route name; use only letters, digits, and underscores.";
                };
                secretName = mkOption {
                  type = types.str;
                  example = "ANTHROPIC_API_KEY";
                  description = "Infisical secret name; its value is never stored in Nix.";
                };
                upstream = mkOption {
                  type = types.str;
                  example = "https://api.anthropic.com";
                  description = "HTTPS API origin to which nono injects this credential.";
                };
                envVar = mkOption {
                  type = types.str;
                  example = "ANTHROPIC_API_KEY";
                  description = "Sandbox-visible variable that receives nono's phantom token.";
                };
                injectHeader = mkOption {
                  type = types.str;
                  default = "Authorization";
                  description = "Upstream HTTP header into which nono injects the credential.";
                };
                credentialFormat = mkOption {
                  type = types.str;
                  default = "Bearer {}";
                  description = "Header format; use {} as the credential placeholder.";
                };
                endpointRules = mkOption {
                  default = [ ];
                  type = types.listOf (
                    types.submodule {
                      options = {
                        method = mkOption { type = types.str; };
                        path = mkOption { type = types.str; };
                      };
                    }
                  );
                  description = "Optional nono method/path allow-list for this credential route.";
                };
              };
            }
          );
          description = "Credentials fetched from Infisical only by the nono supervisor.";
        };
      };
    };
  };
in
{
  options.me.ai.nono.contexts = mkOption {
    type = types.attrsOf contextType;
    default = {
      personal.credentialProvider = "onepassword";
      work.credentialProvider = "infisical";
    };
    description = "Named authentication and configuration contexts for sandboxed coding agents.";
  };

  config = {
    assertions =
      (lib.mapAttrsToList (contextName: _context: {
        assertion = builtins.match "^[a-z0-9][a-z0-9-]*$" contextName != null;
        message = "me.ai.nono.contexts names must use lowercase letters, digits, and hyphens: ${contextName}";
      }) cfg.contexts)
      ++ (lib.flatten (
        lib.mapAttrsToList (contextName: context: [
          {
            assertion = context.credentialProvider == "onepassword" || context.onePasswordCredentials == { };
            message = "me.ai.nono.contexts.${contextName}.onePasswordCredentials is only valid for a onepassword context";
          }
          {
            assertion = context.credentialProvider == "infisical" || context.infisical.credentials == [ ];
            message = "me.ai.nono.contexts.${contextName}.infisical.credentials is only valid for an infisical context";
          }
          {
            assertion =
              context.credentialProvider != "onepassword"
              || lib.all (reference: builtins.match "^op://[^/]+/.+" reference != null) (
                builtins.attrNames context.onePasswordCredentials
              );
            message = "me.ai.nono.contexts.${contextName}.onePasswordCredentials keys must be op:// references";
          }
          {
            assertion =
              context.infisical.credentials == [ ]
              || (context.infisical.projectId != null && context.infisical.environment != null);
            message = "me.ai.nono.contexts.${contextName}.infisical credentials require projectId and environment";
          }
          {
            assertion =
              let
                services = map (credential: credential.service) context.infisical.credentials;
              in
              builtins.length services == builtins.length (lib.unique services);
            message = "me.ai.nono.contexts.${contextName}.infisical credential service names must be unique";
          }
          {
            assertion = lib.all (
              credential: builtins.match "^[A-Za-z0-9_]+$" credential.service != null
            ) context.infisical.credentials;
            message = "me.ai.nono.contexts.${contextName}.infisical credential service names must use only letters, digits, and underscores";
          }
        ]) cfg.contexts
      ));

    home.packages = [
      llm-agents.nono
      llm-agents.amp
      pkgs.infisical
      (pkgs.writeShellApplication {
        name = "nono-agent";
        runtimeInputs = [ llm-agents.nono ];
        text = builtins.readFile ./nono-agent.sh;
      })
    ];

    xdg.configFile = lib.mapAttrs' (
      profileName: profile:
      lib.nameValuePair "nono/profiles/${profileName}.json" {
        text = builtins.toJSON profile;
      }
    ) profiles;

    home.activation.nonoAgentContextRoots = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.concatMapStringsSep "\n" (root: ''
        run mkdir -p -m 0700 "${root}"
      '') contextRoots}
    '';

    programs.fish = {
      completions.nono.body = ''
        ${llm-agents.nono}/bin/nono completion fish | source
      '';
      shellAbbrs = {
        sclaude = "nono-agent personal claude";
        scodex = "nono-agent personal codex";
        spi = "nono-agent personal pi";
        samp = "nono-agent personal amp";
        wclaude = "nono-agent work claude";
        wcodex = "nono-agent work codex";
        wpi = "nono-agent work pi";
        wamp = "nono-agent work amp";
      };
    };
  };
}
