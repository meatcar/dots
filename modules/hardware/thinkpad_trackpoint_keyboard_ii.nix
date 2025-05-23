{
  hardware.trackpoint.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="hid", ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="60ee|6047", ATTR{fn_lock}="0"
  '';
}
