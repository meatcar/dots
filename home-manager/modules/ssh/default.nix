{ pkgs, ... }:
{
  home.packages = [ pkgs.mosh ];
  programs.ssh = {
    enable = true;
    includes = [ "config.d/*" ];
    enableDefaultConfig = false;
    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "yes";
      Compression = true;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = true;
      UserKnownHostsFile = "~/.ssh/known_hosts";

      ControlMaster = "auto"; # impermanence messes with `~/.ssh` permissions
      ControlPath =
        if pkgs.stdenv.isDarwin then
          "~/.ssh/ssh-controlmasters_%r@%h:%p"
        else
          "/run/user/%i/ssh-controlmasters_%r@%h:%p";
      ControlPersist = "10m";
    };
  };
}
