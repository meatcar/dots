-- detect system dark mode at startup/sync
function _G.me.fn.autocmd_onVimEnterSetBackground()
  local theme = vim.fn.trim(vim.fn.system 'get-theme')
  -- print('Setting background to ' .. theme)
  vim.o.background = theme -- 'dark' or 'light' or a message will be shown
end

vim.api.nvim_create_autocmd({ 'User' }, {
  group = 'me',
  pattern = 'LazyDone',
  nested = true,
  callback = _G.me.fn.autocmd_onVimEnterSetBackground,
})
vim.api.nvim_create_autocmd({ 'User' }, {
  group = 'me',
  pattern = 'LazyReload',
  nested = true,
  callback = _G.me.fn.autocmd_onVimEnterSetBackground,
})

return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- main theme, load first
    lazy = false,
    opts = {
      flavour = 'mocha',
      integrations = {
        barbar = true,
        cmp = true,
        dropbar = {
          enabled = true,
          color_mode = true, -- enable color for kind's texts, not just kind's icons
        },
        gitsigns = true,
        illuminate = {
          enabled = true,
          lsp = true
        },
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        leap = true,
        lsp_saga = true,
        lsp_trouble = true,
        headlines = true,
        fidget = true,
        markdown = true,
        mini = true,
        neotree = true,
        neogit = true,
        notify = true,
        rainbow_delimiters = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'liuchengxu/space-vim-theme',
    lazy = false,
  },

  {
    'bluz71/vim-moonfly-colors',
    lazy = false,
  },

  {
    'B4mbus/oxocarbon-lua.nvim',
    lazy = false,
  },

  {
    'https://gitlab.com/protesilaos/tempus-themes-vim', -- accessible themes
    lazy = false,
    init = function()
      vim.g.tempus_enforce_background_color = true
    end,
  },

  {
    'ellisonleao/gruvbox.nvim',
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    init = function()
      vim.g.gruvbox_italic = true
      vim.g.gruvbox_invert_selection = false
      vim.g.gruvbox_contrast_dark = 'hard'
      vim.g.gruvbox_sign_column = 'bg0'
      vim.g.gruvbox_color_column = 'bg0'
    end,
  },
  {
    'marko-cerovac/material.nvim',
    lazy = false,
    init = function()
      vim.g.material_lighter_contrast = true
    end,
  },

  {
    'folke/tokyonight.nvim',
    lazy = false,
  },
  {
    'projekt0n/github-nvim-theme',
    main = 'github-theme',
    lazy = false,
    opts = {
      options = {
        darken = { -- Darken floating windows and sidebar-like windows
          floats = false,
          sidebars = {
            enabled = true,
            list = me.o.panels, -- Apply dark background to specific windows
          },
        },

      }
    }
  },
}
