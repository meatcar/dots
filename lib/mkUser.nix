{
  fullName,
  email,
}:
{
  imports = [ ../modules/home/common.nix ];

  home.stateVersion = "25.11";

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
