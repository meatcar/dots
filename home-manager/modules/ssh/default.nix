{ pkgs, ... }:
{
  home.packages = [ pkgs.mosh ];
  programs.ssh = {
    enable = true;
    includes = [ "config.d/*" ];
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "yes";
      compression = true;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = true;
      userKnownHostsFile = "~/.ssh/known_hosts";

      controlMaster = "auto"; # impemanence messes with `~/.ssh` permissions
      controlPath = "/run/user/%i/ssh-controlmasters_%r@%h:%p";
      controlPersist = "10m";

    };
  };
}
