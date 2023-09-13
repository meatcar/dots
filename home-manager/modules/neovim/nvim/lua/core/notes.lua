local fn = vim.fn
local M = {
  NOTES_DIR = fn.expand(fn.environ().NOTES_DIR, true, false) --[[@as string]]
}

--- Create a new note
--- @param name? string
function M.note_new(name)
  local date = fn.strftime('%F-%H%M%z')
  if name then
    name = string.format('%s_%s', date, string.gsub(name, ' ', '-'))
  else
    name = date
  end
  fn.execute('e ' .. string.format('%s/%s.md', M.NOTES_DIR, name))
end

--- Find a note by name and prefix
--- @param prefix? string
function M.note_find(prefix)
  require('telescope.builtin').find_files({
    cwd = M.NOTES_DIR,
    search_dirs = { prefix },
    prompt_title = 'Find Notes',
  })
end

--- Search note by prefix
--- @param prefix? string
function M.note_grep(prefix)
  require('telescope.builtin').live_grep({
    cwd = M.NOTES_DIR,
    search_dirs = { prefix },
    prompt_title = 'Grep Notes',
  })
end

---------------------------
-- Journal
M.JOURNAL_DIR = M.NOTES_DIR .. '/journal'
M.JOURNAL_DAILY_DIR = M.JOURNAL_DIR .. '/daily'

--- Open existing file, populate it with template if empty.
--- @param dir string
--- @param file string
--- @param template? string
local function open_or_load_template(dir, file, template)
  template = template or 'template.md'
  local file_path = string.format('%s/%s', dir, file)
  fn.execute('e ' .. file_path)
  if fn.empty(fn.glob(file_path)) then
    -- TODO: process the template, replace date & time fields.
    -- TODO: move tasks over?
    fn.execute('r ' .. string.format("%s/%s", dir, template))
  end
end

--- @param file? string
function M.journal_daily(file)
  file = file or (fn.strftime('%F') .. '.md')
  open_or_load_template(M.JOURNAL_DAILY_DIR, file)
end

---------------------------
-- Commands

--- Build a completion function to return nested files/dirs
--- using an optional prefix
--- @param root_dir? string
--- @return fun(lead: string): table<string>
local function complete_notes_dirs(root_dir)
  root_dir = root_dir or M.NOTES_DIR
  root_dir = root_dir .. '/'

  --- @return table<string> completions
  return function(lead)
    local shortpaths = {}
    local fullpaths = fn.globpath(root_dir, lead .. '*', false, true)
    for _, path in ipairs(fullpaths) do
      local short = string.gsub(path, root_dir, '', 1)
      table.insert(shortpaths, short)
    end
    return shortpaths
  end
end

vim.api.nvim_create_user_command('NoteNew',
  function(opts)
    M.note_new(opts.fargs[1])
  end,
  { nargs = '?', desc = 'Create new note', })

vim.api.nvim_create_user_command('NoteFind',
  function(opts)
    M.note_find(opts.fargs[1])
  end,
  {
    complete = complete_notes_dirs(),
    nargs = '?',
    desc = 'Find a note',
  })

vim.api.nvim_create_user_command('NoteGrep',
  function(opts)
    M.note_grep(opts.fargs[1])
  end,
  {
    complete = complete_notes_dirs(),
    nargs = '?',
    desc = 'Search text across all notes',
  })

vim.api.nvim_create_user_command('JournalDaily',
  function(opts)
    M.journal_daily(opts.fargs[1])
  end,
  {
    complete = complete_notes_dirs(M.JOURNAL_DAILY_DIR),
    nargs = '?',
    desc = 'Open or create daily journal entry',
  })

return M
