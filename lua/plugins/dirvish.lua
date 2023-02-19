
return {
    "justinmk/vim-dirvish",

    lazy = false,

    keys = {
        -- <F4> = dirvish current dir
        {"<F4>", "<Plug>(dirvish_up):echo(expand('%'))<cr>", mode = "n", noremap = true },
        {"<F4>", "Dirvish<Space>", mode = "c" },

        -- g<F4> = dirvish git root dir
        {"g<F4>", function()
            local gitcli = require("neogit.lib.git.cli")
            local gitdir = gitcli.git_root()
            local cmd = string.format("tabedit +Dirvish %s", gitdir)
            vim.cmd(cmd)
        end, mode = "n"},

        -- Shift-<F4> = vsplit + dirvish current dir
        {"<f16>", "<Plug>(dirvish_vsplit_up)", mode = "n", noremap = true },

        -- \F4 = dirvish from this directory or file (tab)
        {"<Leader><F4>", function()
            vim.cmd(string.format("tabedit +Dirvish %s", vim.fn.expand('%', 'dir')))
        end, mode = "n"},
    }
}
