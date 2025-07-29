return {
	"akinsho/bufferline.nvim",
	dependencies = { "echasnovski/mini.icons", "famiu/bufdelete.nvim" },
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				numbers = "none",
				close_command = "Bdelete! %d",
				right_mouse_command = "Bdelete! %d",
				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,
				indicator = { icon = "| ", style = "none" },
				buffer_close_icon = "",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 18,
				max_prefix_length = 15,
				tab_size = 18,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = function(count)
					return "(" .. count .. ")"
				end,
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				persist_buffer_sort = true,
				separator_style = "thin",
				enforce_regular_tabs = false,
				always_show_bufferline = true,
				sort_by = "insert_after_current",
			},
			highlights = {
				buffer_selected = {
					bold = true,
					italic = false,
				},
				numbers_selected = {
					bold = true,
					italic = false,
				},
				close_button_selected = {},
				diagnostic_selected = {
					bold = true,
					italic = false,
				},
				hint_selected = {
					bold = true,
					italic = false,
				},
				hint_diagnostic_selected = {
					bold = true,
					italic = false,
				},
				info_selected = {
					bold = true,
					italic = false,
				},
				info_diagnostic_selected = {
					bold = true,
					italic = false,
				},
				warning_selected = {
					bold = true,
					italic = false,
				},
				warning_diagnostic_selected = {
					bold = true,
					italic = false,
				},
				error_selected = {
					bold = true,
					italic = false,
				},
				error_diagnostic_selected = {
					bold = true,
					italic = false,
				},
				duplicate_selected = {},
				duplicate_visible = {},
				duplicate = {},
				pick_selected = {
					bold = true,
					italic = false,
				},
				pick_visible = {
					bold = true,
					italic = false,
				},
				pick = {
					bold = true,
					italic = false,
				},
			},
		})
	end,
}
