let
  mormont = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcq01gh2tn/+hcm75N3LnS003mUBjXcT6qNndMhObPO";
  watson = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlUHaqIExPCm99pWSUhsi2O2ic3KwRJ/VUmJ28b2xNM meatcar@watson";
  systems = [mormont watson];
in {
  "aienv.age".publicKeys = systems;
  # https://console.cloud.google.com/auth/clients/create
  "gcalClientId.age".publicKeys = systems;
  "gcalClientSecret.age".publicKeys = systems;
  "spotifyClientId.age".publicKeys = systems;
  "spotifyClientSecret.age".publicKeys = systems;
}
