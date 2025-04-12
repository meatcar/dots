--- Run the first formatter
--- source: https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#run-the-first-available-formatter-followed-by-more-formatters
---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

return {
  {
    'stevearc/conform.nvim',
    event = me.o.events.buf_early,
    cmd = { 'ConformInfo' },
    opts = {
      formatters_by_ft = {
        nix = { 'alejandra' },
        python = { 'isort', 'black', 'autopep8' },
        javascript = function(bufnr)
          return { first(bufnr, 'prettierd', 'prettier'), first(bufnr, 'eslint_d', 'eslint') }
        end,
        css = { 'prettierd', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        go = { 'gofmt' },
        clojure = { 'joker' },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_after_save = {},
    },
    init = function()
      vim.o.formatexpr = [[ v:lua.require'conform'.formatexpr() ]]
    end,
  }
}
