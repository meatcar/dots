{...}: {
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "vaapi";
      vo = "gpu";
      hwdec-codecs = "all";
      gpu-context = "wayland";
    };
  };
}
