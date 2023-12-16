{...}: {
  wayland.windowManager.sway.extraSessionCommands = ''
    export WLR_DRM_DEVICES=$(get-wlr-drm-devices)
  '';
}
