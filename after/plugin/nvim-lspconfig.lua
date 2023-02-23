local mp = require("user.map")
local lsp = require("lspconfig")

local function common_maps()
    mp.nmap_b("K", vim.lsp.buf.hover)
    mp.nmap_b("[g", vim.diagnostic.goto_prev)
    mp.nmap_b("]g", vim.diagnostic.goto_next)
    mp.nmap_b("gd", vim.lsp.buf.definition)
    mp.nmap_b("gt", vim.lsp.buf.type_definition)
    mp.nmap_b("gi", vim.lsp.buf.implementation)         -- TODO: some dont support this, like pyright,  is there a way to retrieve from the server
    mp.nmap_b("gR", vim.lsp.buf.rename)
end



lsp.pyright.setup( { on_attach = common_maps } )
lsp.erlangls.setup( { on_attach = common_maps } )
lsp.tsserver.setup( { on_attach = common_maps } )

lsp.lua_ls.setup( {
    on_attach = common_maps,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }

    }
} )
