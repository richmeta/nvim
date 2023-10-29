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
--   { 'source': X, 
--     where X is a setting
--                  function
--                  variable
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
    --   string : effectively { "setting": <value> }
    --   table : {
    --       'setting' : toggle on this vim setting
    --          - string  : name of setting
    --          - table   : Option type returned from vim.opt[name]
    -- 
    --       'source' : toggle on any other type, ignored if 'setting' present
    --          - any: the current value
    --          - function: return the current value, in this case 'callback' is required
    --
    --       'choices' : table or function()
    --          - table    : an array of choices to cycle over, if omitted defaults = {true, false}
    --                       list-style options are supported
    --                       set the last element as "" to remove it from toggle list
    --
    --          - function : called before toggle, 
    --                       must return a table array of possible choices
    --
    --       'handler'    : function(current_value)
    --                       returns either the next value
    --                       or nil, which makes no change
    --
    --       'callback'   : function(next_value)
    --                       if set, call this function with the next value
    --                       required if 'source' is a function
    --
    --   }
    local opts
    if type(arg) == "string" then
        opts = { setting = arg }
    elseif type(arg) == "table" then
        if arg._name then -- from vim.opt
            opts = { setting = arg._name }
        else
            if type(arg.source) == "function" and arg.callback == nil then
                error("'callback' required with function based sources")
            end
            opts = arg
        end
    else
        error("wrong argument type to toggler. expecting string or table")
    end

    if not opts.choices then
        opts.choices = { true, false }
    end

    local function set_next(next_value)
        if type(opts.source) == "function" then
            opts.callback(next_value)
        elseif opts.setting then
            vim.opt[opts.setting] = next_value
            vim.notify(string.format("%s=%s", opts.setting, next_value), vim.log.levels.INFO)
        else
            opts.source = next_value
        end
    end

    local function set_list_next(next_value, old_value)
        if old_value then
            vim.opt[opts.setting]:remove(old_value)
        end
        if next_value ~= "" then
            vim.opt[opts.setting]:append(next_value)
        end
    end

    return function()
        local current
        if opts.setting then
            current = vim.opt[opts.setting]:get()
        elseif type(opts.source) == "function" then
            current = opts.source()
        else
            current = opts.source
        end

        if opts.handler then
            local next_value = opts.handler(current)
            if next_value ~= nil then
                set_next(next_value)
                -- if opts.setting then
                --     vim.opt[opts.setting] = next_value
                --     vim.notify(string.format("%s=%s", opts.setting, next_value), vim.log.levels.INFO)
                -- elseif type(opts.source) == "function" then
                --     opts.callback(next_value)
                -- else
                --     opts.source = next_value
                -- end
            end
            return
        end

        local choices = type(opts.choices) == "function" and opts.choices() or opts.choices

        if vim.tbl_islist(current) then     -- list-style settings
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
                    string.format("multiple choices found (%s) in toggle list", table.concat(found, ", ")),
                    vim.log.levels.ERROR
                )
                return
            elseif #found == 1 then
                -- find the next item, remove current and add next
                local next_value = find_next_choice(found[1], choices)
                set_list_next(next_value, found[1])
                -- if opts.setting then
                --     vim.opt[opts.setting]:remove(found[1])
                --     if next_value ~= "" then
                --         vim.opt[opts.setting]:append(next_value)
                --     end
                -- elseif type(opts.source) == "function" then
                --     opts.callback(next_value)
                -- else
                --     opts.source = next_value
                -- end
            else
                -- nothing found, assume first
                set_list_next(choices[1])
                -- if opts.setting then
                --     vim.opt[opts.setting]:append(choices[1])
                -- elseif type(opts.source) == "function" then
                --     opts.callback(choices[1])
                -- else
                --     opts.source = choices[1]
                -- end
            end
            vim.notify(string.format("%s=%s", opts.setting, vim.o[opts.setting]), vim.log.levels.INFO)
        elseif type(current) ~= "table" then        -- map types not supported
            -- single setting
            local next_value = find_next_choice(current, choices)
            set_next(next_value)
            -- if opts.setting then
            --     vim.opt[opts.setting] = next_value
            --     vim.notify(string.format("%s=%s", opts.setting, next_value), vim.log.levels.INFO)
            -- elseif type(opts.source) == "function" then
            --     opts.callback(choices[1])
            -- else
            --     opts.source = choices[1]
            -- end
        end
    end
end


return M
