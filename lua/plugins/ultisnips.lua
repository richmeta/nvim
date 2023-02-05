return {
    "SirVer/ultisnips",

    config = function()
        vim.g.UltiSnipsDebugServerEnable = 0
        vim.g.UltiSnipsEditSplit = "tabdo"
    end,

    keys = {
        -- \se = Edit Snippets for filetype
        {"<Leader>se", vim.cmd.UltiSnipsEdit, mode = "n", noremap = true},

        -- \sr = Reload Snippets for filetype
        {"<Leader>sr", ":call UltiSnips#RefreshSnippets()<cr>", mode = "n", noremap = true}
    }

}


-- TODO: copy over snippets
