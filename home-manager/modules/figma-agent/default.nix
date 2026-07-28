{ lib, pkgs, ... }:
{
  # Serve local fonts to figma.com. Units mirror upstream's install.sh:
  # https://github.com/neetly/figma-agent-linux/blob/main/files/install.sh
  # NOTE: browser must spoof a Windows user agent for Figma to connect.
  systemd.user.services.figma-agent = {
    Unit = {
      Description = "Figma Agent for Linux Service";
      Requires = [ "figma-agent.socket" ];
    };
    Service = {
      Type = "exec";
      ExecStart = lib.getExe pkgs.figma-agent;
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.sockets.figma-agent = {
    Unit.Description = "Figma Agent for Linux Socket";
    Socket.ListenStream = "127.0.0.1:44950";
    Install.WantedBy = [ "sockets.target" ];
  };
}
