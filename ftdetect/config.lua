
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.config",
    command = "set filetype=erlang",
})
