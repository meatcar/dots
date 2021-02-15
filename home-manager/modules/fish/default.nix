{ pkgs, ... }: {
  imports = [ ../starship ../fzf ];
  home.packages = [ pkgs.bat pkgs.fasd pkgs.fd ];
  home.sessionVariables = { BAT_THEME = "base16"; };

  programs.fish = {
    enable = true;
    promptInit = ''
      # output of `any-nix-shell --info-right | source`
      function nix-shell
        ${pkgs.any-nix-shell}/bin/.any-nix-shell-wrapper fish $argv
        set -gx ANY_NIX_SHELL_EXIT_STATUS $status
      end
      function nix
        if test $argv[1] = run
          set argv[1] fish
          ${pkgs.any-nix-shell}/bin/.any-nix-run-wrapper $argv
          set -gx ANY_NIX_SHELL_EXIT_STATUS $status
        else
          command nix $argv
        end
      end
      function fish_right_prompt
        ${pkgs.any-nix-shell}/bin/nix-shell-info
        printf " "
        set -e ANY_NIX_SHELL_EXIT_STATUS
      end
    '';
    shellInit = ''
      ${builtins.readFile ./config.fish}
      eval (starship init fish)
    '';
  };

  xdg.configFile."fish/fish_plugins" = {
    text = builtins.readFile ./fish_plugins;
    onChange = "fish -il -c 'fisher update'";
  };
  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };
}
