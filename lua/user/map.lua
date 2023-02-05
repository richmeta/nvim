
local M = {}

local function bind(op, outer_opts)
    -- outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts or {},
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local noremap = {noremap = true}
local nvo = {"n", "v", "o"}

M.noremap = bind(nvo, noremap)
M.cnoremap = bind("c", noremap)
M.inoremap = bind("i", noremap)
M.lnoremap = bind("l", noremap)
M.nnoremap = bind("n", noremap)
M.onoremap = bind("o", noremap)
M.snoremap = bind("s", noremap)
M.tnoremap = bind("t", noremap)
M.vnoremap = bind("v", noremap)
M.xnoremap = bind("x", noremap)
M.map = bind(nvo)
M.cmap = bind("c")
M.imap = bind("i")
M.lmap = bind("l")
M.nmap = bind("n")
M.omap = bind("o")
M.smap = bind("s")
M.tmap = bind("t")
M.vmap = bind("v")
M.xmap = bind("x")



-- buffer maps 
-- add as appropriate
local buffer = { buffer = true }
local buffer_noremap = {noremap = true, buffer = true}
M.nnoremap_b = bind("n", buffer_noremap)
M.xnoremap_b = bind("x", buffer_noremap)
M.nmap_b = bind("n", buffer)

-- get termcode
-- TODO: not sure if required
-- function M.t(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

function M.toggle(mapping, arg) 
    -- create a normal mapping to
    -- toggle a setting over list of available values
    --
    -- arg 
    --   string : bool option
    --   table : 
    --   {
    --       'setting' - string : name of setting - if boolean on/off
    --       'choices' - table  : array of choices to cycle over
    --   }
    local opts
    if type(arg) == "string" then
        -- bool setting
        opts = { setting = arg }
    else
        -- table
        opts = arg
    end

    local setting = opts.setting
    local info = vim.api.nvim_get_option_info(setting)
    if (info.type == "boolean") then
        opts.choices = {true, false}
    end

    if not opts.choices then
        error(string.format("choices required for %s (%s)", setting, info.type))
    end

    M.nnoremap(mapping,
        function()
            current = vim.opt[setting]:get()
            for i, v in ipairs(opts.choices) do
                if v == current then
                    _, next_value = next(opts.choices, i)
                    if next_value == nil then
                        next_value = opts.choices[1]
                    end
                    vim.opt[setting] = next_value
                    vim.notify(string.format("%s=%s", setting, next_value), vim.log.levels.INFO)
                    break
                end
            end
        end)
end

return M
