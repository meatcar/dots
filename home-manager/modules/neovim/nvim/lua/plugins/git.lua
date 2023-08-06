return {
  'tpope/vim-rhubarb',       -- auto-complete Github issues in fugitive
  'samoshkin/vim-mergetool', -- Better merging (3-way becomes 2-way)
  'rhysd/git-messenger.vim', -- pop-up window of git commit under cursor
  'sodapopcan/vim-twiggy',   -- pop-up git branches
  'rbong/vim-flog',          -- pretty git log
  'mattn/webapi-vim',        -- for vim-gist

  {                          -- generate a link to file on git remote site
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitlinker').setup()
    end,
  },

  { -- tight git integration
    'tpope/vim-fugitive',
    config = function()
      vim.cmd [[autocmd me FileType fugitive nmap <buffer> q gq]]
    end,
  },

  { -- Gist support
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
  },

  { -- show git changes in the gutter
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'BufReadPre',
    config = true,
  },

  { -- magic git UI
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    cmd = 'Neogit',
    opts = {
      use_telescope = true,
      disable_insert_on_commit = 'auto',
      use_magit_keybindings = true,
      integrations = {
        diffview = true,
      },
    },
  },
}
