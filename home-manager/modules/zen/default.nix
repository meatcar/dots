{ pkgs, ... }:
{
  programs.zen-browser.nativeMessagingHosts = [
    # nixpkgs 26.05: firefoxpwa 2.18.2 no longer ships lib/firefoxpwa/ in its
    # output, so the wrapper buildCommand fails touching is-packaged-app.
    (pkgs.firefoxpwa.overrideAttrs (old: {
      buildCommand =
        builtins.replaceStrings
          [ ''touch "$out/lib/firefoxpwa/is-packaged-app"'' ]
          [ ''mkdir -p "$out/lib/firefoxpwa"; touch "$out/lib/firefoxpwa/is-packaged-app"'' ]
          old.buildCommand;
    }))
  ];
  programs.zen-browser = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableAppUpdate = false;
    };
  };

}
