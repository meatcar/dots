_: {
  programs.vifm = {
    enable = true;
    extraConfig = ''
      set vicmd=nvim
      set syscalls
      set sortnumbers
      set ignorecase
      set smartcase
      set incsearch
      set scrolloff=4
    '';
  };
}
