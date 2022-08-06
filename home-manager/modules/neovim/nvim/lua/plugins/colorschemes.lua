return function(use)
  vim.cmd [[autocmd packer ColorScheme * lua require('lualine').setup()]]
  vim.cmd [[autocmd packer OptionSet background lua me.fn.autocmd_onOptionSetBackground()]]
  function _G.me.fn.autocmd_onOptionSetBackground()
    if vim.o.background == 'dark' then
      vim.cmd [[Catppuccin mocha]]
    else
      vim.cmd [[Catppuccin latte]]
    end
  end

  use 'liuchengxu/space-vim-theme'

  use 'NLKNguyen/papercolor-theme'

  use 'bluz71/vim-moonfly-colors'

  use {
    'https://gitlab.com/protesilaos/tempus-themes-vim', -- accessible themes
    setup = function()
      vim.g.tempus_enforce_background_color = true
    end,
  }

  use {
    'ellisonleao/gruvbox.nvim',
    requires = 'rktjmp/lush.nvim',
    setup = function()
      vim.g.gruvbox_italic = true
      vim.g.gruvbox_invert_selection = false
      vim.g.gruvbox_contrast_dark = 'hard'
      vim.g.gruvbox_sign_column = 'bg0'
      vim.g.gruvbox_color_column = 'bg0'
    end,
  }
  use {
    'marko-cerovac/material.nvim',
    setup = function()
      vim.g.material_lighter_contrast = true
    end,
  }

  use {
    'folke/tokyonight.nvim',
  }
  use {
    'projekt0n/github-nvim-theme',
    setup = function()
      vim.g.github_sidebars = _G.me.o.sidebars
    end,
    config = function()
      -- vim.cmd [[colorscheme github_dimmed]]
    end,
  }

  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    setup = function()
      vim.g.catppuccin_flavour = 'mocha' -- latte, frappe, macchiato, mocha
    end,
    config = function()
      require('catppuccin').setup {
        integrations = {
          lsp_trouble = true,
          lsp_saga = true,
          which_key = true,
          nvimtree = {
            enabled = true,
          },
        },
      }
      vim.cmd [[colorscheme catppuccin]]
    end,
  }
end
