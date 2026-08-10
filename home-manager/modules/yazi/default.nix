{ pkgs, ... }:
{
  # Preview deps HM's yazi module does not pull in: PDF (poppler), SVG/large
  # images (resvg, imagemagick). Archive (7z) and video thumbs come from
  # p7zip-rar and ffmpegthumbnailer in common.nix.
  home.packages = with pkgs; [
    poppler-utils
    resvg
    imagemagick
  ];

  programs.yazi = {
    enable = true;
    keymap = {
      # mgr = file-browser layer. The old `input` layer only fires inside text
      # prompts, where `shell` is not a valid command, so `!` did nothing there.
      mgr.prepend_keymap = [
        {
          run = "help";
          on = [ "<A-?>" ];
          desc = "Open help";
        }
        {
          run = "shell \"$SHELL\" --block";
          on = [ "!" ];
          desc = "Open shell here";
        }
      ];
    };
  };
}
