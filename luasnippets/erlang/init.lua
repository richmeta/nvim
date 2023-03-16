local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local s = ls.snippet
local sn = ls.snippet_node
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local u = require("user.snip")


local function module_node() 
    return f(function(_, snip)
        local filename = snip.env.TM_FILENAME
        if filename == "" then
            return "module"
        end
        return filename:match("([%w-_]+).erl")
    end)
end

local function latin_or_utf8()
    return { t"latin1", t"utf8" }
end

-- formatting var lists
-- eg: some message|A, B, C,
--     ^            ^      ^
--     preamble     spec   ending
--
-- return {
--    preamble = "some message",
--    format = "A = ~p, B = ~p, C = ~p"
--    vars = { A, B, C }
--    ending = ","
-- }
local function var_list_parse(input, opts)
    local pat_format = "%s*(%w+)%s*,?"
    local preamble, rest = string.match(input, "(.-)|(.*)$")
    if not preamble or #preamble == 0 then
        rest = input
    end
    local spec, ending = string.match(rest, "(.-)([,;.]?)%s*$")
    local formats = {}
    local vars = {}

    local _, j, var = string.find(spec, pat_format)
    while var do
        table.insert(vars, var)
        table.insert(formats, string.format("%s = ~p", var))
        _, j, var = string.find(spec, pat_format, j + 1)
    end

    local format = table.concat(formats, ", ")
    if opts and opts.newline then
        format = format .. "~n"
    end
    return {
        preamble = preamble,
        format = format,
        vars = table.concat(vars, ", "),
        ending = ending
    }
end

local function var_list_node(ji, name, opts)
    return d(ji, function(_args, snip)
        local data = var_list_parse(snip.captures[1], opts)
        local preamble = ""
        if data.preamble then
            preamble = string.format("%s: ", data.preamble)
        end
        return sn(nil,
            t(string.format('%s("%s%s", [%s])%s',
                name,
                preamble,
                data.format,
                data.vars,
                data.ending or ""
            )))
    end)
end


