{...}: {
  environment.persistence."/persist".users.meatcar = {
    files = [];
    directories = [
      # spotify
      ".config/spotifyd"
      ".cache/spotifyd"
      ".config/spotify-player"
      ".cache/sporify-player"
      {
        directory = ".config/op";
        mode = "0700";
      }
    ];
  };
}
