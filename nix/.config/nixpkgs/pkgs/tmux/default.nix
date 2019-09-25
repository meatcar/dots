{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    secureSocket = false;
  };

  home.packages = [ ];
}
