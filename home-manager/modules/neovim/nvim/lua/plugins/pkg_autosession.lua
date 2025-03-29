return {

  { -- associate sessions with cwd
    'rmagatti/auto-session',
    lazy = false,
    keys = {
      { '<leader>vss', '<cmd>SessionSave<CR>',        desc = 'Save' },
      { '<leader>vsd', '<cmd>SessionDelete<CR>',      desc = 'Delete' },
      { '<leader>vsA', '<cmd>Autosession delete<CR>', desc = 'Pick to delete' },
      { '<leader>vsa', '<cmd>Autosession delete<CR>', desc = 'Pick to restore' },
      { '<leader>vsp', '<cmd>SessionPurge<CR>',       desc = 'Purge non-existing' },
    },
    init = function()
      require('which-key').add({ '<leader>vs', group = 'session' })

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
          elseif vim.fn.argc() > 0 then
            print("skipping auto-session, args detected")
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

      local function purge_sessions()
        local auto_session = require 'auto-session'
        local to_purge = {}
        for _, session in ipairs(auto_session.get_session_files()) do
          assert(session.display_name, "Session has no 'display_name' field") -- in case of API change
          if session.display_name:find('^/.*') and vim.fn.isdirectory(session.display_name) == 0 then
            table.insert(to_purge, session.display_name)
          end
        end
        for _, name in ipairs(to_purge) do
          vim.notify("Purging session " .. name, vim.log.info)
          auto_session.DeleteSessionByName(name)
        end
        if #to_purge == 0 then
          vim.notify("Nothing to purge", vim.log.info)
        end
      end
      vim.api.nvim_create_user_command('SessionPurge', purge_sessions, { desc = "Purge orphaned sessions" })
    end,
    config = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      ---@diagnostic disable-next-line: missing-fields
      require('auto-session').setup {
        use_git_branch = true,
        pre_save_cmds = { 'Neotree close', function()
          require('neogit').close()
        end, function()
          -- for barbar.nvim
          vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' })
        end },
        session_lens = {
          load_on_setup = false,
        }
      }
    end,
  }
}
