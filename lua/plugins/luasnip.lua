local function snippet_load()
    require("luasnip.loaders.from_lua").lazy_load()
end

return {
    "L3MON4D3/LuaSnip",

    -- must be loaded before nvim-cmp
    -- for key mappings
    lazy = false,

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
        -- TODO: \se - snippet edit
        { "<leader>sr", snippet_load, mode = "n" },
    },
}
