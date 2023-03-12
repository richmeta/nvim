local M = {}
local a = require("plenary.async")

function M.root()
    local gitcli = require("neogit.lib.git.cli")
    return gitcli.git_root()
end

function M.status_refresh(callback)
    local status = require("neogit.status")

    a.run(status.refresh, callback(status))
end

return M
