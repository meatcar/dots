{ ... }:
{
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [ "--noask --quiet" ];
  };
}
