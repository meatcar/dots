{ pkgs, ... }: {
  home.packages = [ pkgs.mosh ];
  programs.ssh = {
    enable = true;
    compression = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
