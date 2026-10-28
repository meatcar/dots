# NOTE: Apps are unpinned; update manually with `scripts/deps update flatpak`.
# Pin `commit` only to hold back a broken release; remove the pin after the fix.
{ inputs, lib, ... }:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    remotes = lib.mkOptionDefault [
      {
        name = "GeForceNOW";
        location = "https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo";
      }
    ];
    packages = [
      "it.mijorus.gearlever"
      "com.github.k4zmu2a.spacecadetpinball"
      {
        appId = "com.nvidia.geforcenow";
        origin = "GeForceNOW";
      }
    ];
  };
}
