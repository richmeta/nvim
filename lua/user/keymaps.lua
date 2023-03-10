local mp = require("user.map")
local util = require("user.util")
local file = require("user.file")
local buffer = require("user.buffer")
local os = require("user.os")

-- local setup
local silent = { silent = true }
local noremap = mp.noremap
local cnoremap = mp.cnoremap
local inoremap = mp.inoremap
local nnoremap = mp.nnoremap
local onoremap = mp.onoremap
local snoremap = mp.snoremap
local tnoremap = mp.tnoremap
local vnoremap = mp.vnoremap
local xnoremap = mp.xnoremap
local map = mp.map
local cmap = mp.cmap
local imap = mp.imap
local nmap = mp.nmap
local tmap = mp.tmap

-- is X os executable
local executable = vim.fn.executable

--
-- MAPPINGS
--

-- ctrl-c = clipboard copy
vnoremap("<C-C>", [["+y]])

-- ctrl-x = clipboard cut
vnoremap("<C-X>", [["+x]])

-- ctrl-v = clipboard paste
map("<C-V>", [["+gP]])
cmap("<C-V>", "<C-R>+")

-- Use CTRL-Q to do what CTRL-V used to do
-- ctrl-q = blockwise visual select
noremap("<C-Q>", "<C-V>")

if os.is_unix then
    -- TODO: what happens on windows ( is it automatic ? )
    local paste_i = "<C-g>u" .. vim.g["paste#paste_cmd"]["i"]
    local paste_v = vim.g["paste#paste_cmd"]["v"]
    inoremap("<C-V>", paste_i, { script = true })
    vnoremap("<C-V>", paste_v, { script = true })
end

-- Use CTRL-S for saving, also in Insert mode (<C-O> doesn't work well when using completions).
-- ctrl-s = save
noremap("<C-S>", ":update<CR>")
vnoremap("<C-S>", "<C-C>:update<CR>")
inoremap("<C-S>", "<Esc>:update<CR>gi")

-- ctrl-a = select all
noremap("<C-A>", "gggH<C-O>G")
onoremap("<C-A>", "<C-C>gggH<C-O>G")
snoremap("<C-A>", "<C-C>gggH<C-O>G")
xnoremap("<C-A>", "<C-C>ggVG")

-- \t = new tab
nnoremap("<Leader>t", ":tabnew<cr>")

-- \T = new scratch
nnoremap("<Leader>T", ":tabnew<bar>setlocal buftype=nofile<cr>")

-- alt-x = tabclose
nnoremap("<m-x>", ":tabclose<cr>")

-- \O = only this tab
nnoremap("<Leader>O", ":tabonly<cr>")

-- \o = tabedit file
nnoremap("<Leader>o", ":tabedit<space>")

-- \wn = split window search cword
nnoremap("<Leader>wn", ":let @/=expand('<cword>')<bar>split<bar>normal n<cr>")

-- \wN = split window search cword + boundary
nnoremap("<Leader>wN", [[:let @/='\<'.expand('<cword>').'\>'<bar>split<bar>normal n<cr>]])

-- \xf = format xml
if executable("xml_pp") then
    -- xml_pp = xml pretty print from XML::Twig
    nnoremap("<Leader>xf", ":silent %!xml_pp - <cr>")
    vnoremap("<Leader>xf", ":!xml_pp - <cr>")
end

-- \hf = format html
if executable("html_pp") then
    -- html_pp = html pretty print using Beautiful Soup
    nnoremap("<Leader>hf", ":silent %!html_pp - <cr>")
    vnoremap("<Leader>hf", ":!html_pp - <cr>")
end

if executable("python3") then
    -- \jf = format json
    nnoremap(
        "<Leader>jf",
        ":silent %!python3 -c 'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),sort_keys=False,indent=4))' - <cr><cr>:setf json<cr>"
    )
    vnoremap(
        "<Leader>jf",
        ":!python3 -c 'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),sort_keys=False,indent=4))' - <cr><cr>"
    )

    -- \pf = format pprint
    nnoremap(
        "<Leader>pf",
        ":silent %!python3 -c 'import sys, pprint; pprint.PrettyPrinter(indent=2, compact=True).pprint(eval(sys.stdin.read()))' - <cr><cr>"
    )
    vnoremap(
        "<Leader>pf",
        ":!python3 -c 'import sys, pprint; pprint.PrettyPrinter(indent=2).pprint(eval(sys.stdin.read()))' - <cr><cr>"
    )
end

if executable("base64") then
    -- \bf = format base64
    vnoremap("<Leader>bf", [[y:let @"=system('base64 -d', @")<cr>gvP]])
end

if executable("erlfmtx") then
    -- \ef = format with erlfmt
    nnoremap("<Leader>ef", ":silent %!erlfmtx --print-width 120 - <cr><cr>")
    vnoremap("<Leader>ef", ":!erlfmtx --print-width 120 - <cr><cr>")
elseif executable("erlfmt") then
    -- fallback
    nnoremap("<Leader>ef", ":silent %!erlfmt --print-width 120 - <cr><cr>")
    vnoremap("<Leader>ef", ":!erlfmt --print-width 120 - <cr><cr>")
end

-- shift-F1 - help current word
-- <S-F1> == F13
nnoremap("<F13>", function()
    local cmd = "help " .. util.expand("<cword>")
    util.execute(cmd)
end)

vnoremap("<F13>", [[:<C-U>execute 'help '.getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-2]<cr>]])

-- \ye = copy EOL into clipboard
nnoremap("<Leader>ye", '"+y$')

-- \yy = copy whole line into clipboard
nnoremap("<Leader>yy", 'm`^"+y$``')

-- alt-v = select whole line excl newline
nnoremap("<m-v>", "^vg_")

-- \yp = copy inner paragraph into clipboard
nnoremap("<Leader>yp", '"+yip')

-- \y = copy into clipboard
vnoremap("<Leader>y", '"+y')

-- \lf = Location open
noremap("<Leader>lf", ":lopen<cr>")

-- \lc = Location close
noremap("<Leader>lc", ":lclose<cr>")

-- \dw = remove trailing whitespace
nnoremap("<Leader>dw", [[:%s/\s\+$//g<cr>``]])
vnoremap("<Leader>dw", [[:s/\s\+$//g<cr>``]])

-- \- = ruler
nnoremap("<Leader>-", "o<Esc>80a-<Esc>")

-- \= ruler
nnoremap("<Leader>=", "o<Esc>80a=<Esc>")

-- \h = new horizontal split
nnoremap("<Leader>h", ":new<cr>")

-- \rm = Remove file + confirm
nnoremap("<Leader>rm", ':!rm -i "%"<cr>')

-- \pw = Pwd
nnoremap("<Leader>pw", ":pwd<cr>")

-- \pb = print directory of current buffer
nnoremap("<Leader>pb", ':echo expand("%:h")<cr>')

-- \wd = set working dir to buffer
nnoremap("<Leader>wd", function()
    util.execute("cd ", buffer.dir())
    util.execute("pwd")
end)

-- \ss - save all
nnoremap("<Leader>ss", ":wa<cr>")

-- \us = Unique sort whole file
nnoremap("<Leader>us", ":%!sort -u<cr>")
vnoremap("<Leader>us", ":!sort -u<cr>")

-- \vs = Visual sort
vnoremap("<Leader>vs", ":sort<cr>")

-- \vrc - open vimrc
nnoremap("<Leader>vrc", function()
    local fn = os.nvim_config_dir .. "/lua/user/init.lua"
    vim.cmd.tabedit(fn)
end)

-- \vso = reload vimrc manually
nnoremap("<Leader>vso", function()
    for name, _ in pairs(package.loaded) do
        if name:match("^user") and not name:match("nvim-tree") then
            package.loaded[name] = nil
        end
    end

    -- reloads init.lua
    vim.api.nvim_command(":luafile ~/.config/nvim/init.lua")
    vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end)

-- \db = toggle show debug
nnoremap("<leader>db", function()
    vim.g.show_debug = not vim.g.show_debug
end)

-- \sb = shebang for bash
nnoremap("<Leader>sb", ":normal 1GO<esc>I#!/usr/bin/env bash<cr><esc>")

-- \ms = messages
nnoremap("<Leader>ms", ":messages<cr>")

-- \mc = messages clear
nnoremap("<Leader>mc", ":messages clear<cr>")

-- \sc = scratch buffer
nnoremap("<Leader>sc", ":setlocal buftype=nofile<cr>")

-- operator i/ and a/ around slashes
onoremap("i/", ":<C-U>normal! T/vt/<cr>", silent)
onoremap("a/", ":<C-U>normal! F/vf/<cr>", silent)
xnoremap("i/", ":<C-U>normal! T/vt/<cr>", silent)
xnoremap("a/", ":<C-U>normal! F/vf/<cr>", silent)

-- ctrl-a = emacs begin of line (commandmode)
cnoremap("<C-A>", "<Home>")

-- ctrl-e = emacs begin of line (commandmode)
cnoremap("<C-E>", "<End>")

-- ctrl-k = emacs delete to eol (commandmode)
cnoremap("<c-k>", "<C-\\>estrpart(getcmdline(),0,getcmdpos()-1)<cr>")

-- ctrl-e = eol (ins)
imap("<c-e>", "<c-o>$")

-- ctrl-a = home (ins)
imap("<c-a>", "<c-o>^")

-- w!! = sudo write
cnoremap("w!!", "w !sudo tee > /dev/null %")

-- Y = yank to EOL
nmap("Y", "y$")

-- forward/back to space
nmap("gw", "f<space>")
nmap("gb", "F<space>")

-- Ctrl-E/Ctrl-Y scroll up/down
nmap("<C-up>", "<C-y>")
imap("<C-up>", "<C-o><C-y>")
nmap("<C-down>", "<C-e>")
imap("<C-down>", "<C-o><C-e>")

-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
-- so that you can undo CTRL-U after inserting a line break.
inoremap("<C-U>", "<C-G>u<C-U>")

-- Next/Previous file
-- ctrl-n = next file
-- ctrl-p = prev file
nnoremap("<c-n>", util.ex("next"))
nnoremap("<c-p>", util.ex("prev"))

-- Buffer switching
nmap("L", util.ex("bn"))
nmap("H", util.ex("bp"))

-- Buffer delete
-- Q = delete buffer unless modified
nmap("Q", util.ex("bd"), silent)

-- alt-q = delete buffer unconditionally
nmap("<M-q>", util.ex("bd!"), silent)

-- ctrl-alt-q = delete buffer unconditionally + close tab
nmap("<C-M-q>", util.ex({ ":bd!", "tabclose" }), silent)

-- ctrl-bs (ins) = delete word back
imap("<C-BS>", "<C-O>diw")

-- alt-p (ins) put from " register
-- alt-P (ins) PUT from " register
inoremap("<m-p>", '<C-R><C-R>"')
inoremap("<m-P>", '<C-O>h<C-R><C-R>"')

-- alt-p (cmd) put from " register
cnoremap("<m-p>", '<C-R><C-R>"')

-- Window switching

-- ctrl-k = move to window
-- ctrl-j = move to window
-- ctrl-h = move to window
-- ctrl-l = move to window
nmap("<c-k>", util.ex("wincmd k"), silent)
nmap("<c-j>", util.ex("wincmd j"), silent)
nmap("<c-h>", util.ex("wincmd h"), silent)
nmap("<c-l>", util.ex("wincmd l"), silent)

-- copypath
-- \cd = copy directory/path (and "f)
-- \cf = copy fullpath (and "f)
-- \cv = copy filename only (and "f)
-- \cs = copy stem (and "f)
nmap("<Leader>cd", function()
    file.clip({ typ = "dir" }, 1)
end, silent) -- directory
nmap("<Leader>cf", function()
    file.clip({ typ = "full" }, 1)
end, silent) -- full path
nmap("<Leader>cv", function()
    file.clip({ typ = "filename" }, 1)
end, silent) -- filename only
nmap("<Leader>cs", function()
    file.clip({ typ = "stem" }, 1)
end, silent) -- stem only

-- <ctrl-c><ctrl-d> (ins) = insert directory/path
-- <ctrl-c><ctrl-f> (ins) = insert fullpath
-- <ctrl-c><ctrl-v> (ins) = insert filename only
-- <ctrl-c><ctrl-s> (ins) = insert stem
imap("<C-C><C-D>", function()
    util.insert_text(buffer.dir())
end, silent)
imap("<C-C><C-F>", function()
    util.insert_text(buffer.full())
end, silent)
imap("<C-C><C-V>", function()
    util.insert_text(buffer.filename())
end, silent)
imap("<C-C><C-S>", function()
    util.insert_text(buffer.stem())
end, silent)

-- Ctrl-\ = (terminal) exit insertmode
-- <esc> interferes with terminal
tnoremap("<C-\\>", [[<C-\><C-n>]])

-- prevent Ctrl-S freeze
tmap("<C-S>", "<Nop>")

-- \mt = open terminal at this dir
map("<Leader>mt", [[:let $VIM_DIR=expand('%:p:h')<cr>:terminal<cr>cd $VIM_DIR<cr>]])

-- \dt = diffthis
map("<Leader>dt", [[:if &diff <bar> diffoff <bar> else <bar> diffthis <bar>endif<cr>]])

-- TODO -
-- instead of these maps
-- setup a Command to set the various grep options
--    GrepRegexMode -  toggle regex mode
--    GrepBoundary  -  toggle boundary
--    GrepGlob      -  set glob

--    Grep grep prompt dir

-- \gW = toggle word boundary grep
-- grep runs from `after/plugin/telescope.lua`
nnoremap("<leader>gW", function()
    vim.g.grep_word_boundary = not vim.g.grep_word_boundary
    vim.notify(tostring(vim.g.grep_word_boundary), vim.log.levels.INFO)
end)

-- \gT = toggle filetype on/off
nnoremap("<leader>gT", function()
    if vim.g.grep_filetype == "" then
        local ft = vim.o.filetype
        if ft and #ft > 0 then
            vim.g.grep_filetype = ft
            vim.notify(vim.g.grep_filetype, vim.log.levels.INFO)
        end
    else
        vim.g.grep_filetype = ""
        vim.notify("off", vim.log.levels.INFO)
    end
end)

-- \gG = set grep glob
nnoremap("<leader>gG", function()
    vim.ui.input({ prompt = "glob: ", completion = "file", default = "**/*." }, function(value)
        -- use <esc> or blank to reset
        if value then
            vim.g.grep_glob = value
            vim.notify(vim.g.grep_glob, vim.log.levels.INFO)
        else
            vim.g.grep_glob = ""
            vim.notify("off", vim.log.levels.INFO)
        end
    end)
end)

--
-- map toggles
--

-- F2 = toggle spell
mp.toggle("<F2>", "spell")

-- \ws = toggle wrapscan
mp.toggle("<Leader>ws", "wrapscan")

-- F6 = syntax on/off
-- map <F6> :if exists("syntax_on") <bar> syntax off <bar> else <bar> syntax enable <bar> endif <cr>
nnoremap("<F6>", function()
    local exists = vim.fn.exists("syntax_on")
    if exists == 1 then
        util.execute("syntax off")
    else
        util.execute("syntax enable")
    end
end)

-- F7 = toggle hlsearch
mp.toggle("<F7>", "hlsearch")

-- F8 = toggle wrap
mp.toggle("<F8>", "wrap")

-- F9 = toggle list
mp.toggle("<F9>", "list")

-- shift-F8 = toggle number
-- F20 - S-F8
mp.toggle("<F20>", "number")

-- shift-F9 = toggle relativenumber
-- F21 - S-F9
mp.toggle("<F21>", "relativenumber")

-- F10 = toggle scrollbind
mp.toggle("<F10>", "scrollbind")

-- F11 = toggle ignorecase
mp.toggle("<F11>", "ignorecase")

-- F12 = toggle quickfix
nnoremap("<F12>", function()
    local ids = vim.fn.getqflist({ winid = 1 })
    if ids.winid ~= 0 then
        vim.cmd.cclose()
    else
        vim.cmd(":botright copen")
    end
end)

-- \ps = toggle paste
mp.toggle("<Leader>ps", "paste")

-- \cc = toggle cursorcolumn
mp.toggle("<Leader>cc", "cursorcolumn")

-- \sr = toggle splitright
-- TODO: find new mapping with snippet-reload
-- mp.toggle("<Leader>sr", "splitright")

-- \sl = toggle selection (exclusive/inclusive)
mp.toggle("<Leader>sl", { setting = "selection", choices = { "inclusive", "exclusive" } })

-- \ar = toggle autoread
mp.toggle("<Leader>ar", "autoread")

-- \kd = toggle '.' in `iskeyword`
-- or vim.b.lang_dot to override
mp.toggle("<Leader>kd", {
    setting = "iskeyword",
    choices = function()
        local dot = vim.b.lang_dot or "."
        return { dot, "" }
    end,
})

nnoremap("<Leader><C-]>", function()
    local word = util.expand("<cWORD>")
    util.execute("tab tjump " .. word)
end, silent)

nnoremap("<m-1>", "1gt")
nnoremap("<m-2>", "2gt")
nnoremap("<m-3>", "3gt")
nnoremap("<m-4>", "4gt")
nnoremap("<m-5>", "5gt")
nnoremap("<m-6>", "6gt")
nnoremap("<m-7>", "7gt")
nnoremap("<m-8>", "8gt")
nnoremap("<m-9>", "9gt")
