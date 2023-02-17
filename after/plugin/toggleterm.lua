local mp = require("user.map")

-- TODO: not working
vim.api.nvim_create_autocmd({"TermOpen"}, {
    pattern = "term://*",
    group = group_format_opts,
    callback = function()
        -- vim.notify("TermOpen", vim.log.levels.INFO)
        -- mp.tmap_b("<esc>", [[<C-\><C-n>]])
        -- mp.tmap_b("<m-h>", [[C-\><C-n><C-w>h]])
        -- mp.tmap_b("<m-j>", [[C-\><C-n><C-w>j]])
        -- mp.tmap_b("<m-k>", [[C-\><C-n><C-w>k]])
        -- mp.tmap_b("<m-l>", [[C-\><C-n><C-w>l]])

        -- local opts = {noremap = true}
        -- vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[C-\><C-n><C-w>h]], opts)
        -- vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[C-\><C-n><C-w>j]], opts)
        -- vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[C-\><C-n><C-w>k]], opts)
        -- vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[C-\><C-n><C-w>l]], opts)

    end,
})
