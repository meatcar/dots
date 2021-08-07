{ config, lib, pkgs, ... }:
{
  imports = [ ../modules/nix-flakes.nix ];

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

  xdg.configFile = {
    "fish/fish_plugins".text = ''
      # WSL Only:
      danhper/fish-ssh-agent
    '';
  };

  programs.fish.shellInit = ''
    # WSL thinks the shell is bash, even when running fish. Let's change it's mind.
    set -x SHELL ${pkgs.fish}/bin/fish

    # Detect startup
    if not pgrep cron >/dev/null
      if not mount | grep -q /tmp
        # mount /tmp manually a tmpfs
        sudo rm -rf /tmp/*
        sudo mount -t tmpfs tmpfs /tmp || true
      end

      sudo chgrp kvm /dev/kvm
      sudo chmod g+rw /dev/kvm

      # recreate symlinks for wslg
      if not test -e /tmp/.X11-unix
        sudo ln -s /mnt/wslg/.X11-unix /tmp/.X11-unix
      end

      if not sudo crontab -l | grep -qv 'drop_caches'
        # Occasionally drop caches to minimize WSL2 ram usages
        #set -l crontab '*/2 * * * * sync; echo 3 > /proc/sys/vm/drop_caches; touch /root/drop_caches_last_run'
        #(sudo crontab -l; echo "$crontab") | sudo crontab -
      end
      sudo /etc/init.d/cron start 2>&1 >/dev/null
    end
  '';
}
