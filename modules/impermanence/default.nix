# based on https://github.com/matthewpi/nixos-config/blob/cffedc488740767402615c8790b82bcdff0f3509/modules/persistence/default.nix
{
  lib,
  pkgs,
  ...
}:
let
  luksName = "crypted";
  rootSubvolume = "rootfs";
in
{
  imports = [
    ./networkmanager.nix
    ./bluetooth.nix
    ./fwupd.nix
    ./gnome.nix
    ./fprintd.nix
    ./docker.nix
    ./podman.nix
    ./tailscale.nix
    ./meatcar.nix
  ];
  # Setup a service that will automatically rollback the root subvolume to a fresh state.
  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a fresh state";
    wantedBy = [ "initrd.target" ];
    before = [ "sysroot.mount" ];
    after = [ "systemd-cryptsetup@${luksName}.service" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";

    script = ''
      mkdir -p /btrfs
      mount -t btrfs -o compress=zstd,noatime,nodev,noexec,nosuid,discard=async /dev/mapper/${luksName} /btrfs

      echo 'Cleaning subvolumes...'
      btrfs subvolume list -o /btrfs/@${rootSubvolume} | cut -f9 -d ' ' |
        while read subvolume; do
          echo 'Deleting /'"$subvolume"' subvolume...'
          btrfs subvolume delete /btrfs/"$subvolume"
        done &&
        echo 'Deleting /@${rootSubvolume} subvolume...' &&
        btrfs subvolume delete /btrfs/@${rootSubvolume}

      echo 'Restoring blank /@${rootSubvolume} subvolume...'
      btrfs subvolume snapshot /btrfs/@${rootSubvolume}-blank /btrfs/@${rootSubvolume}

      umount /btrfs
      rm -d /btrfs
    '';
  };

  # Disable sudo lectures, as they will be shown after every reboot otherwise.
  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  fileSystems."/persist".neededForBoot = lib.mkDefault true;

  # for home-manager impermanence
  programs.fuse.userAllowOther = true;

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "fs-diff" ''
      #!/usr/bin/env bash
      # fs-diff.sh
      set -euo pipefail
      sudo mkdir -p /mnt/btrfs
      sudo mount -o subvol=/ /dev/mapper/${luksName} /mnt/btrfs

      OLD_TRANSID=$(sudo btrfs subvolume find-new /mnt/btrfs/@${rootSubvolume}-blank 9999999)
      OLD_TRANSID=''${OLD_TRANSID#transid marker was }

      sudo btrfs subvolume find-new "/mnt/btrfs/@${rootSubvolume}" "$OLD_TRANSID" |
      sed '$d' |
      cut -f17- -d' ' |
      sort |
      uniq |
      while read path; do
        path="/$path"
        if [ -L "$path" ]; then
          : # The path is a symbolic link, so is probably handled by NixOS already
        elif [ -d "$path" ]; then
          : # The path is a directory, ignore
        else
          echo "$path"
        fi
      done
    '')
  ];

  # Persistence
  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/etc/nixos";
        mode = "0755";
      }
      {
        directory = "/var/lib/nixos";
        mode = "0755";
      }

      {
        directory = "/var/lib/sbctl";
        mode = "0700";
      }

      # for systemd sandboxes
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
      {
        directory = "/var/cache/private";
        mode = "0700";
      }
      {
        directory = "/root";
        mode = "0700";
      }
      "/var/lib/cups"
      "/var/lib/boltd"
      "/var/lib/opensnitch/rules"
    ];

    files = [
      "/etc/machine-id"
    ];

    hideMounts = true;
  };
}
