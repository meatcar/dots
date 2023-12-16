{
  config,
  pkgs,
  ...
}: let
  pkgsPinned =
    import
    (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "3329b3430739ed71a64c3931315367cf2c7f45e4";
      sha256 = "09jgqxphxjcbldjhzk6wqw6f92g7qh79f4j8lns0lrpsq0szq19n";
    })
    {};
in {
  services.fprintd = {
    enable = true;
    package = pkgsPinned.fprintd-tod.overrideAttrs (oldAttrs: rec {
      pname = "fprintd-tod";
    });
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
}
