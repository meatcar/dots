return {
  {
    -- Next Edit Suggestions via the copilot LSP.
    -- Inline ghost-text comes from native vim.lsp.inline_completion (nvim 0.12+),
    -- accepted via the <Tab> chain in blink.cmp (see completion.lua).
    'folke/sidekick.nvim',
    event = me.o.events.buf_early,
    dependencies = { 'neovim/nvim-lspconfig' },
    -- NES only; the cli module stays unused, AI chat/agents live outside neovim
    opts = {},
    config = function(_, opts)
      require('sidekick').setup(opts)

      -- the copilot LSP itself is enabled in plugins/lsp.lua
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('me.copilot', {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, args.buf) then
            vim.lsp.inline_completion.enable(true, { bufnr = args.buf })
            vim.keymap.set('i', '<M-]>', function()
              vim.lsp.inline_completion.select({ count = 1 })
            end, { buffer = args.buf, desc = 'Next inline suggestion' })
            vim.keymap.set('i', '<M-[>', function()
              vim.lsp.inline_completion.select({ count = -1 })
            end, { buffer = args.buf, desc = 'Prev inline suggestion' })
          end
        end,
      })
    end,
    keys = {
      {
        '<Tab>',
        function()
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>'
          end
        end,
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
    },
  },
}
