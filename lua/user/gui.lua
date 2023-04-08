local los = require('user.os')
if not los.is_gui then
    return
end

if los.is_mac then
    vim.o.guifont = "Droid Sans Mono for Powerline:h14"
elseif los.is_unix then
    vim.o.guifont = "DroidSansMono Nerd Font:h11,Consolas:h10:cANSI"
else
    vim.o.guifont = [[Consolas\ 10]]
end

local function font_size(incr)
    local font = vim.o.guifont
    local size = tonumber(font:match(":h(%d+)"))
    local new_font = font:gsub(":h(%d+)", string.format(":h%d", size + incr), 1)
    vim.o.guifont = new_font
end

local mp = require("user.map")

-- Ctrl +/= = increase font size
mp.nnoremap("<C-=>", function()
    font_size(1)
end)

-- Ctrl - = decrease font size
mp.nnoremap("<C-->", function()
    font_size(-1)
end)

if los.is_mac then
    -- Cmd-F = toggle fullscreen
    mp.nnoremap("<D-f>", function()
        if vim.g.neovide_fullscreen then
            vim.g.neovide_fullscreen = false
        else
            vim.g.neovide_fullscreen = true
        end
    end)
end


