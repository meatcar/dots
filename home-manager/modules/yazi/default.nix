_:
{
  programs.yazi = {
    enable = true;
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
