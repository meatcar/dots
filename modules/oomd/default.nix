_: {
  # NixOS enables systemd-oomd but leaves slices at ManagedOOM*=auto, so it
  # never acts. Opting slices in arms it.
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };

  # Swap exhaustion arm. Root slice only; needs RAM and swap both over 90%.
  systemd.slices."-".sliceConfig.ManagedOOMSwap = "kill";
}
