{
  config,
  pkgs,
  lib,
  ...
}: {
  fonts.fontconfig.enable = lib.mkDefault true;
  home.packages = with pkgs; [
    fontconfig
    (nerdfonts.override {
      fonts = ["Go-Mono"];
    })
    (google-fonts.override {fonts = ["Bitter"];})
    noto-fonts-emoji
    dejavu_fonts
    symbola
    emacs-all-the-icons-fonts
    python3
    pandoc
    xdg-utils
    unzip

    # LSP Servers
    rnix-lsp
    gopls
    elixir_ls
    python3Packages.python-lsp-server
    clojure-lsp
    rust-analyzer
    sqls
    terraform-ls
    yaml-language-server
    zls
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [epkgs.vterm];
  };
  programs.fish = {
    shellInit = ''
      if [ "$INSIDE_EMACS" = 'vterm' ]
          function clear
              vterm_printf "51;Evterm-clear-scrollback";
              tput clear;
          end
        function vterm_prompt_end;
            vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
        end
        functions --copy fish_prompt vterm_old_fish_prompt
        function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
            # Remove the trailing newline from the original prompt. This is done
            # using the string builtin from fish, but to make sure any escape codes
            # are correctly interpreted, use %b for printf.
            printf "%b" (string join "\n" (vterm_old_fish_prompt))
            vterm_prompt_end
        end
      end
    '';
    functions = {
      vterm_printf.body = ''
        if [ -n "$TMUX" ]
            # tell tmux to pass the escape sequences through
            # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
            printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
        else if string match -q -- "screen*" "$TERM"
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$argv"
        else
            printf "\e]%s\e\\" "$argv"
        end
      '';
      vterm_cmd.body = ''
        set -l vterm_elisp ()
        for arg in $argv
            set -a vterm_elisp (printf '"%s" ' (string replace -a -r '([\\\\"])' '\\\\\\\\$1' $arg))
        end
        vterm_printf '51;E'(string join \'\' $
        vterm_elisp)
      '';
    };
  };
}
