{
  # services.displayManager.lemurs.enable = true;
  # users.users.meatcar.extraGroups = [ "seat" ];

  services.displayManager = {
    ly = {
      enable = true;
      settings = {
        save = true;
      };
    };
  };

  # services.displayManager.gdm.enable = true;
}
