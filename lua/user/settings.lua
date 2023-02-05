local os = require("user.os")
local file = require("user.file")

local cmd = vim.cmd     -- run vim script
local A   = vim.api     -- nvim api
local g   = vim.g       -- g: variables
local b   = vim.b       -- b: variables
local o   = vim.o       -- set: options

local opt = vim.opt     -- lua api for options, lists etc

-- vim.opt.thing:append { "*.pyc" } -- same as +=
-- vim.opt.thing:prepend            -- same as ^=
-- vim.opt.thing:remove             -- same as -=

o.hidden = true
o.backup = false
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.wrap = false
o.visualbell = false
o.errorbells = false
o.expandtab = true
o.ignorecase = true
o.smartcase = true
o.hlsearch = false
o.autowrite = true
o.modelines = 5
o.backspace="indent,eol,start"
o.background = dark
o.history = 10000
o.ruler = true
o.incsearch = true
o.autoindent = true
o.smartindent = true
o.smarttab = true
o.report = 0
o.whichwrap = "b,s,h,l,<,>,~,[,]"
o.startofline = false
o.sidescroll = 5
o.sidescrolloff = 10
o.scrolloff = 2
o.statusline = '%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]'
o.winminheight = 0
o.shiftround = true
o.showcmd = true
opt.matchpairs:append("<:>")
opt.iskeyword:append("-")
o.wildmenu = true
opt.wildignore:append { "*.sw*", "*.pyc", "node_modules", "tags", "__pycache__", ".DS_Store", ".git" }
o.shellslash = true
o.laststatus = 2
o.keymodel = "startsel"
opt.listchars = {
    tab = "→ ",
    trail = "␣",
    extends = "❯",
    precedes = "❮",
    nbsp = "⍽",
    conceal = "~",
    eol = "$" 
}
o.splitbelow = true
o.joinspaces = false
o.shada = "!,'1000,<50,s20,h"
o.tags = "./tags,tags;"
o.shortmess = o.shortmess .. "I"        -- no intro message
o.showmatch = true
o.matchtime = 1
o.isfname = o.isfname .. ",32"          -- allow space in filenames
o.tabpagemax = 50
o.tagbsearch = true
o.fixendofline = false
o.mouse = "a"
o.selection = "inclusive"
if file.join then
    o.dictionary = file.join(os.nvim_config_dir, "dict/dict.txt")
end
o.pastetoggle = "<Leader>ps"
opt.diffopt:append("algorithm:patience")

if vim.fn.executable('rg') then
    o.grepprg = "rg --vimgrep --no-heading"
end

-- aliases under terminal
vim.env.BASH_ENV = '~/.bash_aliases'

vim.cmd("filetype plugin on")
vim.cmd("filetype plugin indent on")
