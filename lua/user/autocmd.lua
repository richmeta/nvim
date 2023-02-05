local api = vim.api

local highlightListChars = api.nvim_create_augroup("HighlightListChars", { clear = true })

api.nvim_create_autocmd("ColorScheme", {
    -- TODO: not working, terminal?
    -- vim.api.nvim_set_hl(0, "InputHighlight", { fg = "#ffffff", ctermfg = 255, bg = "#00ff00", ctermbg = 14 }) ???
    command = "highlight Specialkey guibg=lightgreen",
    group = highlightListChars
})
