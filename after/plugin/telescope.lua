local util = require("user.util")
local buffer = require("user.buffer")
local table = require("table")
local os = require("user.os")

-- Telescope
local ts_builtin = require("telescope.builtin")
local mp = require("user.map")
local file = require("user.file")

local nnoremap = mp.nnoremap

local function ft_to_rg(ft)
    local lookup = {
        python = "py",
        javascript = "js",
        erlang = "erl",
        vim = "vimscript",
    }
    local ret = lookup[ft]

    if not ret then
        -- some are the same c, cpp etc
        ret = ft
    end
    return ret
end

local function grep_opts(opts)
    -- opts {
    --   dir   - starting directory, leave nil to use cwd, use "#" to use current buffer dir
    --   glob  - file pattern, eg *.py, or !*.py
    --   ftype - rg filetype eg py, vim filetypes are converted to rg equiv
    --   word  - bool, use word boundary in search, default false
    --   regex - bool, use regex in search, default false
    --   term  - search for this term, use nil for current word, "!" for prompt
    -- }
    local ret = {
        additional_args = {},
    }

    if opts.dir then
        ret.cwd = util.fif(opts.dir == "#", buffer.dirvish_or_buffer_dir(), opts.dir)
    end

    if type(opts.glob) == "string" and #opts.glob > 0 then
        -- although builtin.live_grep has glob_pattern, builtin.grep_string doesn't
        -- use additional_args as lowest common denominator
        table.insert(ret.additional_args, "--glob=" .. opts.glob)
    end

    if type(opts.ftype) == "string" and #opts.ftype > 0 then
        local type_filter = ft_to_rg(opts.ftype)
        table.insert(ret.additional_args, "--type=" .. type_filter)
    end

    if opts.word then
        table.insert(ret.additional_args, "-w")
    end

    if opts.regex then
        -- grep_string only
        ret.use_regex = true
    end

    if opts.term then
        -- grep_string only
        local search = opts.term
        if search == "!" then
            -- prompt
            vim.ui.input({ prompt = "grep: " }, function(value)
                search = value
            end)

            if not search then
                -- cancelled
                return false
            end
        end
        ret.search = search
    end

    -- util.debug(vim.inspect(ret))

    return ret
end

local function grep(func, opts)
    -- func = grep_string or live_grep
    local params = grep_opts(opts)
    if params then
        func(params)
    end
end

--
-- MAPPINGS
--

-- \f = mru files
nnoremap("<Leader>f", ts_builtin.oldfiles)

-- \z = buffers
nnoremap("<Leader>z", function()
    ts_builtin.buffers({ show_all_buffers = true })
end)

-- Alt-p = mru files (cwd)
nnoremap("<m-p>", function()
    local dir
    if vim.o.filetype == "dirvish" then
        dir = util.expand("%")
    else
        dir = vim.fn.getcwd()
    end

    if file.path_equal(dir, os.home_dir) then
        vim.notify("find_files: disabled in HOME", vim.log.levels.INFO)
    else
        ts_builtin.find_files()
    end
end)

-- \gr = cwd grep prompt
nnoremap("<leader>gr", function()
    grep(ts_builtin.grep_string, {
        term = "!",
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \br = buffer grep prompt
nnoremap("<leader>br", function()
    grep(ts_builtin.grep_string, {
        term = "!",
        dir = "#",
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \gw = cwd grep current word
nnoremap("<leader>gw", function()
    grep(ts_builtin.grep_string, {
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \bw = buffer grep current word
nnoremap("<leader>bw", function()
    grep(ts_builtin.grep_string, {
        dir = "#",
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

--  \lg = live grep
nnoremap("<leader>lg", function()
    grep(ts_builtin.live_grep, {
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)
