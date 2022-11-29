return function(use)
  use 'tpope/vim-rhubarb' -- auto-complete Github issues in fugitive
  use 'samoshkin/vim-mergetool' -- Better merging (3-way becomes 2-way)
  use 'rhysd/git-messenger.vim' -- pop-up window of git commit under cursor
  use 'sodapopcan/vim-twiggy' -- pop-up git branches
  use 'rbong/vim-flog' -- pretty git log
  use 'mattn/webapi-vim' -- for vim-gist

  use { -- generate a link to file on git remote site
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitlinker').setup()
    end,
  }

  use { -- tight git integration
    'tpope/vim-fugitive',
    config = function()
      vim.cmd [[autocmd packer FileType fugitive nmap <buffer> q gq]]
    end,
  }

  use { -- Gist support
    'mattn/vim-gist',
    config = function()
      if vim.env.WAYLAND_DISPLAY then
        vim.g.gist_clip_command = 'wl-copy'
      else
        vim.g.gist_clip_command = 'xclip -selection clipboard'
      end
      vim.g.gist_detect_filetype = true
      vim.g.gist_open_browser_after_post = true
      vim.g.gist_browser_command = 'xdg-open %URL% &'
    end,
  }

  use { -- show git changes in the gutter
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {}
    end,
  }
end
