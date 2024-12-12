{
  pkgs,
  config,
  ...
}: {
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [libva];
  hardware.pulseaudio.support32Bit = true;
  environment.systemPackages = with pkgs; [
    steam
    steam-run-native
    steam-run
    steam-tui
  ];
}
