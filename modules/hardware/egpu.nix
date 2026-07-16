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

  # fbcon draws only on fb0 (the APU), so the boot console never reaches
  # eGPU displays. fbset ships the classic con2fbmap(1) to remap VTs.
  egpu-fbcon = pkgs.writeShellApplication {
    name = "egpu-fbcon";
    runtimeInputs = [ pkgs.fbset ];
    text = builtins.readFile ./egpu-fbcon.sh;
  };
in
{
  environment.systemPackages = [ egpu-undock ];

  # UPSTREAM(niri): a hot-removed GPU's outputs are never cleaned up.
  # Repro and details: https://github.com/meatcar/niri-egpu-repro
  programs.niri.package = pkgs.niri.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./niri-device-removed.patch ];
  });

  # Tag known eGPU enclosures as docks so systemd-logind treats clamshell-with-eGPU
  # as docked (HandleLidSwitchDocked) instead of falling through to HandleLidSwitchExternalPower.
  services.udev.extraRules = ''
    SUBSYSTEM=="thunderbolt", ATTR{vendor_name}=="Razer", ATTR{device_name}=="Core X Chroma", ENV{ID_DOCK}="1", TAG+="systemd"

    # Route text VTs to the eGPU framebuffer when it appears (coldplug replay
    # covers docked boots); the kernel falls back to fb0 on unplug.
    ACTION=="add", SUBSYSTEM=="graphics", KERNEL=="fb[1-9]", ATTR{name}=="amdgpudrmfb", RUN+="${egpu-fbcon}/bin/egpu-fbcon %n"
  '';
}
