super: (
  super: {
    bumblebee = super.callPackage ../pkgs/bumblebee {
      nvidia_x11 = super.linuxPackages.nvidia_x11;
      nvidia_x11_i686 = if super.stdenv.hostPlatform.system == "x86_64-linux"
      then super.pkgsi686Linux.linuxPackages.nvidia_x11.override { libsOnly = true; }
      else null;
      libglvnd_i686 = if super.stdenv.hostPlatform.system == "x86_64-linux"
      then super.pkgsi686Linux.libglvnd
      else null;
    };
  }
)
