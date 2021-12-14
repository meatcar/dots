-- fastest shell!
vim.o.shell = 'sh'

-- truecolor support
vim.o.termguicolors = true

-- window title
vim.o.title = true
vim.o.titlelen = 20

-- ensure utf8
vim.o.encoding = 'utf-8'

-- speed up large files
vim.o.lazyredraw = true

-- mouse
vim.o.mouse = 'a'

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
vim.o.linebreak = true -- soft-wrap lines, don't break them (bad opt name)
vim.o.breakindent = true -- indent soft-wrapped lines
vim.o.breakindentopt = 'shift:2,list:-1,min:30'
vim.o.showbreak = '↳ '
vim.opt.cpoptions:append 'n'

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
vim.o.diffopt = 'filler,internal,algorithm:patience,indent-heuristic,closeoff,iwhite'

-- whitespace
vim.o.listchars = 'tab:⇥ ,eol:$,trail:·,extends:>,precedes:<'
vim.o.fillchars = 'vert:│'

-- clean-up messages
vim.o.showmode = false
vim.opt.shortmess:append 'c'

vim.opt.viewoptions:remove 'curdir'

-- folds
vim.opt.foldopen:append 'insert,jump'

-- tabs & indents
vim.o.expandtab = true -- spaces over tabs
vim.o.tabstop = 4
vim.osofttabstop = 4
vim.o.softtabstop = 4

-- searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- grep
vim.o.grepprg = 'rg --vimgrep'
vim.opt.grepformat:prepend '%f:%l:%c:%m'

-- leader
vim.o.timeoutlen = 500
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
