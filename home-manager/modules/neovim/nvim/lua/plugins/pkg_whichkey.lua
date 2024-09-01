-- vim: set foldmethod=marker

return {
  'folke/which-key.nvim', --popup ui for obscure keys
  lazy = false,
  opts = {
    preset = 'modern',
    plugins = {
      spelling = {
        enabled = true
      }
    }
  },
  config = function(_, opts)
    local wk = require 'which-key'

    wk.setup(opts)

    wk.add {
      { '//',          '<Cmd>Telescope current_buffer_fuzzy_find<CR>',     desc = 'Buffer lines' },
      { '<leader>*',   '<Cmd>Telescope grep_string search=<cword><CR>',    desc = 'Search current word' },
      { '<leader>/',   '<Cmd>Telescope live_grep<CR>',                     desc = 'Search' },
      { '<leader>:',   '<Cmd>Telescope commands<CR>',                      desc = 'Commands' },
      { '<leader>b',   group = 'buffers' },
      { '<leader>bb',  '<Cmd>Telescope buffers show_all_buffers=true<CR>', desc = 'Buffers' },
      { '<leader>c',   group = 'change' },
      { '<leader>cc',  '<Cmd>Telescope colorscheme<CR>',                   desc = 'Colorscheme' },
      { '<leader>cf',  '<Cmd>Telescope filetypes<CR>',                     desc = 'Filetype' },
      { '<leader>f',   group = 'files' },
      { '<leader>ff',  '<Cmd>Telescope find_files<CR>',                    desc = 'Files' },
      { '<leader>fr',  '<Cmd>Telescope oldfiles<CR>',                      desc = 'Recent' },
      { '<leader>g',   group = 'git' },
      { '<leader>gf',  '<Cmd>Telescope git_files<CR>',                     desc = 'Files' },
      { '<leader>h',   group = 'help' },
      { '<leader>hc',  '<Cmd>Telescope commands<CR>',                      desc = 'Commands' },
      { '<leader>hh',  '<Cmd>Telescope help_tags<CR>',                     desc = 'Help' },
      { '<leader>hk',  '<Cmd>Telescope keymaps<CR>',                       desc = 'Keymaps' },
      { '<leader>l',   group = 'lsp' },
      { '<leader>m',   '<Cmd>call feedkeys(g:maplocalleader)<CR>',         desc = '+localleader' },
      { '<leader>n',   group = 'notes' },
      { '<leader>o',   group = 'open' },
      { '<leader>q',   group = 'quit' },
      { '<leader>qq',  '<Cmd>q<CR>',                                       desc = 'Quit' },
      { '<leader>qw',  '<Cmd>wq<CR>',                                      desc = 'Save and quit' },
      { '<leader>qx',  '<Cmd>x<CR>',                                       desc = 'Save and exit' },
      { '<leader>r',   group = 'run' },
      { '<leader>s',   group = 'surround' },
      { '<leader>t',   group = 'toggle' },
      { '<leader>v',   group = 'vim' },
      { '<leader>vl',  group = 'lazy' },
      { '<leader>vlc', '<Cmd>Lazy check<CR>',                              desc = 'Lazy check' },
      { '<leader>vll', '<Cmd>Lazy<CR>',                                    desc = 'Lazy' },
      { '<leader>vlp', '<Cmd>Lazy profile<CR>',                            desc = 'Lazy profile' },
      { '<leader>vlx', '<Cmd>Lazy clean<CR>',                              desc = 'Lazy clean' },
      { '<leader>w',   group = 'window' },
      { '<leader>wd',  '<Cmd>hide<CR>',                                    desc = 'Close' },
      { '<leader>wh',  '<C-w>h',                                           desc = 'Focus right' },
      { '<leader>wj',  '<C-w>j',                                           desc = 'Focus down' },
      { '<leader>wk',  '<C-w>k',                                           desc = 'Focus up' },
      { '<leader>wl',  '<C-w>l',                                           desc = 'Focus left' },
      { '<leader>wq',  '<Cmd>hide<CR>',                                    desc = 'Close' },
      { '<leader>ws',  '<Cmd>split<CR>',                                   desc = 'Split' },
      { '<leader>wv',  '<Cmd>vsplit<CR>',                                  desc = 'Vertical split' },
    }
  end,
}
