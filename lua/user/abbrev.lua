local function cabbrev(input, replace)
    local cmd = 'cabbrev %s %s'
    local cmd2 = cmd:format(input, replace)
    vim.cmd(cmd2)
end

-- cs = colorscheme[c]
cabbrev("cs", "colorscheme")

-- T = tabedit[c]
cabbrev("T", "tabedit")

-- some common path abbreviations
cabbrev("_config", "~/.config")
cabbrev("_sshconfig", "~/.ssh/config")
