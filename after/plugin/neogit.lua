local Path = require("plenary.path")
local a = require("plenary.async")
local util = require("user.util")
local buffer = require("user.buffer")
local clipboard = require("user.clip")
local mp = require("user.map")

local function not_git()
    vim.notify("Not a git dir", vim.log.levels.INFO)
end

-- \wg = change working directory to git root
mp.nnoremap("<Leader>wg", function()
    local gitcli = require("neogit.lib.git.cli")
    local gitdir = gitcli.git_root()

    if gitdir then
        util.execute('cd ' .. gitdir)
        util.execute('pwd')
    else
        not_git()
    end
end)

-- \cb = copy git branch name
mp.nnoremap("<Leader>cb", function()
    local status = require("neogit.status")

    a.run(status.refresh, function()
        local head = status.repo.head.branch
        clipboard.copy(head)
    end)
end)

-- \cg = copy git path relative
mp.nnoremap("<Leader>cg", function()
    local gitcli = require("neogit.lib.git.cli")
    local gitdir = gitcli.git_root()

    util.debug("gitdir = ", gitdir)
    if gitdir then
        local p1 = Path:new(buffer.full())
        p1:make_relative(gitdir)
        clipboard.copy(tostring(p1))
    else
        not_git()
    end
end)



