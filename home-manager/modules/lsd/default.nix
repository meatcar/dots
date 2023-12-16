{...}: {
  programs.lsd = {
    enable = true;
    settings = {
      icons.separator = "  "; # double-space, first one gets consumed by nerdfont icon
      indicators = false;
      blocks = [
        "permission"
        "user"
        "group"
        "size"
        "date"
        "name"
      ];
      sorting.dir-grouping = "first";
    };
  };
}
