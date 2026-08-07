{
  config,
  lib,
  pkgs,
  ...
}:
let
  splitUp = pkgs.writeShellApplication {
    name = "wireguard-split-up";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      iproute2
      kmod
      wireguard-tools
    ];
    text = builtins.readFile ./up.sh;
  };
  splitDown = pkgs.writeShellApplication {
    name = "wireguard-split-down";
    runtimeInputs = with pkgs; [
      coreutils
      iproute2
      wireguard-tools
    ];
    text = builtins.readFile ./down.sh;
  };
in
{
  networking.wg-quick.interfaces.wg0.configFile = config.age.secrets.wireguard.path;

  systemd.services.wg-quick-wg0.serviceConfig = {
    ExecStart = lib.mkForce "${lib.getExe splitUp} ${config.age.secrets.wireguard.path}";
    ExecStop = lib.mkForce (lib.getExe splitDown);
  };

  # strict rpfilter drops wg0 replies; reverse route is the main table
  networking.firewall.checkReversePath = "loose";

  # keep nm (and gui shells driving it) from tearing the interface down
  networking.networkmanager.unmanaged = [ "interface-name:wg0" ];
}
