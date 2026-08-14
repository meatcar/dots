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

  # NOTE: pool cap has never bound -- pswpout == zswpwb means every disk write
  # was shrinker writeback, not a rejected store. Raising it buys nothing.

  boot.kernel.sysctl = {
    # bias reclaim toward anon: zswap absorbs it at ~4.4:1 in RAM, while file
    # eviction bills a real disk read on refault. measured 719G of file
    # refaults against 79G of disk swapin.
    "vm.swappiness" = 150;
    # zswap serves ~88% of swapins, so readahead neighbours are already
    # resident; speculative loads only churn the pool.
    "vm.page-cluster" = 0;
  };

  # protect the youngest generation through pressure spikes.
  # NOTE: too high starves reclaim into OOM kills; 1s is conservative.
  systemd.tmpfiles.rules = [
    "w! /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 1000"
  ];

  # zstd compressor requires systemd in initrd.
  boot.initrd.systemd.enable = true;
}
