{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles.default = {
      userChrome = builtins.readFile ./userChrome.css;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layers.acceleration.force-enabled" = true; # fix youtube stutter
      };
    };
  };
}
