{
  fullName,
  email,
}:
{
  imports = [ ../modules/me.nix ];

  home.stateVersion = "26.05";

  me.identity = {
    name = fullName;
    inherit email;
  };

  programs.git.enable = true;
  programs.jujutsu.enable = true;
}
