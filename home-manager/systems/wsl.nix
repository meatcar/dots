{ config, lib, pkgs, ... }: {
  home.sessionVariables = { XDG_RUNTIME_DIR = "$HOME/.cache/runtime"; };

  nixpkgs.overlays = [ (import ../../overlays/wsl-open.nix) ];

  home.packages = builtins.attrValues {
    inherit (pkgs) keybase kbfs wsl-open;

    get-wsl-display = pkgs.writeShellScriptBin "get-wsl-display" ''
      # Get DISPLAY for WSL2
      echo $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
    '';
    emacs-x = pkgs.writeShellScriptBin "emacs-x" ''
      env DISPLAY=$(get-wsl-display) emacs & disown
    '';
  };

  xdg.configFile."fish/fishfile".text = ''
    # WSL Only:
    danhper/fish-ssh-agent
  '';

  programs.fish.shellInit = ''
    # start cron daemon
    [ -z (pgrep cron) ] || sudo /etc/init.d/cron start 2>&1 >/dev/null
  '';
}
