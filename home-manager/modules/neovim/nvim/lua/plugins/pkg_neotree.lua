return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = { 'MunifTanjim/nui.nvim', },
    cmd = 'Neotree',
    keys = {
      { '<leader>of', '<cmd>Neotree<CR>',                          desc = 'Filetree' },
      { '<leader>tf', '<cmd>Neotree toggle<CR>',                   desc = 'Filetree' },
      { '<leader>ft', '<Cmd>Neotree filesystem reveal_file=%<CR>', desc = 'Reveal file in tree' },
    },
    event = 'BufEnter neo-tree*',
    init = function()
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
    end,
    opts = {
      hijack_netrw_behavior = 'disabled',
      add_blank_line_at_top = false,
      auto_clean_after_session_restore = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      source_selector = {
        winbar = true,
        statusline = false,
        sources = {
          { source = 'filesystem', display_name = ' 󰉓  F ' },
          { source = 'buffers', display_name = ' 󱒋  B ' },
          { source = 'git_status', display_name = ' 󰊢  G ' },
          { source = 'document_symbols', display_name = ' 󱘎  S ' },
        },
        content_layout = 'center',
        tabs_layout = 'equal',
        truncation_character = '…',
        tabs_min_width = nil,
        tabs_max_width = nil,
        padding = 0,
      },
    },
  }
}
