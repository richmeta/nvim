
return {
    config = function() 
        local actions = require('telescope.actions')

        telescope.setup{            
            defaults = {
                path_display = { "absolute" },      -- TODO: try smart
                preview = false,
                layout_strategy = "bottom_pane",
                layout_config = {
                    bottom_pane = {
                        height = 15,
                        prompt_position = "bottom"
                    }
                },
                -- file_ignore_patterns = {},
                mappings = {
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<esc>"] = actions.close,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-t>"] = actions.select_tab,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-w>"] = actions.send_selected_to_qflist,
                        ["<C-q>"] = actions.send_to_qflist,
                        ["<F7>"] = actions.delete_buffer
                    }
                }

            },
            pickers = {
            },
            extensions = {
                -- TODO: try out this extension
                -- https://github.com/cljoly/telescope-repo.nvim
            }
        }
    end
}
