return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = true,
    opts = {
      panel = {
        enabled = false
      }
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",                                                                    -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim",                                                       -- Optional: For using slash commands
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
      { "stevearc/dressing.nvim",                    opts = {} },                            -- Optional: Improves `vim.ui.select`
    },
    config = true,
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
    },
    keys = {
      { "<leader>oaa",     "<cmd>CodeCompanionActions<cr>",     mode = { 'n', 'v' }, desc = "Actions" },
      { "<leader>oac",     "<cmd>CodeCompanionChat toggle<cr>", mode = { 'n', 'v' }, desc = "Chat" },
      { "<localleader>aa", "<cmd>CodeCompanionChat Add<cr>",    mode = { "v" } },
    }

  },
}
