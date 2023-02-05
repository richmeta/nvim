local M = {}

local clip = vim.g.clip

function M.copy(what)
    if clip == nil then
        vim.fn.setreg("+", what)
    else
        -- vim.fn.system(clip, util.expand("%:p:h"))    -- TODO: not sure if we need full path here? test on other OS
        vim.fn.system(clip, what)
    end
end


return M

