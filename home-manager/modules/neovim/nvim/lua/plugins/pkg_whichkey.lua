-- vim: set foldmethod=marker

return {
  'folke/which-key.nvim', --popup ui for obscure keys
  config = function()
    local wk = require 'which-key'

    wk.setup {
      spelling = { enabled = true },
    }

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
      name = 'vim', -- {{{
      v = { '<Cmd>Lazy<CR>', 'Lazy' },
      s = { '<Cmd>Lazy sync<CR>', 'Lazy sync' },
      c = { '<Cmd>Lazy clean<CR>', 'Lazy clean' },
      u = { '<Cmd>Lazy check<CR>', 'Lazy check' },
      p = { '<Cmd>Lazy profile<CR>', 'Lazy profile' },
      h = {
        function()
          require('noice').cmd 'telescope'
        end,
        'Message History',
      },
    } -- }}}

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
      t = {
        name = 'file-tree',
        t = { '<Cmd>Neotree toggle<CR>', 'Toggle' },
        f = { '<Cmd>Neotree filesystem reveal_file=%<CR>', 'Find file' },
      },
    } -- }}}

    leadermap.g = {
      name = 'git', -- {{{
      f = { '<Cmd>Telescope git_files<CR>', 'Files' },
      F = { '<Cmd>Telescope git_status<CR>', 'Status' },
      b = { '<Cmd>Twiggy<CR>', 'Branches' },
      l = { '<Cmd>Flog<CR>', 'Log' },
      s = { '<Cmd>Neogit<CR>', 'Status' },
      g = { ':<C-u>Git<Space>', ':Git' },
    } -- }}}

    leadermap.t = {
      name = 'toggle', -- {{{
      p = { '<Cmd>RainbowParenthesesToggle<CR>', 'Toggle rainbow parens' },
      I = { '<Cmd>IndentBlanklineToggle<CR>', 'Toggle indent highlight' },
    } -- }}}

    leadermap.c = {
      name = 'change', -- {{{
      c = { '<Cmd>Telescope colorscheme<CR>', 'Colorscheme' },
      f = { '<Cmd>Telescope filetypes<CR>', 'Filetype' },
    } -- }}}

    leadermap.o = {
      name = 'open', -- {{{
      u = { '<Cmd>MundoToggle<CR>', 'Undo Tree' },
      r = { '<Cmd>Telescope resume<CR>', 'Resume Telescope' },
      n = { '<Cmd>Telecope notify<CR>', 'Notifications' },
      f = { '<Cmd>Neotree<CR>', 'File Tree' },
      t = { '<Cmd>TodoTelescope<CR>', 'TODO' },
    } -- }}}

    leadermap.r = {
      name = 'run', -- {{{
      t = {
        name = 'test',
        t = { '<Cmd>TestNearest<CR>', 'Nearest' },
        f = { '<Cmd>TestFile<CR>', 'File' },
        s = { '<Cmd>TestSuite<CR>', 'Suite' },
        r = { '<Cmd>TestLast<CR>', 'Recent' },
        g = { '<Cmd>TestVisit<CR>', 'Goto' },
      },
      r = {
        name = 'command',
        p = { '<Cmd>VimuxPromptCommand<CR>', 'Prompt' },
        r = { '<Cmd>VimuxRunLastCommand<CR>', 'Last' },
        i = { '<Cmd>VimuxInspectRunner<CR>', 'Inspect' },
        o = { '<Cmd>VimuxOpenRunner<CR>', 'Open' },
        q = { '<Cmd>VimuxCloseRunner<CR>', 'Close' },
        d = { '<Cmd>VimuxCloseRunner<CR>', 'Close' },
        s = { '<Cmd>VimuxInterruptRunner<CR>', 'Interrupt' },
        c = { '<Cmd>VimuxInterruptRunner<CR>', 'Interrupt' },
        l = { '<Cmd>VimuxClearTerminalScreen<CR>', 'Clear' },
        z = { '<Cmd>VimuxZoomRunner<CR>', 'Zoom' },
      },
    } -- }}}

    leadermap.w = {
      name = 'window', -- {{{
      q = { '<Cmd>hide<CR>', 'Close' },
      d = { '<Cmd>hide<CR>', 'Close' },
      j = { '<C-w>j', 'Focus down' },
      k = { '<C-w>k', 'Focus up' },
      l = { '<C-w>l', 'Focus left' },
      h = { '<C-w>h', 'Focus right' },
      s = { '<Cmd>split<CR>', 'Split' },
      v = { '<Cmd>vsplit<CR>', 'Vertical split' },
      z = { '<C-w><T>', 'Zoom' },
    } -- }}}

    leadermap.l = {
      name = 'lsp', -- {{{
      a = { '<Cmd>Lspsaga code_action<CR>', 'Action' },
      h = { '<Cmd>Lspsaga hover_doc<CR>', 'Hover Doc' },
      s = { '<Cmd>Lspsaga signature_help<CR>', 'Signature' },
      m = { '<Cmd>Lspsaga rename<CR>', 'Rename' },
      d = { '<Cmd>Lspsaga preview_definition<CR>', 'Definition' },
      i = { '<Cmd>Lspsaga show_line_diagnostics<CR>', 'Line info' },
      c = { '<Cmd>Lspsaga show_cursor_diagnostics<CR>', 'Cursor info' },
      l = {
        name = 'lsp',
        r = { '<Cmd>LspRestart<CR>', 'Restart' },
        o = { '<Cmd>LspStop<CR>', 'Stop' },
        a = { '<Cmd>LspStart<CR>', 'Start' },
        l = { '<Cmd>LspInfo<CR>', 'Info' },
      },
    }
    leadermap_v.l = {
      name = leadermap.l.name,
      a = { '<Cmd>Lspsaga range_code_action<CR>', 'Action' },
    }

    leadermap.n = {
      name = 'notes', -- {{{
      c = { ':<C-u>NoteNew<Space>', 'Create new note' },
      n = { ':<C-u>NoteFind<CR>', 'Find a note' },
      N = { ':<C-u>NoteFind<Space>', 'Find a note in a subdirectory' },
      ['/'] = { ':<C-u>NoteGrep<CR>', 'Search notes' },
      F = { ':<C-u>NoteGrep<Space>', 'Search notes in a subdirectory' },
      j = { '<Cmd>JournalDaily<CR>', 'Journal' },
      J = { '<Cmd>JournalDaily<Space>', 'Open a specific journal' },
    } -- }}}

    leadermap.a = {
      name = 'NeoAI', -- {{{
      a = { '<cmd>NeoAIToggle<cr>', 'NeoAI' },
      c = { '<cmd>NeoAIContext<cr>', 'NeoAI Context', mode = 'v' },
      s = { '<cmd>NeoAIShortcut textify<cr>', 'summarize text', mode = 'v' },
      g = { '<cmd>NeoAIShortcut gitcommit<cr>', 'generate git commit' },
      i = {
        name = 'inject',
        i = { '<c-u>:NeoAIInject ', 'Inject', mode = 'v' },
        c = { '<c-u>:NeoAIInjectCode ', 'Code', mode = 'v' },
        v = {
          name = 'context',
          v = { '<c-u>:NeoAIInjectContext ', 'Context', mode = 'v' },
          c = { '<c-u>:NeoAIInjectContextCode ', 'Context Code', mode = 'v' },
        },
      },
    } -- }}}

    wk.register(leadermap, { prefix = '<leader>' })
    wk.register(leadermap_v, { prefix = '<leader>', mode = 'v' })
    wk.register(leadermap_t, { prefix = '<leader>', mode = 't' })
  end,
}
