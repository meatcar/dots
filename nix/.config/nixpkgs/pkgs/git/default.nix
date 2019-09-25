{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "me@denys.me";
    userName = "Denys Pavlov";
    includes = [{ path = ./config; }];
  };

  home.packages = [ pkgs.gitAndTools.diff-so-fancy ];
}
