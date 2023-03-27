local lsp = require("lspconfig")
local mp = require("user.map")
local buffer = require("user.buffer")
local util = require("user.util")

-- capabilities
-- ['textDocument/hover'] = { 'hoverProvider' },
-- ['textDocument/signatureHelp'] = { 'signatureHelpProvider' },
-- ['textDocument/definition'] = { 'definitionProvider' },
-- ['textDocument/implementation'] = { 'implementationProvider' },
-- ['textDocument/declaration'] = { 'declarationProvider' },
-- ['textDocument/typeDefinition'] = { 'typeDefinitionProvider' },
-- ['textDocument/documentSymbol'] = { 'documentSymbolProvider' },
-- ['textDocument/prepareCallHierarchy'] = { 'callHierarchyProvider' },
-- ['callHierarchy/incomingCalls'] = { 'callHierarchyProvider' },
-- ['callHierarchy/outgoingCalls'] = { 'callHierarchyProvider' },
-- ['textDocument/rename'] = { 'renameProvider' },
-- ['textDocument/prepareRename'] = { 'renameProvider', 'prepareProvider' },
-- ['textDocument/codeAction'] = { 'codeActionProvider' },
-- ['textDocument/codeLens'] = { 'codeLensProvider' },
-- ['codeLens/resolve'] = { 'codeLensProvider', 'resolveProvider' },
-- ['workspace/executeCommand'] = { 'executeCommandProvider' },
-- ['workspace/symbol'] = { 'workspaceSymbolProvider' },
-- ['textDocument/references'] = { 'referencesProvider' },
-- ['textDocument/rangeFormatting'] = { 'documentRangeFormattingProvider' },
-- ['textDocument/formatting'] = { 'documentFormattingProvider' },
-- ['textDocument/completion'] = { 'completionProvider' },
-- ['textDocument/documentHighlight'] = { 'documentHighlightProvider' },
-- ['textDocument/semanticTokens/full'] = { 'semanticTokensProvider' },
-- ['textDocument/semanticTokens/full/delta'] = { 'semanticTokensProvider' },

--------------------------------------------------------------------------------

local group = vim.api.nvim_create_augroup("LSPAutoCmd", {})

local function on_attach(client, bufnr)
    if client.supports_method("textDocument/inlayHint") then
        require("lsp-inlayhints").on_attach(client, bufnr)
    end

    if client.supports_method("textDocument/definition") then
        -- gd = goto definition (lsp)
        -- TODO: could use C-] here, depending if we're using tags files
        mp.nmap_b("gd", vim.lsp.buf.definition)
    end

    if client.supports_method("textDocument/declaration") then
        -- gD = goto declaration (lsp)
        mp.nmap_b("gD", vim.lsp.buf.declaration)
    end

    if client.supports_method("textDocument/hover") then
        -- K = hover signature (lsp)
        mp.nmap_b("K", vim.lsp.buf.hover)
    end

    if client.supports_method("textDocument/typeDefinition") then
        -- td = goto type declaration (lsp)
        mp.nmap_b("td", vim.lsp.buf.type_definition)
    end

    if client.supports_method("textDocument/implementation") then
        -- gi = goto implementation (lsp)
        mp.nmap_b("gi", vim.lsp.buf.implementation)
    end

    if client.supports_method("textDocument/references") then
        -- gr = show references (lsp)
        mp.nmap_b("gr", vim.lsp.buf.references)
    end

    if client.supports_method("textDocument/rename") then
        -- gD = goto declaration (lsp)
        mp.nmap_b("<leader>rn", vim.lsp.buf.rename)
    end

    if client.supports_method("textDocument/codeAction") then
        -- \ca = run code action (lsp)
        mp.nmap_b("<leader>ca", vim.lsp.buf.code_action)

        -- TODO: not working for python, textDocument/codeLens is not supported
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = group,
            pattern = "<buffer>",
            callback = function()
                vim.lsp.codelens.refresh()
            end,
        })
        -- dirty hack
        local timer = vim.loop.new_timer()
        timer:start(300, 0, function()
            timer:close()
            vim.schedule_wrap(function()
                vim.lsp.codelens.refresh()
            end)()
        end)
    end

    if client.supports_method("textDocument/signatureHelp") then
        -- ctrl-k = signature help (lsp)
        mp.nmap_b("<c-k>", vim.lsp.buf.signature_help)
    end

    if client.supports_method("textDocument/rangeFormatting") then
        -- ctrl-F5 = format code (lsp)
        mp.vmap_b("<c-f5>", vim.lsp.buf.format)
    end

    if client.supports_method("textDocument/formatting") then
        -- ctrl-F5 = format code (lsp)
        mp.nmap_b("<c-f5>", function() 
            -- TODO: keymaps not working in terminal
            vim.lsp.buf.format()
        end)
    end

    -- gF = diagnostics float (lsp)
    mp.nmap_b("gF", vim.diagnostic.open_float)

    -- \gq = errors to quickfix (lsp)
    mp.nmap_b("<leader>gq", vim.diagnostic.setqflist)

    -- [g = prev error (lsp)
    mp.nmap_b("[g", vim.diagnostic.goto_prev)

    -- ]g = next error (lsp)
    mp.nmap_b("]g", vim.diagnostic.goto_next)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lsp.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

lsp.erlangls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

lsp.tsserver.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    single_file_support = true,
    init_options = {
        preferences = {
            includeCompletionsWithSnippetText = true,
            includeCompletionsWithInsertText = true,
        },
    },
    settings = {
        completions = {
            completeFunctionCalls = true,
        },
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
})

lsp.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- TODO: maybe add to toggle
--  pass source for the setting

-- Ctrl-F5 - toggle LSP errors
local diagnostics_enabled = true
local function toggle_diagnostics()
    local buffer_id = buffer.id()
    if diagnostics_enabled then
        vim.diagnostic.disable(buffer_id)
    else
        vim.diagnostic.enable(buffer_id)
    end
    diagnostics_enabled = not diagnostics_enabled
end

mp.nnoremap("<F5>", toggle_diagnostics)
mp.inoremap("<F5>", toggle_diagnostics)


-- function _G.activeLSP()
--     local servers = {}
--     for _, lsp in pairs(vim.lsp.get_active_clients()) do
--         table.insert(servers, { name = lsp.name, id = lsp.id })
--     end
--     _G.P(servers)
-- end

-- function _G.bufferActiveLSP()
--     local servers = {}
--     for _, lsp in pairs(vim.lsp.buf_get_clients()) do
--         table.insert(servers, { name = lsp.name, id = lsp.id })
--     end
--     _G.P(servers)
-- end
