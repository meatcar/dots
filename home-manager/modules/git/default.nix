{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = "me@denys.me";
    userName = "Denys Pavlov";
    includes = [{ path = ./config; }];
  };

  home.packages = builtins.attrValues {
    inherit (pkgs.gitAndTools) lab hub delta gh;
    inherit (pkgs) lazygit mr;
    inherit (pkgs.perl530Packages) PodPerldoc;# for mr
  };

  xdg.configFile."jesseduffield/lazygit/config.yml".text = ''
    reporting: "off"
    startuppopupversion: 1
    git:
      paging:
        colorArg: always
        pager: ${pkgs.gitAndTools.delta}/bin/delta --dark --paging=never --24-bit-color=never
  '';
}
