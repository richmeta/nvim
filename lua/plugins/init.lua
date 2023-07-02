local plugins = {
    -- essential
    { "nvim-lua/plenary.nvim" },

    -- treesitter
    { "nvim-treesitter/nvim-treesitter" },                      -- yes
    { "nvim-treesitter/playground" },

    -- lsp
    { "williamboman/mason.nvim", opts = {}, build = ":MasonUpdate" },
    { "williamboman/mason-lspconfig.nvim" },                    -- yes
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },    -- yes
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/nvim-cmp" },                                     -- yes
    { "saadparwaiz1/cmp_luasnip" },
    { "lvimuser/lsp-inlayhints.nvim" },                         -- yes
    { "ray-x/lsp_signature.nvim" },                             -- yes

    -- TODO: configure
    { "ThePrimeagen/harpoon" },

    -- git
    { "NeogitOrg/neogit", opts = {} },                          -- yes
    { "sindrets/diffview.nvim", opts = {} },
    -- { "bobrown101/git-blame.nvim" },                         -- TODO: not working very well

    -- commenting
    { "numToStr/Comment.nvim", opts = {} },

    -- files, buffers
    { "justinmk/vim-dirvish" },                                 -- yes
    { "nvim-telescope/telescope.nvim" },                        -- yes

    -- highlighting
    { "t9md/vim-quickhl" },                                     -- yes

    -- status line
    { "nvim-lualine/lualine.nvim" },                            -- yes

    -- navigation
    { "ggandor/leap.nvim" },                                    -- yes

    -- edits
    { "kylechui/nvim-surround", opts = {} },
    { "AndrewRadev/switch.vim" },                               -- yes
    { "godlygeek/tabular" },

    -- erlang
    { "vim-erlang/vim-erlang-tags", ft = "erlang" },

    -- terminal
    { "akinsho/toggleterm.nvim" },                              -- yes

    -- text objects
    { "kana/vim-textobj-line", dependencies = { "kana/vim-textobj-user" }  },
    { "sgur/vim-textobj-parameter", dependencies = { "kana/vim-textobj-user" }  },
    { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" }  },

    -- markdown
    { "preservim/vim-markdown" },

    -- tmux
    { "christoomey/vim-tmux-navigator" },

}

-- load any local plugins, from user/localplugins.lua
-- eg return {   { "another-plugin", config = {..} } }
local ok, localplugins = pcall(require, 'user.localplugins')
if not ok then
    localplugins = {}
end

vim.list_extend(plugins, localplugins)
return plugins
