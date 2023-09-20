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
    lazy = false,
    init = function()
      vim.g.github_sidebars = _G.me.o.sidebars
    end,
    config = function()
      -- vim.cmd [[colorscheme github_dimmed]]
    end,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,                     -- main theme, load first
    init = function()
      vim.g.catppuccin_flavour = 'mocha' -- latte, frappe, macchiato, mocha
    end,
    opts = {
      integrations = {
        lsp_trouble = true,
        lsp_saga = true,
        which_key = true,
        neotree = true,
        barbar = true,
        cmp = true,
        leap = true,
        markdown = true,
        mini = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
      },
    },
    config = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
