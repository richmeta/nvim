local M = {}

M.is_mac = (vim.fn.has('mac') == 1)
M.is_win = (vim.fn.has('win32') == 1)
M.is_unix = (vim.fn.has('unix') == 1)
M.home_dir = vim.env.HOME
M.nvim_config_dir = vim.fn.stdpath("config")

return M
