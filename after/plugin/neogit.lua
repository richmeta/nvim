local Path = require("plenary.path")
local util = require("user.util")
local buffer = require("user.buffer")
local clipboard = require("user.clip")
local git = require("user.git")
local mp = require("user.map")

local function not_git()
    vim.notify("Not a git dir", vim.log.levels.INFO)
end

-- \wg = change working directory to git root
mp.nnoremap("<Leader>wg", function()
    local gitdir = git.root()

    if gitdir then
        util.execute('cd ' .. gitdir)
        util.execute('pwd')
    else
        not_git()
    end
end)

-- \cb = copy git branch name
mp.nnoremap("<Leader>cb", function()
    git.status_refresh(function(status)
        local head = status.repo.head.branch
        clipboard.copy(head)
    end)
end)

-- \cg = copy git path relative
mp.nnoremap("<Leader>cg", function()
    local gitcli = require("neogit.lib.git.cli")
    local gitdir = gitcli.git_root()

    if gitdir then
        local p1 = Path:new(buffer.full())
        p1:make_relative(gitdir)
        clipboard.copy(tostring(p1))
    else
        not_git()
    end
end)



