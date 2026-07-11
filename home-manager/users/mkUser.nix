{
  fullName,
  email,
}:
{
  imports = [ ../systems/imogen.nix ];

  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings.user.name = fullName;
    settings.user.email = email;
  };
  programs.jujutsu = {
    enable = true;
    settings.user.name = fullName;
    settings.user.email = email;
  };
}
