{
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  programs.ssh.matchBlocks."*".extraOptions = {
    IdentityAgent = "~/.1password/agent.sock";
  };
  systemd.user.services."1password" = {
    Unit = {
      Description = "1Password Tray";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe specialArgs.nixpkgs-unstable._1password-gui} --silent --ozone-platform-hint=auto";
      Restart = "always";
      KeyringMode = "inherit";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
