{ config, lib, pkgs, specialArgs, ... }:
{
  imports = [
    ./common.nix
    ../modules/gtk.nix
    ../modules/gnome-keyring.nix
  ];

  home.sessionVariables = {
    BROWSER = "x-www-browser";
  };

  # fish is the default shell. hide it.
  programs.starship.settings.shell.fish_indicator = "";

  programs.fish.plugins = [
    { name = "fish-ssh-agent"; src = specialArgs.inputs.fish-ssh-agent; }
  ];

  programs.fish.interactiveShellInit = "set -x COLORTERM truecolor";

  programs.fish.functions.osc7_prompt = {
    onEvent = "fish_prompt";
    body = ''
      if grep -q Microsoft /proc/version
        printf "\033]7;file://%s\033\\" (wslpath -w "$PWD")
      end
    '';
  };

  # TODO: systemdaemonize
  # programs.fish.shellInit = ''
  #   # Detect startup
  #   if not pgrep cron >/dev/null
  #     if not sudo crontab -l | grep -qv 'drop_caches'
  #       # Occasionally drop caches to minimize WSL2 ram usages
  #       #set -l crontab '*/2 * * * * sync; echo 3 > /proc/sys/vm/drop_caches; touch /root/drop_caches_last_run'
  #       #(sudo crontab -l; echo "$crontab") | sudo crontab -
  #     end
  #     sudo /etc/init.d/cron start 2>&1 >/dev/null
  #   end
  # '';
}