return {
    -- format helpers
    s( { trig = "pal%s+(.*)", dscr = "ct:pal helper", regTrig = true, wordTrig = false },
        var_list_node(1, "ct:pal")
    ),

    s( { trig = "iof%s+(.*)", dscr = "io:format helper", regTrig = true, wordTrig = false },
        var_list_node(1, "io:format", { newline = true })
    ),

    s( { trig = "?debugFmt%s+(.*)", dscr = "debugFmt helper", regTrig = true, wordTrig = false },
        var_list_node(1, "?debugFmt")
    ),

    s( { trig = "palv", dscr = "visual palv" },
        fmt('ct:pal("{} = ~p", [{}])', {
            u.visual(1), rep(1)
        })
    ),

    -- top of module
    s( { trig = "#!", dscr = "shebang", snippetType = "autosnippet" }, 
        t{ '#!/usr/bin/env escript -c', '',
            '-export([main/1]).', '',
            'main(Args) ->',
            '	ok.',
            'endsnippet' }
    ),

    s( { trig = "-?mod", dscr = "Current module name", regTrig = true },
        fmt("-module({}).", module_node())
    ),

    s( { trig = "-?exall", dscr = "export all", regTrig = true },
        t{'-compile(nowarn_export_all).', '-compile(export_all).', ''}),

    s( { trig = "-?exp", dscr = "export/selected", regTrig = true },
        fmt("-export([{}]).", u.visual(1))
    ),

    s( { trig = "-?beh", dscr = "behaviour", regTrig = true },
        fmt("-behaviour({}).", u.visual(1))
    ),

    s( { trig = "-?def", dscr = "define", regTrig = true },
        fmt("-define({}, {}).", { i(1), i(2) })
    ),

    s( { trig = "ct.hrl", dscr = "common test header" },
        t{'-include_lib("common_test/include/ct.hrl").', ''} ),

    s( { trig = "eunit.hrl", dscr = "eunit header" },
        t{'-include_lib("eunit/include/eunit.hrl").', ''} ),

    s( { trig = "assert.hrl", dscr = "assert header" },
        t{'-include_lib("stdlib/include/assert.hrl").', ''} ),

    -- common elements
    s( { trig = "err", dscr = "inline error" },
        t"{error, Error}" ),

    s( "cerr", t{'{error, Error} ->', '    {error, Error}'} ),

    s( { trig = "fun", dscr = "anon function" }, fmt(
[[fun({}) ->
    {}
end]], {
         i(1), i(2)
       })
    ),

    -- for specs
    s( { trig = "serr", dscr = "spec error" },
        t'{error, any()}' ),

    s( { trig = "doc", dscr = "doc tag" },
        t'%% @doc '),

    -- operators
    s( { trig = "==", dscr = "equals", snippetType = "autosnippet" }, t'=:=' ),

    s( { trig = "!=", dscr = "not equals", snippetType = "autosnippet" }, t'=/=' ),
    
    s( { trig = "||", dscr = "list comprehension" },
        fmt("[ {} || {} <- {} ]", {
            i(3), i(2), i(1)
       })
    ),

    -- common type conversions
    s( { trig = "btl", dscr = "binary_to_list" },
        fmt("binary_to_list({})", u.visual(1))
    ),

    s( { trig = "ltb", dscr = "list_to_binary" },
        fmt("list_to_binary({})", u.visual(1))
    ),

    s( { trig = "atb", dscr = "atom_to_binary" },
        fmt("atom_to_binary({}, {})", {
            u.visual(1),
            c(2, latin_or_utf8())
        })
    ),

    s( { trig = "bta", dscr = "binary_to_atom" },
        fmt("binary_to_atom({}, {})", {
            u.visual(1),
            c(2, latin_or_utf8())
        })
    ),

    -- common macros
    s( { trig = "mn", dscr = "?MODULE" },
        t'?MODULE' ),

    s( { trig = "fn", dscr = "?FUNCTION_NAME" },
        t'?FUNCTION_NAME' ),

    -- gen_server
    s( { trig = "cast", dscr = "gen_server cast" },
        fmt('gen_server:cast(?SERVER, {})', i(1))
    ),

    s( { trig = "call", dscr = "gen_server call" },
        fmt('gen_server:call(?SERVER, {})', i(1))
    ),

    s( { trig = "handle", dscr = "handle cast/call/info/continue" },
        fmt(
[[handle_{}({}) ->
    {};
]],
        {
            c(1, { t"cast", t"call", t"info", t"continue" }),

            -- arguments
            d(2, function(args)
                local typ = args[1][1]
                if typ == "call" then
                    return sn(2,
                        fmt("{}, _From, {}State", { i(1), i(2) })
                    )
                else
                    return sn(2,
                        fmt("{}, {}State", { i(1), i(2) })
                    )
                end
            end, 1, {}),

            -- reply
            d(3, function(args)
                local typ = args[1][1]
                if typ == "call" then
                    return sn(3,
                        fmt("    <>{reply, ok, State}", i(1), { delimiters = '<>' })
                    )
                else
                    return sn(3,
                        fmt("    <>{noreply, State}", i(1), { delimiters = '<>' })
                    )
                end
            end, 1, {})
        })
    ),

    s( { trig = "ctest", dscr = "common test func" },
        fmt(
[[test_{}(_Config) ->
    {}.]], { i(1), i(0, "ok") }
        )
    ),

    s( { trig = "int", dscr = "type" },
        t'integer()' 
    ),

    s( { trig = "nni", dscr = "type" },
        t'non_neg_integer()' 
    ),

    s( { trig = "pos", dscr = "type" },
        t'pos_integer()' 
    ),

    -- expanded from template files
    s( { trig = "gen_server", dscr = "gen_server template" }, 
        u.snip_tmpl("erlang/gen_server.tmpl", module_node(), { delimiters = "£" })
    ),

    s( { trig = "ct", dscr = "ct template" }, 
        u.snip_tmpl("erlang/ct.tmpl", module_node(), { delimiters = "£" })
    ),

    s( { trig = "eunit", dscr = "eunit template" }, 
        u.snip_tmpl("erlang/eunit.tmpl", module_node(), { delimiters = "£" })
    ),

    s( { trig = "supervisor", dscr = "supervisor template" }, 
        u.snip_tmpl("erlang/supervisor.tmpl", module_node(), { delimiters = "£" })
    ),

    s( { trig = "application", dscr = "application template" }, 
        u.snip_tmpl("erlang/application.tmpl", module_node(), { delimiters = "£" })
    ),

    -- TODO: move to gitignore filetype, trig = erlang
    s( { trig = "gitignore", dscr = "gitignore template" }, 
        u.snip_tmpl("erlang/gitignore.tmpl", {}, { delimiters = "£" })
    ),

}

