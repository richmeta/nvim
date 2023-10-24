local M = {}

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
function M.toggle(arg)
    -- create a toggle function that will
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
    --                       must return either:
    --                         - a table array of possible choices
    --                         - the next value
    --
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

    local choices = type(opts.choices) == "function" and opts.choices() or opts.choices

    return function()
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
    end
end


return M
