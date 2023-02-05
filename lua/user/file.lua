local M = {}
local util = require("user.util")
local buffer = require("user.buffer")

function M.expand_expr(typ)
    -- returns the expand equiv of `typ`
    -- where typ in 'dir', 'directory', 'filename', 'full', 'fullpath', 'stem'
    if typ == "dir" or typ == "directory" then
        return ":~:h"   -- like :p:h but expands with home dir
    elseif typ == "filename" then
        return ":t"
    elseif typ == "full" or typ == "fullpath" then
        return ":p"
    elseif typ == "stem" then
        return ":t:r"
    elseif typ == "current" then
        return ""
    end

    error("unknown value for `typ` : " .. typ)
end

function M.expand(fn, typ) 
    return vim.fn.fnamemodify(fn, M.expand_expr(typ))
end

function M.dir(fn)
    return M.expand(fn, "dir")
end

function M.filename(fn)
    return M.expand(fn, "filename")
end

function M.full(fn)
    return M.expand(fn, "full")
end

function M.stem(fn)
    return M.expand(fn, "stem")
end

function M.prompt_rename(source)
    -- local newfilename = vim.fn.input('new filename: ', source)
    vim.fn.input({ prompt = 'new filename: ', default = source},
        function(value)
            if value and value ~= source then
                local cmd = string.format('!mv "%s" "%s"', source, newfilename)
                util.execute(cmd)
            end
        end
    )
end

local ok, Path = pcall(require, "plenary.path")
if not ok then
    return M
end

function M.path_equal(a, b)
    local p1 = tostring(Path:new(a))
    local p2 = tostring(Path:new(b))
    res = (p1 == p2)
    return res
end

function M.dirname(filename)
    local p1 = Path:new(filename)
    return p1:parent()
end

function M.join(head, ...)
    local p1 = Path:new(head)
    local p2 = p1:joinpath(...)
    return tostring(p2)
end

function M.exists(filename)
    local p1 = Path:new(util.expand(filename))  -- expand ~ or %:p patterns
    return p1:exists()
end

function M.clip(opts)
    -- opts = { 
    --     path = optional, use expand or typ
    --     expand = pattern to expand into path
    --     typ = expand by type (dir, full, filename, stem),
    --     populates expand",
    --     showmsg = false (default) 
    -- }
    local path = opts.path
    if not path then
        local expand = opts.expand
        if opts.typ then
            expand = buffer.expand(opts.typ)
        end
        if not expand then
            error("expecting `expand` or `typ` option when `path` is omitted")
        end
        path = tostring(Path:new(util.expand(expand)))   -- fullpath
    end

    local clip = vim.g.clip
    if clip == nil then
        vim.fn.setreg("+", path)
    else
        -- vim.fn.system(clip, util.expand("%:p:h"))    -- TODO: not sure if we need full path here? test on other OS
        vim.fn.system(clip, path)
    end

    -- also place result in reg f
    vim.fn.setreg("f", path)
    if opts.showmsg then
        vim.notify("copied", vim.log.levels.INFO)
    end
end


return M
