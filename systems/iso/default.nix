{
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
let
  githubAuthorizedKeys = pkgs.writeShellApplication {
    name = "github-authorized-keys";
    runtimeInputs = [ pkgs.curl ];
    text = builtins.readFile ./github-authorized-keys.sh;
  };
in
{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  system.stateVersion = "26.05";
  boot.zfs.forceImportRoot = false;
  isoImage.forceTextMode = true;
  hardware.graphics.enable = false;

  # NOTE: sshd rejects an AuthorizedKeysCommand below group-writable /nix/store.
  environment.etc."ssh/github-authorized-keys" = {
    source = "${githubAuthorizedKeys}/bin/github-authorized-keys";
    mode = "0755";
  };
  services.openssh.authorizedKeysCommand = "/etc/ssh/github-authorized-keys %u";

  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };

  services.fwupd.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # NOTE: stable only; one glibc in the ISO closure.
    extraSpecialArgs = lib.mkAfter { nixpkgs-unstable = pkgs; };
    users = lib.genAttrs [ "nixos" "root" ] (_: ../../home-manager/systems/iso.nix);
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    age
    inputs.disko.packages.${stdenv.hostPlatform.system}.disko
    htop
    lsof
    restic
    sbctl
    tmux
  ];
}
