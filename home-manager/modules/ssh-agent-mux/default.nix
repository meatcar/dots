{
  config,
  lib,
  pkgs,
  ...
}:
let
  socket = "\${XDG_RUNTIME_DIR}/ssh-agent-mux/agent.sock";
  muxConfig = (pkgs.formats.toml { }).generate "ssh-agent-mux.toml" {
    listen_path = socket;
    agent_sock_paths = [
      "${config.home.homeDirectory}/.1password/agent.sock"
      "\${XDG_RUNTIME_DIR}/gcr/ssh"
    ];
  };
in
{
  home.packages = [ pkgs.ssh-agent-mux ];
  xdg.configFile."ssh-agent-mux/ssh-agent-mux.toml".source = muxConfig;

  home.sessionVariables.SSH_AUTH_SOCK = "\${SSH_AUTH_SOCK:-${socket}}";
  systemd.user.sessionVariables.SSH_AUTH_SOCK = socket;

  home.activation.setSshAgentMuxSocket =
    lib.hm.dag.entryBetween [ "reloadSystemd" ] [ "linkGeneration" ]
      "run ${pkgs.runtimeShell} ${./set-session-socket.sh} ${pkgs.systemd}/bin/systemctl";

  systemd.user.services.ssh-agent-mux = {
    Unit = {
      Description = "SSH agent multiplexer for 1Password and GCR";
      Wants = [ "gcr-ssh-agent.socket" ];
      After = [ "gcr-ssh-agent.socket" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.ssh-agent-mux} --config ${muxConfig}";
      Restart = "on-failure";
      RestartSec = 2;
      RuntimeDirectory = "ssh-agent-mux";
      RuntimeDirectoryMode = "0700";
      UMask = "0077";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
