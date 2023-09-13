{ ... }:
{
  programs.lsd = {
    enable = true;
    settings = {
      icons.separator = "  "; # double-space, first one gets consumed by nerdfont icon
      indicators = true;
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
