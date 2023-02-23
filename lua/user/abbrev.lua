local cabbrev = vim.cmd.cabbrev

-- cs = colorscheme[c]
cabbrev("cs", "colorscheme")

-- T = tabedit[c]
cabbrev("T", "tabedit")

-- some common path abbreviations
cabbrev("_config", "~/.config")
cabbrev("_sshconfig", "~/.ssh/config")

if vim.fn.exists("$HOME/scripts") then
    cabbrev("_scripts", "~/scripts")
end
