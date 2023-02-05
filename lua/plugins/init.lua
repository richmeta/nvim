
--                                                  -- own file ?
return {
    -- essential
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },

    -- python - TODO: replace with LSP?
    { "davidhalter/jedi-vim" },

    -- TODO: configure
    { "ThePrimeagen/harpoon" },

    -- git
    { "lewis6991/gitsigns.nvim", opts = {} },
    -- { "TimUntersberger/neogit.git", opts = {} },

    -- commenting
    { "numToStr/Comment.nvim", opts = {} },

    -- files, buffers
    { "justinmk/vim-dirvish" },                     -- yes
    { "nvim-telescope/telescope.nvim" },            -- yes

    -- snippets
    { "SirVer/ultisnips" },                         -- yes

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
    { "vim-erlang/vim-erlang-tags" },

    -- terminal TODO
    -- { "akinsho/toggleterm.nvim" }
}

-- TODO: local plugins
