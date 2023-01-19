_G.StatusColumn = {
  handler = {
    fold = function()
      local lnum = vim.fn.getmousepos().line

      -- Only lines with a mark should be clickable
      if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
        return
      end

      local state
      if vim.fn.foldclosed(lnum) == -1 then
        state = 'close'
      else
        state = 'open'
      end

      vim.cmd.execute("'" .. lnum .. 'fold' .. state .. "'")
    end,
    sign = function()
      require('gitsigns').preview_hunk()
    end,
  },

  display = {
    fold = function()
      local icon = '  '
      local lnum = vim.v.lnum

      if vim.v.virtnum > 0 then
        return '↳ '
      end

      -- Line isn't in folding range
      if vim.fn.foldlevel(lnum) <= 0 then
        return icon
      end

      -- Not the first line of folding range
      if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
        return icon
      end

      if vim.fn.foldclosed(lnum) == -1 then
        icon = ' '
      else
        icon = ' '
      end

      return icon
    end,
  },

  sections = {
    sign_column = {
      [[%@v:lua.StatusColumn.handler.sign@]],
      [[%=%s]],
      [[%T]],
    },
    line_number = {
      [[%=%{v:lua.StatusColumn.display.line()}]],
    },
    spacing = {
      [[ ]],
    },
    folds = {
      [[%=%#FoldColumn#]], -- HL
      [[%@v:lua.StatusColumn.handler.fold@]],
      [[%{v:lua.StatusColumn.display.fold()}]],
      [[%T]],
    },
    border = {
      [[%#StatusColumnBorder#]], -- HL
      [[▐]],
    },
    padding = {
      [[%#StatusColumnBuffer#]], -- HL
      [[ ]],
    },
  },

  build = function(tbl)
    local statuscolumn = {}

    for _, value in ipairs(tbl) do
      if type(value) == 'string' then
        table.insert(statuscolumn, value)
      elseif type(value) == 'table' then
        table.insert(statuscolumn, StatusColumn.build(value))
      end
    end

    return table.concat(statuscolumn)
  end,

  set_window = function(value)
    vim.defer_fn(function()
      vim.api.nvim_win_set_option(vim.api.nvim_get_current_win(), 'statuscolumn', value)
      -- some really long text some really long text some really long text some really long text some really long text some really long text some really long text some really long text some really long text some really long text some really long text some really long text
    end, 1)
  end,
}

vim.opt.signcolumn = 'yes'
vim.opt.statuscolumn = StatusColumn.build {
  StatusColumn.sections.sign_column,
  StatusColumn.sections.folds,
  StatusColumn.sections.spacing,
}
