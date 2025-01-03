# based on: https://github.com/matthewpi/nixos-config/blob/cffedc488740767402615c8790b82bcdff0f3509/systems/nxb/disko.nix
{
  lib,
  config,
  ...
}: let
  luksName = "crypted";
  rootSubvolume = "rootfs";
in {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = luksName;
                passwordFile = "/tmp/luks.key"; # Interactive
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = let
                  defaultOptions = [
                    # Disable access times on files.
                    "noatime"
                    # TODO: document
                    "nodev"
                    # Prevent SUID binaries from being used.
                    #
                    # Any binaries that need SUID privileges will be created by Nix
                    # and put into `/run/wrappers/bin` which has SUID permissions.
                    "nosuid"
                    # Use asynchronous discard (https://wiki.archlinux.org/title/Btrfs#SSD_TRIM)
                    "discard"
                  ];
                in {
                  type = "btrfs";
                  extraArgs = [
                    "-L"
                    "nixos"
                    "-f"
                  ];
                  # rollback root for impermanence
                  postCreateHook = ''
                    MNTPOINT="$(mktemp -d)"
                    SRCMNT='/dev/mapper/${luksName}'

                    mount -t btrfs -o 'compress=zstd,noexec,noatime,nodev,nosuid,discard' "$SRCMNT" "$MNTPOINT"
                    trap 'umount $MNTPOINT; rmdir $MNTPOINT' EXIT

                    btrfs subvolume snapshot -r "$MNTPOINT"/@${rootSubvolume} "$MNTPOINT"/@${rootSubvolume}-blank
                  '';
                  subvolumes = {
                    "@${rootSubvolume}" = {
                      mountpoint = "/";
                      mountOptions = ["compress=zstd" "noexec"] ++ defaultOptions;
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd"] ++ defaultOptions;
                    };
                    "@persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["compress=no" "noexec"] ++ defaultOptions;
                    };
                    "@persist/home" = {
                      mountpoint = "/persist/home";
                      mountOptions = ["compress=no"] ++ defaultOptions;
                    };
                    "@persist/git" = {
                      mountpoint = "/git";
                      mountOptions = ["compress=zstd"] ++ defaultOptions;
                    };
                    "@var/log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["compress=zstd" "noexec"] ++ defaultOptions;
                    };
                    "@swap" = {
                      mountpoint = "/.swap";
                      swap.swapfile.size = "40G"; # 32G RAM + overhead
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
  fileSystems = {
    "/persist".neededForBoot = true;
    "/var/log".neededForBoot = true;
    "/.swap".neededForBoot = true;
  };
}
