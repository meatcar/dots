return {

  { -- associate sessions with cwd
    'rmagatti/auto-session',
    keys = {
      { '<leader>vss', '<cmd>SessionSave<CR>',   desc = 'Save' },
      { '<leader>vsd', '<cmd>SessionDelete<CR>', desc = 'Delete' }
    },
    init = function()
      require('which-key').register({ ['<leader>vs'] = { name = 'session' } })

      -- source: https://github.com/rmagatti/auto-session/issues/223#issuecomment-1666658887
      local function auto_session_restore()
        -- important! without vim.schedule other necessary plugins might not load (eg treesitter) after restoring the session
        vim.schedule(function()
          require("auto-session").AutoRestoreSession()
        end)
      end

      vim.api.nvim_create_autocmd("User", {
        group = "me",
        pattern = "VeryLazy",
        callback = function()
          local lazy_view = require("lazy.view")

          if lazy_view.visible() then
            -- if lazy view is visible do nothing with auto-session
            me.o.lazy_did_show_install_view = true
          else
            -- otherwise load (by require'ing) and restore session
            auto_session_restore()
          end
        end,
      })

      vim.api.nvim_create_autocmd("WinClosed", {
        group = "me",
        pattern = "*",
        callback = function(ev)
          local lazy_view = require("lazy.view")

          -- if lazy view is currently visible and was shown at startup
          if lazy_view.visible() and me.o.lazy_did_show_install_view then
            -- if the window to be closed is actually the lazy view window
            if ev.match == tostring(lazy_view.view.win) then
              me.o.lazy_did_show_install_view = false
              auto_session_restore()
            end
          end
        end,
      })
    end,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('auto-session').setup {
        session_lens = {
          load_on_setup = false,
        }
      }
    end,
  }
}
