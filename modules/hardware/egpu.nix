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

  egpu-fbcon = pkgs.writeShellApplication {
    name = "egpu-fbcon";
    # fbset ships the classic con2fbmap(1) to remap VTs
    runtimeInputs = [ pkgs.fbset ];
    text = builtins.readFile ./egpu-fbcon.sh;
  };
in
{
  environment.systemPackages = [ egpu-undock ];

  boot.kernelParams = [
    # see https://docs.kernel.org/gpu/amdgpu/module-parameters.html
    # never runtime-power-down the eGPU; BACO wake over a TB tunnel hangs.
    "amdgpu.runpm=0"
    # reserve prefetchable MMIO on hotplug ports so the eGPU's BAR0 assigns.
    # FIXME: after a few boots check `dmesg | grep -i "BAR 0"` (no "failed to
    # assign") and that NICs/devices didn't renumber (`ip link`, `lspci`)
    "pci=hpmmioprefsize=32G,realloc=on"
  ];

  # a hot-removed GPU's outputs are never cleaned up. candidate for upstreaming.
  # Repro and details: https://github.com/meatcar/niri-egpu-repro
  programs.niri.package = pkgs.niri.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./niri-device-removed.patch ];
  });

  services.udev.extraRules = ''
    # Teach systemd-logind to treat the eGPU as a dock so it doesn't suspend on lid close.
    SUBSYSTEM=="thunderbolt", ATTR{vendor_name}=="Razer", ATTR{device_name}=="Core X Chroma", ENV{ID_DOCK}="1", TAG+="systemd"

    # enable the eGPU displays to show VTs
    ACTION=="add", SUBSYSTEM=="graphics", KERNEL=="fb[1-9]", ATTR{name}=="amdgpudrmfb", RUN+="${egpu-fbcon}/bin/egpu-fbcon %n"
  '';
}
