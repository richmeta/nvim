
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {

    s("loc", {
        t"local ", i(1), t" = ", i(2), t" -- ", i(0)
    }),


}
