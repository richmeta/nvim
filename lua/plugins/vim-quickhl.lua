return {
    "t9md/vim-quickhl",

    lazy = false,

    keys = {
        -- \km = mark the WORD
        {"<Leader>km", "<Plug>(quickhl-manual-this-whole-word)", mode = "n", noremap = true },
        {"<Leader>km", "<Plug>(quickhl-manual-this-whole-word)", mode = "x", noremap = true },

        -- \kM = mark the word
        {"<Leader>kM", "<Plug>(quickhl-manual-this)", mode = "n", noremap = true},
        {"<Leader>kM", "<Plug>(quickhl-manual-this)", mode = "x", noremap = true},

        {"<Leader>kk", "<Plug>(quickhl-manual-reset)", mode = "n", noremap = true},
        {"<Leader>kk", "<Plug>(quickhl-manual-reset)", mode = "x", noremap = true},

        -- \kv = mark visual selection
        {"<Leader>kv", [[y:QuickhlManualAdd<space><C-R>"<cr>]], mode = "v", noremap = true},

        -- \kq = prompt for what to select
        {"<Leader>kq", ":QuickhlManualAdd<space>", mode = "n", noremap = true},

        -- alt-m = next mark
        -- alt-M = prev mark
        -- TODO: a-n or a-N doesn't work in neovide
        {"<a-m>", "<Plug>(quickhl-manual-go-to-next)", mode = "n", noremap = true},
        {"<a-M>", "<Plug>(quickhl-manual-go-to-prev)", mode = "n", noremap = true}
    }
}
