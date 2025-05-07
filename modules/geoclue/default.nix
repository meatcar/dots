{lib, ...}: {
  imports = [../opensnitch/rules/services/geoclue.nix];
  location.provider = "geoclue2";
  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
    enableDemoAgent = lib.mkForce true;
    appConfig = {
      "nl.whynothugo.darkman" = {
        isAllowed = true;
        isSystem = false;
      };
      "gammastep" = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };
}
