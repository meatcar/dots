{pkgs, ...}: {
  home.packages = [pkgs.mosh];
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPersist = "10m";
    # impemanence messes with `~/.ssh` permissions
    controlPath = "/run/user/%i/ssh-controlmasters_%r@%h:%p";
    extraConfig = ''
      AddKeysToAgent yes
    '';
    hashKnownHosts = true;
    includes = ["config.d/*"];
  };
}
