{ config, ... }:
let
  host = "eu.nixbuild.net";
in
{
  age.secrets.nixbuildKey = {
    file = ../../secrets/nixbuildKey.age;
    mode = "0400";
  };

  programs.ssh = {
    knownHosts.nixbuild = {
      hostNames = [ host ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
    extraConfig = ''
      Host ${host}
        PubkeyAcceptedKeyTypes ssh-ed25519
        ServerAliveInterval 60
        IPQoS throughput
    '';
  };

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = host;
        protocol = "ssh-ng";
        sshUser = "root";
        sshKey = config.age.secrets.nixbuildKey.path;
        systems = [
          "x86_64-linux"
          "i686-linux"
        ];
        maxJobs = 100;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
    ];
    settings = {
      builders-use-substitutes = true;
      trusted-public-keys = [ "nixbuild.net/meatcar-1:wUHw9lieLYHVICwmhmivBWQlwRV2rviGrtnp/WFH3Kw=" ];
    };
  };
}
