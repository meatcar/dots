-- vim: set foldmethod=marker

return {
  'folke/which-key.nvim', --popup ui for obscure keys
  lazy = false,
  opts = function(_, opts)
    opts.spelling = { enabled = true }
  end,
  config = function(_, opts)
    local wk = require 'which-key'

    wk.setup(opts)

    local leadermap = {
      m = { '<Cmd>call feedkeys(g:maplocalleader)<CR>', '+localleader' },
      [' '] = { ':', 'Command' },
      ['/'] = { '<Cmd>Telescope live_grep<CR>', 'Search' },
      ['*'] = { '<Cmd>Telescope grep_string search=<cword><CR>', 'Search current word' },
      [':'] = { '<Cmd>Telescope commands<CR>', 'Commands' },
      s = { name = 'surround' },
    }
    wk.register {
      ['//'] = { '<Cmd>Telescope current_buffer_fuzzy_find<CR>', 'Buffer lines' },
    }

    local leadermap_v = {}
    local leadermap_t = {}

    leadermap.v = {
      name = 'vim',
      l = {
        name = 'lazy',
        l = { '<Cmd>Lazy<CR>', 'Lazy' },
        c = { '<Cmd>Lazy clean<CR>', 'Lazy clean' },
        u = { '<Cmd>Lazy check<CR>', 'Lazy check' },
        p = { '<Cmd>Lazy profile<CR>', 'Lazy profile' },
      }
    }

    leadermap.h = {
      name = 'help', -- {{{
      h = { '<Cmd>Telescope help_tags<CR>', 'Help' },
      k = { '<Cmd>Telescope keymaps<CR>', 'Keymaps' },
      c = { '<Cmd>Telescope commands<CR>', 'Commands' },
    } -- }}}

    leadermap.q = {
      name = 'quit', -- {{{
      q = { '<Cmd>q<CR>', 'Quit' },
      w = { '<Cmd>wq<CR>', 'Save and quit' },
      x = { '<Cmd>x<CR>', 'Save and exit' },
    } -- }}}

    leadermap.b = {
      name = 'buffers', -- {{{
      b = { '<Cmd>Telescope buffers show_all_buffers=true<CR>', 'Buffers' },
      B = { '<Cmd>BufferPick<CR>', 'Bufferline Pick' },
      d = { '<Cmd>BufferClose<CR>', 'Delete buffer' },
      n = { ']b', 'Next' },
      p = { '[b', 'Prev' },
      N = { '<Cmd>BufferMoveNext<CR>', 'Move left' },
      P = { '<Cmd>BufferMovePrev<CR>', 'Move prev' },
      i = { '<Cmd>BufferPin<CR>', 'Pin buffer' },
    } -- }}}

    leadermap.f = {
      name = 'files', -- {{{
      r = { '<Cmd>Telescope oldfiles<CR>', 'Recent' },
      f = { '<Cmd>Telescope find_files<CR>', 'Files' },
    } -- }}}

    leadermap.g = {
      name = 'git', -- {{{
      f = { '<Cmd>Telescope git_files<CR>', 'Files' },
    }               -- }}}

    leadermap.t = { name = 'toggle', }

    leadermap.c = {
      name = 'change',
      c = { '<Cmd>Telescope colorscheme<CR>', 'Colorscheme' },
      f = { '<Cmd>Telescope filetypes<CR>', 'Filetype' },
    }

    leadermap.o = { name = 'open' }

    leadermap.r = { name = 'run' }

    leadermap.w = {
      name = 'window',
      q = { '<Cmd>hide<CR>', 'Close' },
      d = { '<Cmd>hide<CR>', 'Close' },
      j = { '<C-w>j', 'Focus down' },
      k = { '<C-w>k', 'Focus up' },
      l = { '<C-w>l', 'Focus left' },
      h = { '<C-w>h', 'Focus right' },
      s = { '<Cmd>split<CR>', 'Split' },
      v = { '<Cmd>vsplit<CR>', 'Vertical split' },
    }

    leadermap.l = { name = 'lsp' }

    leadermap.n = { name = 'notes' }

    wk.register(leadermap, { prefix = '<leader>' })
    wk.register(leadermap_v, { prefix = '<leader>', mode = 'v' })
    wk.register(leadermap_t, { prefix = '<leader>', mode = 't' })
  end,
}
