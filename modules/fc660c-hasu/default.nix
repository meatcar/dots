{ pkgs, ... }:
{
  hardware.keyboard.qmk.enable = true;
  services.udev.packages = with pkgs; [ via ];
  # Allow chromium to flash Leopold FC660C Hasu controller in DFU mode
  # source: https://github.com/tmk/tmk_keyboard/wiki/FAQ-Build#linux-udev-rules
  services.udev.extraRules = ''
    # Atmel ATMega32U4
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", MODE:="0666"
    # tmk keyboard products     https://github.com/tmk/tmk_keyboard
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="feed", MODE:="0666"
  '';
}
