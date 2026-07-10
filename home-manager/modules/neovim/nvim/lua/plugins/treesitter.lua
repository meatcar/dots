return {
  { -- nvim-treesitter/nvim-treesitter (main branch: no lazy-load, no configs.setup)
    'nvim-treesitter/nvim-treesitter',
    name = 'nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- parsers we commonly edit; installed async, idempotent
      require('nvim-treesitter').install {
        'bash', 'c', 'comment', 'css', 'diff', 'dockerfile', 'eex', 'elixir',
        'fish', 'git_rebase', 'gitcommit', 'go', 'gomod', 'hcl', 'heex', 'html',
        'javascript', 'json', 'lua', 'luadoc', 'markdown', 'markdown_inline',
        'nix', 'python', 'query', 'regex', 'ruby', 'rust', 'teal', 'terraform',
        'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'vue', 'yaml',
      }

      -- main has no `highlight.enable`; start per-buffer on FileType and set the
      -- treesitter indentexpr. Auto-install missing-but-available parsers, guarded
      -- with pcall + err check to avoid the picker race upstream warns about.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('me_treesitter', { clear = true }),
        desc = 'treesitter highlight + indent',
        callback = function(ev)
          local buf = ev.buf
          local ft = vim.bo[buf].filetype
          if ft == '' then return end
          local lang = vim.treesitter.language.get_lang(ft) or ft

          local function enable()
            if not vim.api.nvim_buf_is_valid(buf) then return end
            if pcall(vim.treesitter.start, buf, lang) then
              vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end

          local ts = require('nvim-treesitter')
          if vim.list_contains(ts.get_installed('parsers'), lang) then
            enable()
          elseif vim.list_contains(ts.get_available(), lang) then
            ts.install(lang):await(function(err)
              if not err then vim.schedule(enable) end
            end)
          end
        end,
      })

      -- folding via core treesitter (ufo consumes the same folds.scm queries)
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
  },

  -- get the commentstring based on ts context, i.e. vue or jsx files
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false,
    }
  },
  { -- configure comment.nvim to use the context-sensitive commentstring
    'numToStr/Comment.nvim',
    dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
    optional = true,
    opts = function(_, opts)
      opts.pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    end
  },

  -- Syntax aware text-objects: select, move, swap (main branch)
  -- note: lsp_interop/peek_definition_code was removed upstream; <leader>df/dF are gone
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = me.o.events.buf_late,
    init = function()
      vim.g.no_plugin_maps = true -- disable built-in ftplugin maps that may conflict
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V',  -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
        },
        move = { set_jumps = true },
      }

      local select = require('nvim-treesitter-textobjects.select')
      local function sel(lhs, obj)
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(obj, 'textobjects')
        end, { desc = 'select ' .. obj })
      end
      sel('af', '@function.outer')
      sel('if', '@function.inner')
      sel('ac', '@class.outer')
      sel('ic', '@class.inner')
      sel('aa', '@parameter.outer')
      sel('ia', '@parameter.inner')
      sel('ak', '@block.outer')
      sel('ik', '@block.inner')

      local swap = require('nvim-treesitter-textobjects.swap')
      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'swap next parameter' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'swap previous parameter' })
    end,
  },
  { -- close function blocks
    'RRethy/nvim-treesitter-endwise',
    event = me.o.events.insert,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = me.o.events.buf_late,
    keys = {
      { "<leader>tT", ":TSContextToggle<CR>", desc = 'Top TS context' }
    },
    init = function()
      -- TODO: remove workaround once fixed upstream
      -- see: https://github.com/nvim-treesitter/nvim-treesitter-context/issues/670
      -- see: https://github.com/nvim-treesitter/nvim-treesitter-context/pull/674
      vim.g._ts_force_sync_parsing = true
    end,
    opts = {}
  }
}
