{
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [ (import ../overlays/ly.nix) ];

  environment.systemPackages = [ pkgs.ly ];

  environment.etc."ly/config.ini".text = ''
    tty = 2
    path = /run/current-system/sw/bin
    waylandsessions = ${pkgs.sway}/share/wayland-sessions
    mcookie_cmd = mcookie
    restart_cmd = shutdown -r now
    save_file = /tmp/ly-save
    shutdown = shutdown -a now
    term_reset_cmd = tput reset
  '';
  environment.etc."ly/lang".source = "${pkgs.ly.src}/res/lang";

  # From https://github.com/cylgom/ly/blob/master/res/ly.service
  systemd.services.ly = {
    enable = true;
    description = "TUI display manager";
    documentation = [ "https://github.com/nullgemm/ly" ];
    conflicts = [ "getty@tty2.service" ];
    after = [
      "systemd-user-sessions.service"
      "plymouth-quit-wait.service"
      "getty@tty2.service"
      "user.slice"
    ];
    aliases = [ "display-manager.service" ];
    requires = [ "user.slice" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "idle";
      ExecStart = "${pkgs.ly}/bin/ly";
      StandadInput = "tty";
      TTYPath = "/dev/tty2";
      TTYReset = "yes";
      TTYVHangup = "yes";
    };
  };
}
