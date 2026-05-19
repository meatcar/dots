{
  imports = [ ../../secrets/module.nix ];

  # this is needed before impermanence fires
  age.identityPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
  ];
}
