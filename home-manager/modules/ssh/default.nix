{pkgs, ...}: {
  home.packages = [pkgs.mosh];
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    extraConfig = ''
      AddKeysToAgent yes
    '';
    hashKnownHosts = true;
    includes = ["config.d/*"];
  };
}
