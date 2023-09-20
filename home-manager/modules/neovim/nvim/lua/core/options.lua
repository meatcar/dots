-- fastest shell!
vim.o.shell = 'sh'

-- truecolor support
vim.o.termguicolors = true

-- window title
vim.o.title = false -- TODO : see https://github.com/neovim/neovim/issues/18573
vim.o.titlelen = 20

-- ensure utf8
vim.o.encoding = 'utf-8'

-- mouse
vim.o.mouse = 'a'
vim.o.mousemoveevent = true

-- write file to disk on :next, :make, etc
vim.o.autowrite = true

-- store files in 'undodir'
vim.o.undofile = true

-- line numbering
vim.o.numberwidth = 1

-- brackets and pairing
vim.o.showmatch = true
vim.opt.matchpairs:append '<:>'

vim.o.whichwrap = 'h,l,<,>,[,]'

-- wrapping
vim.o.linebreak = true   -- soft-wrap lines, don't break them (bad opt name)
vim.o.breakindent = true -- indent soft-wrapped lines
vim.o.breakindentopt = 'shift:2,list:-1,min:30'

-- new windows
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.previewheight = 9

-- completion
vim.o.wildmode = 'longest:full,full'
vim.o.pumblend = 20
vim.o.winblend = 20
vim.cmd [[ hi PmenuSel blend=0 ]]
vim.o.completeopt = 'menu,menuone,noselect'

-- diff
vim.o.diffopt = 'filler,internal,algorithm:patience,indent-heuristic,closeoff,iwhite,linematch:60'
vim.opt.fillchars:append { diff = "╱" } -- diagonal hatched lines for deletions

-- whitespace
vim.o.listchars = 'tab:⇥ ,eol:$,trail:·,extends:…,precedes:…,nbsp:␣'
vim.opt.fillchars:append { vert = '│' }

-- clean-up messages
vim.o.showmode = false
vim.opt.shortmess:append 'c'
vim.opt.shortmess:append 'o'

vim.opt.viewoptions:remove 'curdir'

-- folds
vim.opt.foldopen:append 'insert,jump'

-- tabs & indents
vim.o.expandtab = true -- spaces over tabs
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- grep
vim.o.grepprg = 'rg --vimgrep'
vim.opt.grepformat:prepend '%f:%l:%c:%m'

-- leader
vim.o.timeoutlen = 1000
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- include the whitespace following a word motion
vim.opt.cpoptions:remove '_'

-- hide commandline, have it replace statusbar when : is pressed
vim.o.cmdheight = 0
