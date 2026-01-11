{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    quickemu
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    # qemu
  ];
  # from https://github.com/quickemu-project/quickemu/wiki/05-Advanced-quickemu-configuration#usb-redirection
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      # onBoot = "start";
      qemu = {
        package = pkgs.qemu_kvm;
        # swtpm.enable = true;
        # swtpm.package = pkgs.swtpm;
        # ovmf.enable = true;
        # ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };
}
