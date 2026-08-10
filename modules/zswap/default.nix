_: {
  # zswap requires a disk-based swap device or file to back it.
  # See https://wiki.nixos.org/wiki/Swap
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.zpool=zsmalloc"
    "zswap.max_pool_percent=20"
    "zswap.shrinker_enabled=1"
  ];

  # live CachyOS defaults, pinned so a kernel switch can't silently change
  # reclaim; both suit zswap, where anon eviction round-trips through RAM
  # NOTE: disk writeback is the shrinker's doing, not these -- see max_pool_percent
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
  };

  # zstd compressor requires systemd in initrd.
  boot.initrd.systemd.enable = true;
}
