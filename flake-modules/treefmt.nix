{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { inputs', ... }:
    let
      pkgsUnstable = inputs'.nixpkgs-unstable.legacyPackages;
    in
    {
      treefmt = {
        programs.nixfmt.enable = true;
        programs.statix.enable = true;
        programs.deadnix.enable = true;
        programs.actionlint.enable = true;
        programs.oxfmt = {
          enable = true;
          package = pkgsUnstable.oxfmt;
          # FIXME(oxfmt-gtk-css): newer oxfmt formats CSS but chokes on GTK
          # CSS extensions (@foreground named colors); exclude GTK stylesheets
          excludes = [ "home-manager/modules/waybar/waybar-style.css" ];
        };
        programs.shfmt.enable = true;
        programs.shellcheck = {
          enable = true;
          excludes = [
            ".envrc"
          ];
        };
      };
    };
}
