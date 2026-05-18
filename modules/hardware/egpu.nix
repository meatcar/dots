{
  # Tag known eGPU enclosures as docks so systemd-logind treats clamshell-with-eGPU
  # as docked (HandleLidSwitchDocked) instead of falling through to HandleLidSwitchExternalPower.
  services.udev.extraRules = ''
    SUBSYSTEM=="thunderbolt", ATTR{vendor_name}=="Razer", ATTR{device_name}=="Core X Chroma", ENV{ID_DOCK}="1", TAG+="systemd"
  '';
}
