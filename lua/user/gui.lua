local os = require('user.os')

if os.is_unix then
    vim.o.guifont = "Consolas:h9:cANSI"
elseif os.is_mac then
    vim.o.guifont = "FiraMono-Regular:h14"
else
    vim.o.guifont = [[Consolas\ 10]]
end
