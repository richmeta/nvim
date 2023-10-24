local mp = require("user.map")
local util = require("user.util")
local buffer = require("user.buffer")
local clipboard = require("user.clip")
local tg = require("user.toggler")

-- buffer local variables
-- iskeyword toggling ( see keymaps -> \kd )
vim.b.lang_dot = ":"

-- buffer local settings
vim.bo.commentstring = "%%%s"

-- switch defs
vim.b.switch_custom_definitions = {
	{
		-- convert binary to string
		[ [[<<"[^"]*">>]] ] = {
			["[<>]"] = "",
		},

		-- convert string to binary
		[ [["[^"]*"]] ] = {
			[ [[\("[^"]*"\)]] ] = [[<<\1>>]],
		},

        -- convert Variable to _Variable
        -- ( \@<! is positive lookbehind, only matches not preceding with quotes )
		[ [["\@<!\<\(\u\w*\)\>]] ] = [[_\1]],

        -- convert _Variable to Variable
		[ [["\@<!\<_\(\u\w*\)\>]] ] = [[\1]],

		-- dict
		["=>"] = ":=",
		[":="] = "=>",
		list_to_binary = "binary_to_list",
		binary_to_list = "list_to_binary",
		int_to_binary = "binary_to_int",
		binary_to_int = "int_to_binary",
	},
}

-- \kd = toggle ':' in iskeyword
mp.nnoremap_b("<Leader>kd", tg.toggle({
    setting = "iskeyword",
    choices = { ":", "" },
}))

-- \kc = search for handle_cast/call/info/continue under cursor
mp.nnoremap_b("<Leader>kc", function()
    local cmd = string.format([[/handle_[castlinfotue]\+\s*(.*%s]], util.expand("<cword>"))
    -- vim.fn.keepjumps()  TODO; waiting for neovim impl
    util.execute(cmd)
end)

-- Ctrl \] = goto tag (overrides global for vim_erlang_tags)
if vim.fn["vim_erlang_tags#VimErlangTagsSelect"] then
    mp.nnoremap_b("<Leader><C-]>", function()
        vim.fn["vim_erlang_tags#VimErlangTagsSelect"](1)
        local keys = vim.api.nvim_replace_termcodes('<c-]><C-w>T',true,false,true)
        vim.api.nvim_feedkeys(keys,'m',false)
    end)
end

-- \dp = delete ct:pal
mp.nnoremap_b("<Leader>dp", [[:%g/ct:pal\(\)/d<cr>]])

-- \cp = copy module/function under cursor
mp.nnoremap_b("<Leader>cp", function()
    clipboard.copy(string.format("%s:%s", buffer.stem(), util.expand("<cword>")))
end)

-- \cr = copy redbug:start for module/function under cursor
-- eg: redbug:start("carshare_server_handler_worker:do_poll -> return", [{time, 300000}]).
mp.nnoremap_b("<Leader>cr", function()
    local text = string.format('redbug:start("%s:%s -> return", [{time, 300000}]).', buffer.stem(), util.expand("<cword>"))
    clipboard.copy(text)
end)

