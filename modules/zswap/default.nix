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

  # zstd compressor requires systemd in initrd.
  boot.initrd.systemd.enable = true;
}
