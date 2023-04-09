local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
    s( { trig = "erlang", dscr = "erlang gitignore" }, 
        fmt([[
        # rebar 3
        .rebar3
        _build/
        _checkouts/
        conf/temp_generated.*
        conf/local.sys.config
        rebar.config.script
        *.crashdump
        rebar.lock
        ]], {}, {})
    ),

    s( { trig = "python", dscr = "python gitignore" }, 
        fmt([[
        __pycache__
        *.pyc
        *.pyo
        *.pyd
        *.log
        coverage.*
        .coverage
        venv/
        ]], {}, {})
    ),
}


