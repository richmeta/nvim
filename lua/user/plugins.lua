local util = require('user.util')

-- Bootstrap packer if it is not installed.
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()

-- Packer needs to compile lazy loading hooks after plugin configuration changes. Do this
-- automatically on changes to this file. This also sources changes so that
-- calls to `:PackerInstall` or `:PackerUpdate` use the latest config.
vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('packer_user_config', { clear = true }),
    pattern = 'plugins.lua',
    callback = function()
        vim.cmd.source '<afile>'
        vim.cmd.PackerCompile()
    end
})


local function merge_plugin_conf(input) 
    -- for each plugin optionally load and merge config from nvim/lua/plugin
    local ret = {}
    local name = input[1]

    -- use name without leading path, without extension
    local plug_filename = name:match("/(%S+)%.?")
    local without_ext = plug_filename:match("(.+)%.%w+$")       -- strip off .nvim, if present
    local to_load = without_ext or plug_filename
    local mod = string.format("plugconf.%s", to_load)
    util.debug("attempting load ", mod)

    local ok, content = pcall(require, mod)
    if ok then
        local ret = vim.tbl_extend("force", input, content)
        print(vim.inspect(ret))
        return ret
    end
    return input
end

local plugins = {
    {"wbthomason/packer.nvim"},
    {"tpope/vim-commentary"},
    {"davidhalter/jedi-vim"},
    {"justinmk/vim-dirvish"},
    {"t9md/vim-quickhl"},
    {"SirVer/ultisnips"} ,  
    {"nvim-lua/plenary.nvim"},
    {"ThePrimeagen/harpoon"},
    {"nvim-telescope/telescope.nvim"},
    {"nvim-treesitter/nvim-treesitter"}
}

return require("packer").startup(function(use)
    -- use(plugins)

    for _, config in pairs(plugins) do
        local merged = merge_plugin_conf(config)
        use(merged)
    end

    if packer_bootstrap then
        require('packer').sync()
    end
end)


-- return require("packer").startup(
--     function(use)
--         use("wbthomason/packer.nvim")
--         use("tpope/vim-commentary")
--         use("davidhalter/jedi-vim")
--         use("justinmk/vim-dirvish")
--         use("t9md/vim-quickhl")
--         use("SirVer/ultisnips")   
--         use("nvim-lua/plenary.nvim")
--         use("ThePrimeagen/harpoon")
--         use("nvim-telescope/telescope.nvim")
--         use("nvim-treesitter/nvim-treesitter", {
--             run = ":TSUpdate"
--         })
--     end
-- )

