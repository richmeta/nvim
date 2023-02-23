
--                                                  -- own file ?
return {
    -- essential
    { "nvim-lua/plenary.nvim" },

    -- treesitter
    { "nvim-treesitter/nvim-treesitter" },          -- yes
    { "nvim-treesitter/playground" },

    -- lsp
    { "williamboman/mason.nvim", opts = {} },
    { "williamboman/mason-lspconfig.nvim" },          -- yes
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
    { "neovim/nvim-lspconfig" },

    -- python - TODO: replace with LSP?
    -- { "davidhalter/jedi-vim", ft = "python" },

    -- TODO: configure
    { "ThePrimeagen/harpoon" },

    -- git
    { "lewis6991/gitsigns.nvim", opts = {} },
    { "TimUntersberger/neogit", opts = {} },
    { "sindrets/diffview.nvim", opts = {} },

    -- commenting
    { "numToStr/Comment.nvim", opts = {} },

    -- files, buffers
    { "justinmk/vim-dirvish" },                     -- yes
    { "nvim-telescope/telescope.nvim" },            -- yes

    -- snippets TODO: replace with lua
    -- { "SirVer/ultisnips" },                         -- yes

    -- highlighting
    { "t9md/vim-quickhl" },                         -- yes

    -- status line
    { "nvim-lualine/lualine.nvim" },                -- yes

    -- navigation
    { "ggandor/leap.nvim" },                        -- yes

    -- edits
    { "kylechui/nvim-surround", opts = {} },
    { "AndrewRadev/switch.vim" },                   -- yes
    { "godlygeek/tabular" },

    -- erlang
    { "vim-erlang/vim-erlang-tags", ft = "erlang" },

    -- terminal
    { "akinsho/toggleterm.nvim" }                   -- yes
}

-- TODO: local plugins
