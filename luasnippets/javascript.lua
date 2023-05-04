
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local u = require("user.snip")

return {
    -- 
    s( { trig = "#!", dscr = "shebang", snippetType = "autosnippet" },
        t{'#!/usr/bin/env node', ''}
    ),
}
