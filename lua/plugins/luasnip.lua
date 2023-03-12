local ls = nil

local function snippet_load()
    require("luasnip.loaders.from_lua").lazy_load()
end

local function expand()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end

local function forward()
    if ls.jumpable(1) then
        ls.jump(1)
    end
end

local function backward()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end

local function choice()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end

return {
    "L3MON4D3/LuaSnip",

    config = function()
        -- module level
        ls = require("luasnip") 

        ls.config.setup({
            history = true,
            update_events = { "TextChanged", "TextChangedI" },
            enable_autosnippets = true,
            store_selection_keys = "<Tab>",
        })
        snippet_load()
    end,

    keys = {
        { "<tab>", expand, mode = "i" },
        { "<Tab>", forward, mode = "s" },
        { "<S-Tab>", backward, mode = "i" },
        { "<S-Tab>", backward, mode = "s" },
        { "<C-j>", choice, mode = "i" },
        { "<leader>sr", snippet_load, mode = "n" },
    },
}
