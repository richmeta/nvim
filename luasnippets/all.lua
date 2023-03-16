local ls = require("luasnip")
local s = ls.snippet
-- local t = ls.text_node
-- local i = ls.insert_node
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local u = require("user.snip")

print("loading luasnippets")

math.randomseed(os.time())

local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

return {

    s( { trig = "todo", name = "insert todo" },
        fmt("{} TODO: ", {
            f(function() 
                -- get current comment prefix
                local cs = vim.opt_local.commentstring:get()
                local pos = string.find(cs, "%%s")
                local prefix = string.sub(cs, 1, pos-1)
                return vim.trim(prefix)
            end, {})
        })
    ),

    s( { trig = "uuid", name = "Generate UUID" },
        f(function() 
            return uuid()
        end, {})
    ),

    s( { trig = "pa", dscr = "parenthesize" },
        fmt("({})", u.visual(1))
    )
}
