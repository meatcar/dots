let
  mormont = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcq01gh2tn/+hcm75N3LnS003mUBjXcT6qNndMhObPO";
  watson = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlUHaqIExPCm99pWSUhsi2O2ic3KwRJ/VUmJ28b2xNM meatcar@watson";
  ci = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtmRcvR5Ron/AnnOhksodO+8ZSYTfM3RtURqnQWTrTw meatcar@ci";
  users = [
    mormont
    watson
    ci
  ];
  watsonHost = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIk7JFP7cWKnFJbpdzvMc6M9Iacbh4buNHepENe1IrSl root@watson";
  systems = users ++ [
    watsonHost
  ];
in
{
  "aienv.age".publicKeys = users;
  "pushover.age".publicKeys = users;
  # https://console.cloud.google.com/auth/clients/create
  "gcalClientId.age".publicKeys = users;
  "gcalClientSecret.age".publicKeys = users;
  "spotifyClientId.age".publicKeys = users;
  "spotifyClientSecret.age".publicKeys = users;
  "cliProxyApiEnv.age".publicKeys = users;
  "userPassword.age".publicKeys = systems;
}
