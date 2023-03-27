if vim.fn.exists("g:neovide") == 1 then
    local os = require('user.os')

    if os.is_unix then
        vim.o.guifont = [[DroidSansMono\ Nerd\ Font:h12,Consolas:h9:cANSI]]
    elseif os.is_mac then
        vim.o.guifont = "FiraMono-Regular:h14"
    else
        vim.o.guifont = [[Consolas\ 10]]
    end
end
