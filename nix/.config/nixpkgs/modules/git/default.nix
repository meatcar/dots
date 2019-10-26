{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = "me@denys.me";
    userName = "Denys Pavlov";
    includes = [ { path = ./config; } ];
  };

  home.packages = builtins.attrValues {
    inherit (pkgs.gitAndTools) diff-so-fancy lab hub;
    inherit (pkgs) lazygit mr;
    inherit (pkgs.perl528Packages) PodPerldoc; # for mr
  };
}
