{ pkgs, ... }:
{
  # Preview deps HM's yazi module does not pull in: PDF (poppler), SVG/large
  # images (resvg, imagemagick), archives (p7zip). Video thumbs come from
  # ffmpegthumbnailer in common.nix.
  home.packages = with pkgs; [
    poppler-utils
    resvg
    imagemagick
    p7zip
  ];

  programs.yazi = {
    enable = true;
    keymap = {
      # mgr = file-browser layer. The old `input` layer only fires inside text
      # prompts, where `shell` is not a valid command, so `!` did nothing there.
      mgr.prepend_keymap = [
        {
          run = "shell \"$SHELL\" --block";
          on = [ "!" ];
          desc = "Open shell here";
        }
      ];
    };
  };
}
