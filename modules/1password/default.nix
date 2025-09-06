{ nixpkgs-unstable, ... }:
{
  programs._1password = {
    enable = true;
    package = nixpkgs-unstable._1password-cli;
  };
  programs._1password-gui = {
    enable = true;
    package = nixpkgs-unstable._1password-gui;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "meatcar" ];
  };
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        zen
      ''; # or just "zen" if you use unwrapped package
      mode = "0755";
    };
  };
}
