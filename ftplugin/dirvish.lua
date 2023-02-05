local mp = require("user.map")
local util = require("user.util")
local file = require("user.file")
local buffer = require("user.buffer")
local telescope = require('telescope.builtin')

local silent = {silent = true}

local function cfile()
    return util.expand("<cfile>")
end

local function dir()
    return util.expand("%")
end

mp.nnoremap_b("<Esc>", "<Plug>(dirvish_quit)")

-- wd = cd (dirvish)
mp.nnoremap_b("<Leader>wd", 
    function() 
        util.execute('cd ', util.expand('%:h'))
        util.execute('pwd')
    end)

-- \pd = print directory name
mp.nmap_b("<leader>pd",
    function()
        vim.notify(dir(), vim.log.levels.INFO)
    end)

-- md = mkdir (dirvish)
mp.nmap_b("md", [[:!mkdir %/]])

-- rd = rmdir (dirvish)
mp.nmap_b("rd", 
    function()
        local cmd = "!rmdir " .. cfile()
        util.execute(cmd)
    end)

-- helpers for cp / mv
-- TODO: how to do commands from lua
-- command! -buffer -nargs=1 -complete=file Cp :!cp "<cfile>"<space><args>
-- command! -buffer -nargs=1 -complete=file Mv :!mv "<cfile>"<space><args>

-- TODO: use plenary? Path:copy
-- cp = copy file under cursor (dirvish)
-- mp.nmap <buffer> cp :Cp<space>%/

-- mv = move file under cursor (dirvish)
-- mp.nmap <buffer> mv :Mv<space>%/

-- cw = rename file
mp.nmap_b("cw", 
    function() 
        file.prompt_rename(cfile()) 
    end)
mp.nmap("rn", "cw")

-- rm = delete file under cursor (dirvish)
-- TODO: not working - 
-- mp.nmap_b("rm", [[:!rm -i "<cfile>" <cr>]])
mp.nmap_b("rm", 
    function()
        local cmd = string.format('!rm -i "%s"', cfile())
        util.execute(cmd)
    end)
mp.nmap_b("<Leader>rm", "rm")

-- ne = new file
mp.nmap_b("ne", [[:e %/]])

-- v = vertical split (dirvish)
mp.nmap_b("v", "a")

-- s = horiz split (dirvish)
mp.nmap_b("s", "o")

-- ctrl-t = open in tab (dirvish)
mp.nmap_b("<C-T>", "t")

-- open file under cursor in new tab (dirvish)
mp.nnoremap_b("t", ":call dirvish#open('tabedit', 0)<cr>", silent)
mp.xnoremap_b("t", ":call dirvish#open('tabedit', 0)<cr>", silent)

-- open file under cursor (no split)
mp.nmap_b("<cr>",
    function()
        vim.cmd('call dirvish#open("edit", 0)')
        vim.notify(dir(), vim.log.levels.INFO)
    end, {nowait=true, silent=true})

-- r-click = preview
mp.nmap_b("<RightMouse>", "p")

-- h = up dir (dirvish) [like vifm]
mp.nmap_b("h", "<Plug>(dirvish_up)", silent)

-- l = open (dirvish) [like vifm]
mp.nmap_b("l",
    function()
        vim.cmd('call dirvish#open("edit", 0)')
        vim.notify(dir(), vim.log.levels.INFO)
    end, silent)

-- copypath
mp.nmap_b("<Leader>cd", function() file.clip({typ = "dir"}) end, silent)         -- directory
mp.nmap_b("<Leader>cf", function() file.clip({typ = "full"}) end, silent)        -- full path
mp.nmap_b("<Leader>cv", function() file.clip({typ = "filename"}) end, silent)    -- filename only
mp.nmap_b("<Leader>cs", function() file.clip({typ = "stem"}) end, silent)        -- stem only
