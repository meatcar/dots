{...}: {
  location.provider = "geoclue2";
  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
    appConfig = {
      "nl.whynothugo.darkman" = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };
}
