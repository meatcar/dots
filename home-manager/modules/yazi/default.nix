_: {
  programs.yazi = {
    enable = true;
    # Keep legacy wrapper name (new default in stateVersion >= 26.05 is "y")
    shellWrapperName = "yy";
    keymap = {
      input.prepend_keymap = [
        {
          run = "shell \"$SHELL\" --block";
          on = [ "!" ];
          desc = "Open shell here";
        }
      ];
    };
  };
}
