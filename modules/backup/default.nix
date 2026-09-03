{
  config,
  lib,
  pkgs,
  ...
}:
let
  backupName = "persist";
  maintenanceName = "${backupName}-maintenance";
  restic-job = pkgs.writeShellApplication {
    name = "restic-job";
    text = lib.replaceStrings [ "@backupNames@" ] [ backupName ] (builtins.readFile ./restic-job.sh);
  };
in
{
  age.secrets.resticPersistEnvironment = {
    file = ../../secrets/resticPersistEnvironment.age;
    mode = "0400";
  };

  environment.systemPackages = [
    pkgs.restic
    restic-job
    (pkgs.writeShellApplication {
      name = "restic-timemachine";
      runtimeInputs = with pkgs; [
        coreutils
        delta
        jq
        restic-job
      ];
      text = builtins.readFile ./restic-timemachine.sh;
    })
  ];

  environment.persistence."/persist".directories = [
    {
      directory = "/var/cache/restic-backups-${backupName}";
      mode = "0700";
    }
  ];

  services.restic.backups.${backupName} = {
    environmentFile = config.age.secrets.resticPersistEnvironment.path;
    paths = [ "/persist" ];
    exclude = [
      "/persist/home/meatcar/.local/share/Steam/steamapps"
      "/persist/home/meatcar/.cache/"
      "/persist/home/meatcar/.config/zen/"
      "/persist/home/meatcar/.local/share/containers/storage"
      "/persist/git/hub/alipes/emdashsociety25/dumps"
      "/persist/home/meatcar/.local/share/zed"
      "/persist/home/meatcar/.local/share/flatpak"
      "/persist/home/meatcar/.local/share/Paradox Interactive"
      "/persist/home/meatcar/.local/share/nvim"
      "/persist/home/meatcar/.local/share/claude"
      "/persist/home/meatcar/.local/share/com.pais.handy"
      "/persist/home/meatcar/.local/share/opencode"
      "/persist/home/meatcar/Downloads/vms"
      "/persist/home/meatcar/Downloads/AM-builder-list"
      "/persist/home/meatcar/Downloads/.Trash-1000"
      "/persist/home/meatcar/.config/vivaldi/"
      "/persist/home/meatcar/.npm"
      "/persist/home/meatcar/.paradoxlauncher"
      "/persist/home/meatcar/.agentsview/sessions.db*"
      "/persist/home/meatcar/.agentsview/*.lock"
      "/persist/home/meatcar/.agentsview/daemon.*.json"
      "/persist/home/meatcar/.agentsview/debug.log"
      "/persist/git/hub/alipes/brt24/brt24-default/debug-artifacts/s3/backup/2026-02-brt.org-bucket/downloads"
      "/persist/git/.pnpm-store"

      "node_modules"
      ".next"
      ".terraform"
      ".turbo"
      ".venv"
      "__pycache__"
      ".pytest_cache"

      "/persist/var/lib/private/ollama/models"
      "/persist/var/lib/libvirt/images"
      "/persist/var/lib/libvirt/qemu/dump"
      "/persist/var/lib/libvirt/qemu/ram"
      "/persist/var/lib/libvirt/qemu/save"
      "/persist/var/lib/systemd/random-seed"
      "/persist/var/cache"
    ];
    extraBackupArgs = [
      "--exclude-caches"
      "--retry-lock 2h"
      "--tag plan:${backupName}"
      "--tag created-by:watson"
    ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };

  systemd.services."restic-backups-${backupName}" = {
    unitConfig = {
      OnSuccess = [ "restic-${backupName}-forget.service" ];
      RequiresMountsFor = [
        "/persist"
        "/persist/home"
      ];
    };
    serviceConfig = {
      Nice = 10;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 7;
    };
  };

  systemd.services."restic-${backupName}-forget" = {
    description = "Apply retention to the ${backupName} Restic snapshots";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    environment.RESTIC_CACHE_DIR = "/var/cache/restic-backups-${backupName}";
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.age.secrets.resticPersistEnvironment.path;
      CacheDirectory = "restic-backups-${backupName}";
      CacheDirectoryMode = "0700";
      PrivateTmp = true;
      Nice = 10;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 7;
      ExecStart = "${lib.getExe pkgs.restic} forget --retry-lock 2h --keep-hourly 24 --keep-daily 30 --keep-weekly 8 --keep-monthly 24 --keep-yearly 10 --tag plan:${backupName},created-by:watson --group-by=";
    };
  };

  systemd.services."restic-${maintenanceName}" = {
    description = "Maintain the ${backupName} Restic repository";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    environment = {
      RESTIC_CACHE_DIR = "/var/cache/restic-backups-${backupName}";
    };
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.age.secrets.resticPersistEnvironment.path;
      CacheDirectory = "restic-backups-${backupName}";
      CacheDirectoryMode = "0700";
      PrivateTmp = true;
      Nice = 10;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 7;
      ExecStart = [
        "${lib.getExe pkgs.restic} unlock"
        "${lib.getExe pkgs.restic} prune --retry-lock 2h --max-unused 10%"
        "${lib.getExe pkgs.restic} check --retry-lock 2h"
      ];
    };
  };

  systemd.timers."restic-${maintenanceName}" = {
    description = "Monthly maintenance for the ${backupName} Restic repository";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-01 00:45:00";
      Persistent = true;
    };
  };
}
