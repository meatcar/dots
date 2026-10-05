{ config, ... }:
let
  # NOTE: Live activation can mount the home path after the container starts.
  dataDir = "/persist${config.xdg.dataHome}/hister";
  healthCmd = "wget -qO /dev/null http://127.0.0.1:4433/health";
in
{
  imports = [ ../quadlet ];

  virtualisation.quadlet.containers.hister = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStartSec = 900;
      UMask = "0077";
    };

    containerConfig = {
      image = "ghcr.io/asciimoo/hister@sha256:5ffd0a702482c71010a67db8e6b567344189844ed42072d1b4cdae511b2aa7bb";
      name = "hister";
      userns = "keep-id:uid=65532,gid=65532";
      user = "65532";
      group = "65532";
      entrypoint = "/bin/sh";
      exec = "/hister/start.sh";
      publishPorts = [ "127.0.0.1:4433:4433" ];
      volumes = [
        "${dataDir}:/hister/data:rw"
        "${./start.sh}:/hister/start.sh:ro"
      ];
      environments = {
        HISTER_DATA_DIR = "/hister/data";
        HISTER__SERVER__ADDRESS = "0.0.0.0:4433";
        HISTER__SERVER__BASE_URL = "http://127.0.0.1:4433";
        HISTER__APP__PUBLIC = "false";
      };
      secrets = [ "hister-access-token,type=env,target=HISTER__APP__ACCESS_TOKEN" ];

      dropCapabilities = [ "all" ];
      noNewPrivileges = true;
      readOnly = true;
      tmpfses = [ "/tmp:rw,nosuid,nodev,noexec,size=64m" ];

      notify = "healthy";
      inherit healthCmd;
      healthInterval = "30s";
      healthTimeout = "5s";
      healthRetries = 3;
      healthOnFailure = "kill";
      healthStartupCmd = healthCmd;
      healthStartupInterval = "1s";
      healthStartupTimeout = "5s";
      healthStartupSuccess = 1;
      healthStartupRetries = 0;
    };
  };
}
