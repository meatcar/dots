{
  config,
  pkgs,
  lib,
  ...
}: let
  user = config.home.username;
  man_color_args = lib.strings.concatStringsSep " " [
    "-DP+k-" # Prompt = formatted bold Black on normal
    "-DE+kr" # Error/Info = formatted bold Black on Red
    "-DS+ky" # Search result = formatted bold Black on Yellow
    "-Dd+c" # bold = formatted cyan
    "-Dk+c" # blink = formatted cyan
    "-Du+g" # underline = formatted green
    "-Ds+kw" # standout = formatted Black on White
  ];
  manpager = pkgs.writeShellScriptBin "manpager" ''
    export LESS_TERMCAP_mb=$(tput bold)             # begin blinking
    export LESS_TERMCAP_md=$(tput bold)             # begin bold
    export LESS_TERMCAP_me=$(tput sgr0)             # end mode
    export LESS_TERMCAP_so=$(tput smso; tput bold)  # begin standout moude
    export LESS_TERMCAP_se=$(tput rmso; tput sgr0)  # end standout moude
    export LESS_TERMCAP_us=$(tput bold; tput smul)  # begin underline
    export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)  # end underline
    export LESS_TERMCAP_mr=$(tput rev)              # reverse
    export LESS_TERMCAP_mh=$(tput dim)              # half-bright
    export LESS_TERMCAP_ZN=$(tput ssubm)
    export LESS_TERMCAP_ZV=$(tput rsubm)
    export LESS_TERMCAP_ZO=$(tput ssupm)
    export LESS_TERMCAP_ZW=$(tput rsupm)

    less --use-color ${man_color_args} "$@"
  '';
in {
  programs.man.enable = true;
  programs.man.generateCaches = false;

  home.sessionVariables = {
    MANROFFOPT = "-c";
    MANPAGER = "manpager";
  };
  home.packages = [manpager];
}
