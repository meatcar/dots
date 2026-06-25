{ pkgs, ... }:
let
  # sudo (the setuid wrapper) and niri (must match the running compositor) come
  # from the system PATH; only the plain CLI tools are pinned here.
  egpu-undock = pkgs.writeShellApplication {
    name = "egpu-undock";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
    ];
    text = builtins.readFile ./egpu-undock.sh;
  };
in
{
  environment.systemPackages = [ egpu-undock ];

  # Tag known eGPU enclosures as docks so systemd-logind treats clamshell-with-eGPU
  # as docked (HandleLidSwitchDocked) instead of falling through to HandleLidSwitchExternalPower.
  services.udev.extraRules = ''
    SUBSYSTEM=="thunderbolt", ATTR{vendor_name}=="Razer", ATTR{device_name}=="Core X Chroma", ENV{ID_DOCK}="1", TAG+="systemd"
  '';
}
