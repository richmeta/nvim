return {
    "mfussenegger/nvim-lint",

    config = function()
        require('lint').linters_by_ft = {
            -- python = {'mypy', 'flake8'},
            python = {'mypy'},
            cpp = {'cppcheck'},
            javascript = {'eslint'},
            lua = {'selene'},
        }
    end,

    keys = {
        -- \ll = lint
        { "<leader>ll", function()
            require('lint').try_lint()
        end }
    }
}
