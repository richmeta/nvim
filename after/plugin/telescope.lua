local util = require("user.util")
local los = require("user.os")
local grep = require("user.grep")

-- Telescope
local ts_builtin = require("telescope.builtin")
local mp = require("user.map")
local file = require("user.file")
local nnoremap = mp.nnoremap

--
-- MAPPINGS
--

-- ctrl-q = send results to quick fix

-- \f = mru files
nnoremap("<Leader>f", ts_builtin.oldfiles)

-- \z = buffers
nnoremap("<Leader>z", function()
    ts_builtin.buffers({ show_all_buffers = true })
end)

-- \pp = files (cwd)
nnoremap("<leader>pp", function()
    local dir
    if vim.o.filetype == "dirvish" then
        dir = util.expand("%")
    else
        dir = vim.fn.getcwd()
    end

    if file.path_equal(dir, los.home_dir) then
        vim.notify("find_files: disabled in HOME", vim.log.levels.INFO)
    else
        ts_builtin.find_files()
    end
end)

-- \gr = cwd grep prompt
nnoremap("<leader>gr", function()
    grep.grep(ts_builtin.grep_string, {
        prompt = true,
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \br = buffer grep prompt
nnoremap("<leader>br", function()
    grep.grep(ts_builtin.grep_string, {
        prompt = true,
        dir = "#",
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- TODO:
-- grep visual selected

-- \gw = cwd grep current word
nnoremap("<leader>gw", function()
    grep.grep(ts_builtin.grep_string, {
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \bw = buffer grep current word
nnoremap("<leader>bw", function()
    grep.grep(ts_builtin.grep_string, {
        dir = "#",
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

--  \lg = live grep
nnoremap("<leader>lg", function()
    grep.grep(ts_builtin.live_grep, {
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \gt = last telescope picker
nnoremap("<leader>gt", ts_builtin.resume)
