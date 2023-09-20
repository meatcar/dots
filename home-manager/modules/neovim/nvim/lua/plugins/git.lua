return {
  { -- auto-complete Github issues in fugitive
    'tpope/vim-rhubarb',
    event = me.o.events.insert,
    ft = 'gitcommit'
  },
  { -- Better merging (3-way becomes 2-way)
    'samoshkin/vim-mergetool',
    cmd = { 'MergetoolStart', 'MergetoolStop', 'MergetoolToggle' }
  },
  { -- pop-up window of git commit under cursor
    'rhysd/git-messenger.vim',
    cmd = 'GitMessenger'
  },
  { -- pretty git log
    'rbong/vim-flog',
    cmd = 'Flog'
  },

  { -- pretty branches
    'sodapopcan/vim-twiggy',
    cmd = 'Twiggy'
  },

  { -- generate a link to file on git remote site
    'ruifm/gitlinker.nvim',
    keys = {
      {
        '<leader>gy',
        function()
          require('gitlinker').get_buf_range_url('n')
        end,
        desc = 'Yank link to line in repo',
        mode = { 'n' }
      },
      {
        '<leader>gy',
        function()
          require('gitlinker').get_buf_range_url('v')
        end,
        desc = 'Yank link to range in repo',
        mode = { 'v' }
      }
    }
  },

  { -- tight git integration
    'tpope/vim-fugitive',
    cmd = {
      'G', 'Git', 'Grep', 'Glgrep', 'Gclog', 'Gllog', 'Gcd', 'Glcd', 'Gedit', 'Gsplit', 'Gvsplit', 'Gtabedit',
      'Gpedit', 'Gdrop', 'Gread', 'Gwrite', 'Gdiffsplit', 'Gvdiffsplit'
    },
    config = function()
      vim.cmd [[autocmd me FileType fugitive nmap <buffer> q gq]]
    end,
  },

  { -- Gist support
    'mattn/vim-gist',
    dependencies = 'mattn/webapi-vim',
    cmd = 'Gist',
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
    event = me.o.events.buf_early,
    config = true,
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>',          desc = 'Diff repo' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'History of file' },
      { '<leader>gB', '<cmd>DiffviewFileHistory<CR>',   desc = 'History of branch' },
    },
    config = true,
    opts = {
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } }
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } }
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } }
        }
      }
    }
  },

  { -- magic git UI
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    opts = {
      use_telescope = true,
      disable_insert_on_commit = 'auto',
      use_magit_keybindings = true,
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
  },
}
