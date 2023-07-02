return {
    "williamboman/mason-lspconfig.nvim",

    opts = {
        ensure_installed = {
            "lua_ls",
            "pyright",
            "rust_analyzer",
            -- "erlangls",
            "tsserver",
            -- "docker_compose_language_service"
        }
    }
}
