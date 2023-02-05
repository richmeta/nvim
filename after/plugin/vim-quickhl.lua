local mp = require("user.map")
local nnoremap = mp.nnoremap
local vnoremap = mp.vnoremap
local xnoremap = mp.xnoremap

-- \km = mark the WORD
nnoremap("<Leader>km", "<Plug>(quickhl-manual-this-whole-word)")
xnoremap("<Leader>km", "<Plug>(quickhl-manual-this-whole-word)")

-- \kM = mark the word
nnoremap("<Leader>kM", "<Plug>(quickhl-manual-this)")
xnoremap("<Leader>kM", "<Plug>(quickhl-manual-this)")

-- \kk = clear all marks
nnoremap("<Leader>kk", "<Plug>(quickhl-manual-reset)")
xnoremap("<Leader>kk", "<Plug>(quickhl-manual-reset)")

-- \kv = mark visual selection
vnoremap("<Leader>kv", [[y:QuickhlManualAdd<space><C-R>"<cr>]])

-- \kq = prompt for what to select
nnoremap("<Leader>kq", ":QuickhlManualAdd<space>")

-- alt-n = next mark
-- alt-N = prev mark
nnoremap("<m-n>", "<Plug>(quickhl-manual-go-to-next)")
nnoremap("<m-N>", "<Plug>(quickhl-manual-go-to-prev)")

