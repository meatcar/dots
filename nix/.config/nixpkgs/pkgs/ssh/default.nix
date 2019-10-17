{ ... }: {
  programs.ssh = {
    enable = true;
    compression = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
