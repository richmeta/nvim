local M = {}

local function bind(op, outer_opts)
    -- outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts or {}, opts or {})
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
M.tmap_b = bind("t", buffer)

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
                found = found[1]

                -- find the next item, remove current and add next
                for i, v in ipairs(choices) do
                    if v == found then
                        local _, next_value = next(choices, i)
                        if next_value == nil then
                            next_value = choices[1]
                        end
                        vim.opt[setting]:remove(found)
                        if next_value ~= "" then
                            vim.opt[setting]:append(next_value)
                        end
                    end
                end
            else
                -- nothing found, assume first
                vim.opt[setting]:append(choices[1])
            end
            vim.notify(string.format("%s=%s", setting, vim.o[setting]), vim.log.levels.INFO)
        elseif type(current) ~= "table" then        -- exclude map types
            -- single setting
            for i, v in ipairs(choices) do
                if v == current then
                    local _, next_value = next(choices, i)
                    if next_value == nil then
                        next_value = choices[1]
                    end
                    vim.opt[setting] = next_value
                    vim.notify(string.format("%s=%s", setting, next_value), vim.log.levels.INFO)
                    break
                end
            end
        end
    end, opts.map_opts)
end

return M
