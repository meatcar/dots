-- vim: set foldmethod=marker
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
  s = { '<Cmd>Snippets<CR>', 'Snippets' },
}
wk.register {
  ['//'] = { '<Cmd>Telescope current_buffer_fuzzy_find<CR>', 'Buffer lines' },
}

local leadermap_v = {}
local leadermap_t = {}

leadermap.v = {
  name = 'vim', -- {{{
  s = { '<Cmd>PackerSync<CR>', 'PackerSync' },
  c = { '<Cmd>PackerClean<CR>', 'PackerClean' },
  u = { '<Cmd>PackerUpdate<CR>', 'PackerUpdate' },
  p = { '<Cmd>PackerProfile<CR>', 'PackerProfile' },
  S = { '<Cmd>PackerStatus<CR>', 'PackerStatus' },
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
  d = { '<Cmd>BDelete this<CR>', 'Delete buffer' },
  n = { ']b', 'Next' },
  p = { '[b', 'Prev' },
  N = { '<Cmd>BufferLineMoveNext<CR>', 'Move left' },
  P = { '<Cmd>BufferLineMovePrev<CR>', 'Move prev' },
} -- }}}

leadermap.f = {
  name = 'files', -- {{{
  r = { '<Cmd>Telescope oldfiles<CR>', 'Recent' },
  f = { '<Cmd>Telescope find_files<CR>', 'Files' },
  t = {
    name = 'file-tree',
    t = { '<Cmd>NvimTreeToggle<CR>', 'Toggle' },
    r = { '<Cmd>NvimTreeRefresh<CR>', 'Refresh' },
    f = { '<Cmd>NvimTreeFindFile<CR>', 'Find file' },
  },
} -- }}}

leadermap.g = {
  name = 'git', -- {{{
  f = { '<Cmd>Telescope git_files<CR>', 'Files' },
  F = { '<Cmd>Telescope git_status<CR>', 'Status' },
  b = { '<Cmd>Twiggy<CR>', 'Branches' },
  l = { '<Cmd>Flog<CR>', 'Log' },
  s = { '<Cmd>Git<CR>', 'Status' },
  g = { ':<C-u>Git<Space>', ':Git' },
} -- }}}

leadermap.t = {
  name = 'toggle', -- {{{
  c = { '<Cmd>Telescope colorscheme<CR>', 'Colorscheme' },
  f = { '<Cmd>Telescope filetypes<CR>', 'Filetype' },
  u = { '<Cmd>MundoToggle<CR>', 'Undo' },
  r = { '<Cmd>RainbowParenthesesToggle<CR>', 'Rainbow parens' },
  i = { '<Cmd>IndentBlanklineToggle<CR>', 'Indent highlight' },
  l = { '<Cmd>LspTroubleToggle<CR>', 'LSP' },
  t = { [[<Cmd>Lspsaga open_floaterm $SHELL<CR>]], 'Terminal' },
}
leadermap_t.t = {
  name = leadermap.t.name,
  t = { [[:Lspsaga close_floaterm<CR>]], 'Close Terminal' },
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
  r = { '<Cmd>LspTroubleToggle lsp_references<CR>', 'References' },
  a = { '<Cmd>Lspsaga code_action<CR>', 'Action' },
  h = { '<Cmd>Lspsaga hover_doc<CR>', 'Hover Doc' },
  s = { '<Cmd>Lspsaga signature_help<CR>', 'Signature' },
  m = { '<Cmd>Lspsaga rename<CR>', 'Rename' },
  d = { '<Cmd>Lspsaga preview_definition<CR>', 'Definition' },
  l = { '<Cmd>Lspsaga show_line_diagnostics<CR>', 'Line info' },
  c = { '<Cmd>Lspsaga show_cursor_diagnostics<CR>', 'Cursor info' },
}
leadermap_v.l = {
  name = leadermap.l.name,
  a = { '<Cmd>Lspsaga range_code_action<CR>', 'Action' },
}
wk.register {
  [']d'] = { '<Cmd>Lspsaga diagnostic_jump_next<CR>', 'Next LSP diagnostic' },
  ['[d'] = { '<Cmd>Lspsaga diagnostic_jump_prev<CR>', 'Previous LSP diagnostic' },
}

leadermap.n = {
  name = 'notes', -- {{{
  c = { ':<C-u>NoteNew<Space>', 'Create new note' },
  n = { ':<C-u>NoteFind<Space>', 'Find a note' },
  ['/'] = { ':<C-u>NoteRg<Space>', 'Search in notes' },
  j = { '<Cmd>NoteJournal<CR>', 'Journal' },
} -- }}}

wk.register(leadermap, { prefix = '<leader>' })
wk.register(leadermap_v, { prefix = '<leader>', mode = 'v' })
wk.register(leadermap_t, { prefix = '<leader>', mode = 't' })
