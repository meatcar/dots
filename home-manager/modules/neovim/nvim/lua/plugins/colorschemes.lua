--vim.cmd [[autocmd me OptionSet background lua me.fn.autocmd_onOptionSetBackground()]]
--function _G.me.fn.autocmd_onOptionSetBackground()
--  if vim.o.background == 'dark' then
--    vim.cmd [[Catppuccin mocha]]
--  else
--    vim.cmd [[Catppuccin latte]]
--  end
--end

-- detect system dark mode at startup/sync
vim.cmd [[autocmd me User LazyDone ++nested lua me.fn.autocmd_onVimEnterSetBackground()]]
vim.cmd [[autocmd me User LazyReload ++nested lua me.fn.autocmd_onVimEnterSetBackground()]]
function _G.me.fn.autocmd_onVimEnterSetBackground()
  local theme = vim.fn.readfile '/mnt/c/Users/meatcar/.config/theme'
  -- print('Setting background to ' .. theme[1])
  vim.o.background = theme[1] -- 'dark' or 'light' or a message will be shown
  vim.cmd [[colorscheme catppuccin]]
end

return {
  'liuchengxu/space-vim-theme',

  'NLKNguyen/papercolor-theme',

  'bluz71/vim-moonfly-colors',

  'B4mbus/oxocarbon-lua.nvim',

  {
    'https://gitlab.com/protesilaos/tempus-themes-vim', -- accessible themes
    init = function()
      vim.g.tempus_enforce_background_color = true
    end,
  },

  {
    'ellisonleao/gruvbox.nvim',
    dependencies = 'rktjmp/lush.nvim',
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
    init = function()
      vim.g.material_lighter_contrast = true
    end,
  },

  {
    'folke/tokyonight.nvim',
  },
  {
    'projekt0n/github-nvim-theme',
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
  },
}
