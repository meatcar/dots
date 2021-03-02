{ config, lib, pkgs, ... }: {
  home.username = builtins.getEnv "USER";
  home.homeDirectory = "/home/${config.home.username}";
  home.sessionVariables = {
    XDG_RUNTIME_DIR = "$HOME/.cache/runtime";
    BROWSER = "${pkgs.wsl-open}/bin/wsl-open";
  };

  nixpkgs.overlays = [ (import ../../overlays/wsl-open.nix) ];

  home.packages = builtins.attrValues {
    inherit (pkgs) keybase kbfs wsl-open;

    get-wsl-display = pkgs.writeShellScriptBin "get-wsl-display" ''
      # Get DISPLAY for WSL2
      echo $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
    '';
    emacs-x = pkgs.writeShellScriptBin "with-x" ''
      env DISPLAY=$(get-wsl-display) "$@" & disown
    '';
    powershell = pkgs.writeShellScriptBin "powershell.exe" ''
      /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NonInteractive –ExecutionPolicy Bypass "$@"
    '';
  };

  xdg.configFile."fish/fish_plugins".text = ''
    # WSL Only:
    danhper/fish-ssh-agent
  '';

  programs.fish.shellInit = ''
    # Detect startup
    if [ -z (pgrep cron) ]
      # Since this branch is executed once, let's clean /tmp and mount
      sudo rm -rf /tmp/*
      sudo mount -t tmpfs tmpfs /tmp || true

      # Occasionally drop caches to minimize WSL2 ram usages
      # root crontab contents:
      # */2 * * * * sync; echo 3 > /proc/sys/vm/drop_caches; touch /root/drop_caches_last_run
      # start cron daemon
      sudo /etc/init.d/cron start 2>&1 >/dev/null

    end

    # WSL thinks the shell is bash, even when running fish. Let's change it's mind.
    set -x SHELL ${pkgs.fish}/bin/fish
  '';
}
