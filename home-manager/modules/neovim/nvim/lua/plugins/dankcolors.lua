return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#111318',
				base01 = '#111318',
				base02 = '#77797b',
				base03 = '#77797b',
				base04 = '#262728',
				base05 = '#d4d6d9',
				base06 = '#d4d6d9',
				base07 = '#d4d6d9',
				base08 = '#ad516b',
				base09 = '#ad516b',
				base0A = '#4f6eaf',
				base0B = '#429f50',
				base0C = '#8a9bbc',
				base0D = '#4f6eaf',
				base0E = '#d3e2ff',
				base0F = '#d3e2ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#77797b',
				fg = '#d4d6d9',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#4f6eaf',
				fg = '#111318',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#77797b' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#8a9bbc', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#d3e2ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#4f6eaf',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#4f6eaf',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#8a9bbc',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#429f50',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#262728' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#262728' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#77797b',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
