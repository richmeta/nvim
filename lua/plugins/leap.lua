return {
    'ggandor/leap.nvim',

    -- TODO - is there a way to feedback what keys i'm searching for
    opts = {},

    keys = {
        {"<M-s>", "<Plug>(leap-forward-to)", mode = "n", noremap = true},
        {"<M-S>", "<Plug>(leap-backward-to)", mode = "n", noremap = true},
    },

    dependencies = {
        {"tpope/vim-repeat"}
    }
}
