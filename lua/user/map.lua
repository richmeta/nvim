local los = require("user.os")
local M = {}

local fn_mapping_term = {
    ["<S-F1>"]  = "<f13>",
    ["<S-F2>"]  = "<f14>",
    ["<S-F3>"]  = "<f15>",
    ["<S-F4>"]  = "<f16>",
    ["<S-F5>"]  = "<f17>",
    ["<S-F6>"]  = "<f18>",
    ["<S-F7>"]  = "<f19>",
    ["<S-F8>"]  = "<f20>",
    ["<S-F9>"]  = "<f21>",
    ["<S-F10>"] = "<f22>",
    ["<S-F11>"] = "<f23>",
    ["<S-F12>"] = "<f24>",
    ["<C-F1>"]  = "<f25>",
    ["<C-F2>"]  = "<f26>",
    ["<C-F3>"]  = "<f27>",
    ["<C-F4>"]  = "<f28>",
    ["<C-F5>"]  = "<f29>",
    ["<C-F6>"]  = "<f30>",
    ["<C-F7>"]  = "<f31>",
    ["<C-F8>"]  = "<f32>",
    ["<C-F9>"]  = "<f33>",
    ["<C-F10>"] = "<f34>",
    ["<C-F11>"] = "<f35>",
    ["<C-F12>"] = "<f36>",
}

-- returns the correct terminal mapping key for Ctrl/Shift Fn mappings
function M.fn_term(mapping)
    if not los.is_gui and string.match(mapping, "<[SCsc]%-[Ff]%d+>") ~= nil then
        return fn_mapping_term[mapping:upper()]
    end
    return mapping
end

local function bind(op, outer_opts)
    -- outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts or {}, opts or {})

        -- translate terminal fn keys
        if not los.is_gui and string.match(lhs, "<[SC]%-F%d+>") ~= nil then
            lhs = fn_mapping_term[lhs:upper()]
        end

        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local noremap = { noremap = true }
local nvo = { "n", "v", "o" }

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
local buffer_noremap = { noremap = true, buffer = true }
M.nnoremap_b = bind("n", buffer_noremap)
M.tnoremap_b = bind("t", buffer_noremap)
M.xnoremap_b = bind("x", buffer_noremap)
M.nmap_b = bind("n", buffer)
M.imap_b = bind("i", buffer)
M.vmap_b = bind("v", buffer)
M.tmap_b = bind("t", buffer)


local function find_next_choice(current_value, choices)
    -- precondition: value must exist in choices
    for i, v in ipairs(choices) do
        if v == current_value then
            local _, next_value = next(choices, i)
            if next_value == nil then
                next_value = choices[1]
            end
            return next_value
        end
    end

    error(string.format("Current value doesn't match choices. Add '%s' to choices '%s'.", current_value, vim.inspect(choices)))
end

-- TODO
-- support toggling on variables
--   { 'variable':  vim.g.some_variable, 'type': bool }
--      'type' could be optional, if omitted infer
-- 
-- support toggling to call function(next_value)
--  { 'callback': function(current, next)
--
-- separate toggle from creating as mapping
--   toggle - function
--   map_toggle - mapping to create the toggle
--
-- move to own module

function M.toggle(mapping, arg)
    -- create a normal mapping to
    -- toggle a setting over list of available values
    --
    -- arg : string or table
    --   string : bool option
    --   table : {
    --       'setting' : string     
    --          - name of setting - if boolean on/off
    --
    --       'choices' : table or function()
    --          - table    : an array of choices to cycle over
    --                       TODO: choice could be a function (eg diffthis)
    --                       list-style options are supported
    --                       use { ..., "" } to remove it from toggle list
    --
    --          - function : called before toggle, 
    --                       must return a table array of possible choices
    --
    --       'map_opts' : table
    --          - passed to nnoremap
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
    if info.type == "boolean" and not opts.choices then
        opts.choices = { true, false }
    end

    if not opts.choices then
        error(string.format("choices required for %s (%s)", setting, info.type))
    end

    local choices  = type(opts.choices) == "function" and opts.choices() or opts.choices

    M.nnoremap(mapping, function()
        local current = vim.opt[setting]:get()
        if vim.tbl_islist(current) then
            -- list-style settings

            -- find the current item from choices
            local found = vim.tbl_filter(function(item)
                for _, v in ipairs(choices) do
                    if v == item then
                        return true
                    end
                end
            end, current)

            if #found > 1 then
                -- something else might have set the setting
                vim.notify(
                    string.format(
                        "multiple choices found (%s) in toggle list for setting %s",
                        table.concat(found, ", "),
                        setting
                    ),
                    vim.log.levels.ERROR
                )
                return
            elseif #found == 1 then
                -- find the next item, remove current and add next
                local next_value = find_next_choice(found[1], choices)
                vim.opt[setting]:remove(found[1])
                if next_value ~= "" then
                    vim.opt[setting]:append(next_value)
                end
            else
                -- nothing found, assume first
                vim.opt[setting]:append(choices[1])
            end
            vim.notify(string.format("%s=%s", setting, vim.o[setting]), vim.log.levels.INFO)
        elseif type(current) ~= "table" then        -- map types not supported
            -- single setting
            local next_value = find_next_choice(current, choices)
            vim.opt[setting] = next_value
            vim.notify(string.format("%s=%s", setting, next_value), vim.log.levels.INFO)
        end
    end, opts.map_opts)
end

return M
