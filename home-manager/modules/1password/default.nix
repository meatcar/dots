{
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  programs.ssh.matchBlocks."*".extraOptions = {
    IdentityAgent = "~/.1password/agent.sock";
  };
  programs.git.settings."gpg \"ssh\"" = {
    program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
  };
  systemd.user.services."1password" = {
    Unit = {
      Description = "1Password Tray";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe nixpkgs-unstable._1password-gui} --silent --ozone-platform-hint=auto";
      Restart = "always";
      KeyringMode = "inherit";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
