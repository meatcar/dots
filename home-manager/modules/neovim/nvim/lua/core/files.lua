--- Telescope picker over every file in a git repo, gitignored included, so
--- `.env` is reachable. A wholly-ignored directory collapses to one stub
--- entry. Type its path in the prompt to expand it; remove the path to
--- collapse it again.

local M = {}

--- Collapsed and expandable like other ignored directories, but get no stub entry.
local VCS = { ['.git/'] = true, ['.jj/'] = true }

--- Keyed by cwd: the git call below runs there. It blocks, and is slowest on
--- repos that ignore nothing.
local cache = {}

--- Drop directories covered by an ancestor: `.jj/` alone stands in for
--- `.jj/repo/` and `.jj/working_copy/`.
--- @param dirs string[]
--- @return string[]
local function topmost(dirs)
  table.sort(dirs)
  local kept = {}
  for _, dir in ipairs(dirs) do
    local parent = kept[#kept]
    if not (parent and dir:sub(1, #parent) == parent) then
      kept[#kept + 1] = dir
    end
  end
  return kept
end

--- Directories git reports as wholly ignored. `--directory` collapses each to
--- one output line instead of a listing of its contents.
--- @return string[] paths relative to cwd, each with a trailing slash
local function collapsed()
  local cwd = vim.uv.cwd()
  if cache[cwd] then return cache[cwd] end

  -- NOTE: quotePath=false, or git quotes non-ASCII names and the
  -- trailing-slash check below misses them
  -- NOTE: vim.system keeps stderr out of stdout; systemlist merges the two, and
  -- a warning ending in `/` would read as an ignored directory
  local git = vim.system({
    'git', '-c', 'core.quotePath=false', 'ls-files',
    '--exclude-standard', '--others', '--ignored', '--directory',
  }, { text = true }):wait()

  local dirs = vim.tbl_keys(VCS)
  if git.code == 0 then
    for line in vim.gsplit(git.stdout or '', '\n', { trimempty = true }) do
      if line:sub(-1) == '/' then dirs[#dirs + 1] = line end
    end
  end

  cache[cwd] = topmost(dirs)
  return cache[cwd]
end

--- @param dirs string[]
--- @param expanded table<string, true>
--- @return string[] argv
local function list_command(dirs, expanded)
  -- NOTE: `--type l` too, or tracked symlinks vanish
  local argv = { 'fd', '--type', 'f', '--type', 'l', '--color', 'never', '--hidden', '--no-ignore' }
  for _, dir in ipairs(dirs) do
    -- NOTE: `=` form keeps a `-lead/` name out of flag parsing; the leading `/`
    -- anchors to the root, so excluding `dist/` cannot prune a tracked `src/dist/`
    if not expanded[dir] then argv[#argv + 1] = '--exclude=/' .. dir end
  end
  return argv
end

--- @param dirs string[]
--- @param expanded table<string, true>
local function finder(dirs, expanded)
  local entry_maker = require('telescope.make_entry').gen_from_file {}

  local stubs = {}
  for _, dir in ipairs(dirs) do
    if not expanded[dir] and not VCS[dir] then
      local entry = entry_maker(dir)
      entry.index = #stubs + 1
      stubs[#stubs + 1] = entry
    end
  end

  local argv = list_command(dirs, expanded)
  return require 'telescope.finders.async_oneshot_finder' {
    results = stubs,
    entry_maker = entry_maker,
    fn_command = function()
      return { command = argv[1], args = vim.list_slice(argv, 2) }
    end,
  }
end

--- True when `prompt` contains `dir` at a path boundary. The trailing slash in
--- `dir` keeps `.gitignore` from expanding `.git/`; the boundary check keeps
--- `bazfoo/` from expanding `foo/`.
--- @param prompt string
--- @param dir string
--- @return true|nil
local function typed(prompt, dir)
  local at = 1
  while true do
    local hit = prompt:find(dir, at, true)
    if not hit then return nil end
    if hit == 1 or prompt:sub(hit - 1, hit - 1) == '/' then return true end
    at = hit + 1
  end
end

--- Open the picker. Expects cwd to be inside a git repo.
function M.picker()
  local conf = require('telescope.config').values
  local dirs = collapsed()
  local expanded = {}

  require('telescope.pickers').new({}, {
    prompt_title = 'Files',
    finder = finder(dirs, expanded),
    sorter = conf.file_sorter {},
    previewer = conf.file_previewer {},
    -- NOTE: recompute expansion in both directions each keystroke, or expanded
    -- contents linger in later searches; rebuild the finder only on change
    on_input_filter_cb = function(prompt)
      local changed = false
      for _, dir in ipairs(dirs) do
        local want = typed(prompt, dir)
        if want ~= expanded[dir] then
          expanded[dir] = want
          changed = true
        end
      end
      if changed then return { updated_finder = finder(dirs, expanded) } end
    end,
  }):find()
end

return M
