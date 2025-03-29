{...}: {
  environment.persistence."/persist".users.meatcar = {
    files = [];
    directories = [
      {
        directory = ".config/op";
        mode = "0700";
      }
    ];
  };
}
