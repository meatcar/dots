-- vim: set foldmethod=marker
local wk = require("which-key")

wk.setup({
    spelling = {enabled = true}
  })

local leadermap = {
  m = { '<CMD>call feedkeys(g:maplocalleader)<CR>', '+localleader' },
  [' '] = {':', 'command'},
  ['/'] = {'<CMD>Telescope live_grep<CR>', 'search'},
  ['*'] = {'<CMD>Telescope grep_string search=<cword><CR>', 'search-cur-word'},
  [':'] = {'<CMD>Telescope commands<CR>', 'commands'},
  s = {'<CMD>Snippets<CR>', 'snippets'}
}
wk.register({
    ['//'] = {'<CMD>Telescope current_buffer_fuzzy_find<CR>', 'buffer-lines'},
  })

local leadermap_v = {}
local leadermap_t = {}

leadermap.v = { name = 'vim', -- {{{
  i = { '<CMD>PackInstall<CR>', 'pack-install' },
  c = { '<CMD>PackClean<CR>', 'pack-clean'},
  u = { '<CMD>PackUpdate<CR>', 'pack-update' },
} -- }}}

leadermap.h = { name = 'help', -- {{{
  h = { '<CMD>Telescope help_tags<CR>', 'help' },
  k = { '<CMD>Telescope keymaps<CR>', 'keymaps' },
  c = { '<CMD>Telescope commands<CR>', 'commands' },
} -- }}}

leadermap.q = { name = 'quit', -- {{{
  q = { '<CMD>q<CR>', 'quit' },
  w = { '<CMD>wq<CR>', 'save and quit' },
  x = { '<CMD>x<CR>', 'save and exit' },
} -- }}}

leadermap.b = { name = 'buffers', -- {{{
  b = { '<CMD>Telescope buffers<CR>', 'buffers' },
  d = { '<CMD>Bdelete<CR>', 'buffer-delete' },
  n = { ']b', 'next'},
  p = { '[b', 'prev'},
  N = { '<CMD>BufferLineMoveNext<CR>', 'move-next' },
  P = { '<CMD>BufferLineMovePrev<CR>', 'move-prev' },
} -- }}}

leadermap.f = { name = 'files', -- {{{
  r = {'<CMD>Telescope oldfiles<CR>', 'recent'},
  f =  {'<CMD>Telescope find_files<CR>', 'files'},
  t = {
    name = 'file-tree',
    t = {'<CMD>NvimTreeToggle<CR>', 'toggle'},
    r = {'<CMD>NvimTreeRefresh<CR>', 'refresh'},
    f = {'<CMD>NvimTreeFindFile<CR>', 'find-file'},
  },
} -- }}}

leadermap.g = { name = 'git', -- {{{
  f = {'<CMD>Telescope git_files<CR>', 'files'},
  F = {'<CMD>Telescope git_status<CR>', 'status'},
  b = {'<CMD>Twiggy<CR>', 'branches'},
  l = {'<CMD>Flog<CR>', 'log'},
  s = {'<CMD>Git<CR>', 'status'},
  g = {':<C-u>Git<Space>', 'Git...'},
} -- }}}

leadermap.t = { name = 'toggle', -- {{{
  c = {'<CMD>Telescope colorscheme<CR>', 'colorscheme'},
  f = {'<CMD>Telescope filetypes<CR>', 'filetype'},
  u = {'<CMD>MundoToggle<CR>', 'undo'},
  r = {'<CMD>RainbowParenthesesToggle<CR>', 'rainbow-parens'},
  i = {'<CMD>IndentBlanklineToggle<CR>', 'indent-highlight'},
  l = {'<CMD>LspTroubleToggle<CR>', 'lsp'},
  t = {'<CMD>Lspsaga open_floaterm<CR>', 'terminal'},
}
leadermap_t.t = {
  name = leadermap.t.name,
  t = {'<CMD>LspSaga close_floaterm<CR>', 'terminal'},
} -- }}}

leadermap.r = { name = 'run', -- {{{
  t = {
    name = 'test',
    t = {'<CMD>TestNearest<CR>', 'nearest'},
    f = {'<CMD>TestFile<CR>', 'file'},
    s = {'<CMD>TestSuite<CR>', 'suite'},
    r = {'<CMD>TestLast<CR>', 'recent'},
    g = {'<CMD>TestVisit<CR>', 'goto'},
  }
} -- }}}

leadermap.w = { name = 'window', -- {{{
  q = {'<CMD>hide<CR>', 'close'},
  d = {'<CMD>hide<CR>', 'close'},
  j = {'<C-w>j', 'focus-down'},
  k = {'<C-w>k', 'focus-up'},
  l = {'<C-w>l', 'focus-left'},
  h = {'<C-w>h', 'focus-right'},
  s = {'<CMD>split<CR>', 'split'},
  v = {'<CMD>vsplit<CR>', 'vertical-split'},
  z = {'<C-w><T>', 'zoom'},
} -- }}}

leadermap.l = { name = 'lsp', -- {{{
  r = {'<CMD>LspTroubleToggle lsp_references<CR>', 'references'},
  a = {'<CMD>Lspsaga code_action<CR>', 'action'},
  h = {'<CMD>Lspsaga hover_doc<CR>', 'hover-doc'},
  s = {'<CMD>Lspsaga signature_help<CR>', 'signature'},
  m = {'<CMD>Lspsaga rename<CR>', 'rename'},
  d = {'<CMD>Lspsaga preview_definition<CR>', 'definition'},
  l = {'<CMD>Lspsaga show_line_diagnostics<CR>', 'line-info'},
  c = {'<CMD>Lspsaga show_cursor_diagnostics<CR>', 'cursor-info'},
}
leadermap_v.l = {
  name = leadermap.l.name,
  a = {'<CMD>Lspsaga range_code_action<CR>', 'action'},
}
wk.register({
    [']d'] = {'<CMD>Lspsaga diagnostic_jump_next<CR>', 'Next Lsp Diagnostic'},
    ['[d'] = {'<CMD>Lspsaga diagnostic_jump_prev<CR>', 'Prev Lsp Diagnostic'},
  }) -- }}}

wk.register(leadermap, {prefix = '<leader>'})
wk.register(leadermap_v, {prefix = '<leader>', mode = 'v'})
wk.register(leadermap_t, {prefix = '<leader>', mode = 't'})
