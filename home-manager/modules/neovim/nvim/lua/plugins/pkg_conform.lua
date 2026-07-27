return {
  {
    'stevearc/conform.nvim',
    event = me.o.events.buf_early,
    cmd = { 'ConformInfo' },
    opts = function()
      local util = require('conform.util')

      --- Return the first formatter that is available for this buffer, or nil.
      --- Availability is config-driven: every JS/TS formatter below sets
      --- `require_cwd`, so "available" means "this project actually configures
      --- it" rather than "the binary exists somewhere on $PATH".
      ---@param bufnr integer
      ---@param ... string
      ---@return string|nil
      local function pick(bufnr, ...)
        local conform = require('conform')
        for i = 1, select('#', ...) do
          local formatter = select(i, ...)
          if conform.get_formatter_info(formatter, bufnr).available then
            return formatter
          end
        end
      end

      --- Formatter, then autofixing linter, each resolved independently:
      ---   (oxfmt -> prettierd -> prettier) + (oxlint -> eslint_d)
      --- so an oxfmt+eslint or prettier+oxlint project resolves correctly.
      --- biome is a complete pipeline (format + lint + organize imports), so
      --- it is only consulted when neither half matched. Returning an empty
      --- list lets `lsp_format = "fallback"` hand the buffer to the LSP.
      ---@param bufnr integer
      ---@param opts { lint: boolean, oxfmt: boolean }
      ---@return string[]
      local function web(bufnr, opts)
        local formatters = {}
        local fmt = opts.oxfmt and pick(bufnr, 'oxfmt', 'prettierd', 'prettier')
          or pick(bufnr, 'prettierd', 'prettier')
        local fix = opts.lint and pick(bufnr, 'oxlint', 'eslint_d') or nil

        if fmt then table.insert(formatters, fmt) end
        if fix then table.insert(formatters, fix) end

        if #formatters == 0 then
          local biome = pick(bufnr, 'biome-check')
          if biome then table.insert(formatters, biome) end
        end

        return formatters
      end

      -- Code: formatter + autofixing linter.
      local function js(bufnr) return web(bufnr, { lint = true, oxfmt = true }) end
      -- Data/markup: formatter only, no linter has autofixes worth running.
      local function markup(bufnr) return web(bufnr, { lint = false, oxfmt = true }) end
      -- oxfmt parses these but returns them unchanged, which would starve
      -- prettier of the buffer. Verified against oxfmt 0.57.0.
      local function prettier_only(bufnr) return web(bufnr, { lint = false, oxfmt = false }) end

      return {
        formatters_by_ft = {
          nix = { 'nixfmt' },
          python = { 'isort', 'black', 'autopep8' },
          sh = { 'shfmt' },
          go = { 'gofmt' },
          clojure = { 'joker' },

          javascript = js,
          javascriptreact = js,
          typescript = js,
          typescriptreact = js,
          vue = js,

          css = markup,
          scss = markup,
          less = markup,
          json = markup,
          jsonc = markup,
          yaml = markup,
          markdown = markup,
          graphql = markup,

          html = prettier_only,
          svelte = prettier_only,
        },
        formatters = {
          -- Only claim a buffer when the project opts in. Without this, a
          -- globally-installed oxfmt/prettier wins in every repo and silently
          -- overrides whatever that project actually configured.
          oxfmt = {
            -- Deliberately narrower than conform's built-in list, which also
            -- matches vite.config.{ts,js} and so would fire in any Vite
            -- project that has never heard of oxfmt.
            cwd = util.root_file({ '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' }),
            require_cwd = true,
          },
          oxlint = {
            cwd = util.root_file({ '.oxlintrc.json' }),
            require_cwd = true,
          },
          prettier = { require_cwd = true },
          prettierd = { require_cwd = true },
          eslint_d = {
            -- Built-in cwd is root_file({ "package.json" }), which matches any
            -- JS project whether or not ESLint is configured.
            cwd = util.root_file({
              'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
              'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
              '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.mjs',
              '.eslintrc.json', '.eslintrc.yml', '.eslintrc.yaml',
            }),
            require_cwd = true,
          },
          ['biome-check'] = { require_cwd = true },
        },
        default_format_opts = {
          lsp_format = 'fallback',
        },
        format_after_save = {},
      }
    end,
    init = function()
      vim.o.formatexpr = [[ v:lua.require'conform'.formatexpr() ]]
    end,
  }
}
