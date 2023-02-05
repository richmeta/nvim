local file = require("user.file")
local util = require("user.util")

-- Vgrep = '^\s*".*<args>.*=' luadir
vim.api.nvim_create_user_command(
    'Vgrep',
    function(opts)
        local myvimrc_dir = file.dirname(vim.fn.resolve(util.expand('$MYVIMRC')))
        local arg = opts.args:gsub('\\', '\\\\')    -- need double delimited for leader mappings
        local cmd = string.format("silent grep! '^\\s*--.*%s' %s", arg, myvimrc_dir)
        util.execute(cmd)
        util.execute("cwindow")
    end,
    { nargs = 1 }
)

-- Ngrep = search commands wiki
vim.api.nvim_create_user_command(
    'Ngrep',
    function(opts)
        local cmd = string.format("silent grep! %s %s", opts.args, vim.g.sync_commands_dir)
        util.execute(cmd)
        util.execute("cwindow")
    end,
    { nargs = 1 }
)

local nopen_complete_func = nil
local ok, scan = pcall(require, "plenary.scandir")
if ok then
    nopen_complete_func = function(arglead)
        local pat = "^" .. arglead
        local ret = {}
        local found = scan.scan_dir(vim.g.sync_commands_dir, { search_pattern = arglead })

        -- further match on filename only
        for i, v in ipairs(found) do
            local filename = file.filename(v)
            if filename:match(pat) then
                table.insert(ret, filename)
            end
        end
        return ret
    end
end


vim.api.nvim_create_user_command(
    'Nopen',
    function(opts)
        local filename = opts.args
        local path = file.join(vim.g.sync_commands_dir, vim.fn.trim(filename))

        if not path:match(".wiki$") then
            local altpath = path .. ".wiki"
            if file.exists(altpath) then
                path = altpath
            end
        end

        if opts.bang then
            util.execute('edit ' .. path)
        else
            util.execute('tabedit ' .. path)
        end
    end,
    { 
        nargs = 1, 
        bang = true,
        complete = nopen_complete_func
    }
)
