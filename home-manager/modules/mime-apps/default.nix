{ pkgs, lib, ... }:
let
  dms = "dms-open.desktop";
  papers = "org.gnome.Papers.desktop";
  loupe = "org.gnome.Loupe.desktop";
  zed = "dev.zed.Zed.desktop";
  nvim = "nvim.desktop"; # the "Neovim wrapper" (Terminal=true) desktop entry

  # Plain-text / source types that both Zed and the Neovim wrapper register
  # for. Zed is the default; the Neovim wrapper is listed right after it in
  # Dolphin's "Open With" via the Added Associations ordering below.
  textTypes = [
    "text/plain"
    "text/english"
    "text/x-makefile"
    "text/x-c"
    "text/x-c++"
    "text/x-chdr"
    "text/x-csrc"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-java"
    "text/x-moc"
    "text/x-pascal"
    "text/x-tcl"
    "text/x-tex"
    "application/x-shellscript"
    "application/json"
  ];
in
{

  home.sessionVariables = {
    BROWSER = "dms open";
  };
  xdg.mimeApps.defaultApplications = {
    "image/png" = loupe;
    "image/jpeg" = loupe;
    "image/gif" = loupe;
    "image/webp" = loupe;
    "image/bmp" = loupe;
    "image/tiff" = loupe;
    "image/svg+xml" = loupe;
    "image/heif" = loupe;
    "image/avif" = loupe;
    "image/x-icon" = loupe;
    "application/x-extension-shtml" = dms;
    "application/x-extension-xhtml" = dms;
    "application/x-extension-html" = dms;
    "application/x-extension-xht" = dms;
    "application/x-extension-htm" = dms;
    "x-scheme-handler/unknown" = dms;
    "x-scheme-handler/mailto" = dms;
    "x-scheme-handler/chrome" = dms;
    "x-scheme-handler/about" = dms;
    "x-scheme-handler/https" = dms;
    "x-scheme-handler/http" = dms;
    "application/xhtml+xml" = dms;
    "text/html" = dms;
    "application/pdf" = papers;
  }
  // lib.genAttrs textTypes (_: zed);

  # Dolphin builds its "Open With" list from KSycoca, ordering the default
  # first and then following the Added Associations order. List Zed then the
  # Neovim wrapper so the wrapper is the next choice (middle-click) after Zed.
  xdg.mimeApps.associations.added = lib.genAttrs textTypes (_: [
    zed
    nvim
  ]);

  home.packages = [
    (pkgs.writeShellScriptBin "mime-apps-list" ''
      ls /run/current-system/sw/share/applications # for global packages
      ls /etc/profiles/per-user/$(id -n -u)/share/applications # for user packages
      ls ~/.nix-profile/share/applications # for home-manager packages
    '')
    pkgs.shared-mime-info
  ];
}
