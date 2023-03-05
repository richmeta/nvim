local prettier = {
    tabWidth = function()
        return vim.opt.shiftwidth:get()
    end,
    singleQuote = true,
    trailingComma = "all",
    configPrecedence = "prefer-file",
    exclude = { "tsserver", "jsonls" },
}

return {
    "lukas-reineke/lsp-format.nvim",

    opts = {
        typescript = prettier,
        javascript = prettier,
        json = prettier,
        css = prettier,
        html = prettier,
        yaml = {
            tabWidth = function()
                return vim.opt.shiftwidth:get()
            end,
            singleQuote = true,
            trailingComma = "all",
            configPrecedence = "prefer-file",
        },
        python = {
            lineLength = 120,
        },
        markdown = prettier,
        sh = {
            tabWidth = 4,
        },
    }

}
