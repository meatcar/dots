{
  config,
  ...
}:
{
  nix.settings = {
    builders-use-substitutes = true;
    builders = [ "ssh://eu.nixbuild.net x86_64-linux - 100 1 big-parallel,benchmark" ];
  };

  programs.ssh.matchBlocks = {
    "eu.nixbuild.net" = {
      identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
      extraOptions = {
        PubkeyAcceptedKeyTypes = "ssh-ed25519";
      };
    };
  };
}
