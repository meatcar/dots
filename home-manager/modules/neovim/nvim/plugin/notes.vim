" TODO: switch to Telescope.nvim from FZF

let s:actions = extend(get(g:, 'fzf_action', {}),
      \ {'ctrl-e': 'edit'})

" from fzf.vim
function! s:ag_to_qf(line, has_column)
  let parts = matchlist(a:line, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
  let dict = {
        \ 'filename': &autochdir ? fnamemodify(parts[1], ':p') : parts[1],
        \ 'lnum': parts[2],
        \ 'text': parts[4]}

  if a:has_column
    let dict.col = parts[3]
  endif
  return dict
endfunction


" Add a header to a note, made of an optional title, and a date stamp
func! notes#header(title)
  let l:wrap = '_'
  let l:title = ''
  if len(a:title) > 0
    let l:title = '# '. a:title
  endif
  " enter the title and timestamp
  exec 'normal! ggO'
        \.l:title . "\<cr>"
        \.l:wrap . strftime('%FT%T%z') . l:wrap . "\<cr>\<cr>"
        \."\<esc>"
endfunc

func! notes#new_note_sink(lines) dict
  echom 'sink lines:' a:lines
  if len(a:lines) < 2
    return
  endif

  let query = a:lines[0]
  let key = a:lines[1]
  let cmd = get(s:actions, key, 'edit')
  let filenames = a:lines[2:]

  echom 'cmd: ' cmd

  if key ==? 'ctrl-e'
    let filepath = self.dir . '/' . strftime('%F-%H%M')
    if len(query) > 0
      let filepath = filepath.'-'. substitute(query, ' ', '-', 'g')
    endif
    let filepath = filepath.'.md'
    execute join([cmd, fnameescape(filepath)])
    if empty(glob(filepath))
      call notes#header(query)
    endif
  elseif !empty(filenames)
    let candidates = []
    for filename in filenames
      call self.sink_opener(cmd, filename)
    endfor
  endif
endfunc

func! notes#find(dir, fullscreen)
  let spec = {
        \ 'options': [
        \   '--phony',
        \   '--print-query',
        \   '--ansi',
        \   '--multi',
        \   '--tiebreak=' . 'length,begin',
        \   '--expect='.join(keys(s:actions), ','),
        \   '--bind', 'alt-a:select-all,alt-d:deselect-all'
        \ ],
        \ 'dir': expand($NOTES_DIR.'/'.a:dir)
        \}
  let spec = fzf#vim#with_preview(spec)
  let spec['options'] = add(spec['options'], '--preview-window=down:70%')

  let wrapped = fzf#wrap(spec)

  let wrapped['sink*'] = function('notes#new_note_sink')
  function! wrapped.sink_opener(cmd, filename)
    execute join([a:cmd, fnameescape(a:filename)])
  endfunction

  call fzf#run(fzf#wrap('note-files', wrapped, a:fullscreen))
endfunc


func! notes#grep(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {
        \ 'options': [
        \   '--phony',
        \   '--query', a:query,
        \   '--print-query',
        \   '--ansi',
        \   '--multi',
        \   '--tiebreak=' . 'length,begin',
        \   '--expect='.join(keys(s:actions), ','),
        \   '--bind', 'alt-a:select-all,alt-d:deselect-all,change:reload:'.reload_command
        \ ],
        \ 'dir': $NOTES_DIR
        \}
  let spec = fzf#vim#with_preview(spec)
  let spec['options'] = add(spec['options'], '--preview-window=down:70%')

  let wrapped = fzf#wrap(spec)

  let wrapped['sink*'] = function('notes#new_note_sink')
  function! wrapped.sink_opener(cmd, filename)
      let parts = s:ag_to_qf(a:filename, 0)
      echom 'filename' a:filename
      echom 'parts' parts
    execute join([a:cmd, fnameescape(a:filename)])
  endfunction

  try
    let prev_cmd = $FZF_DEFAULT_COMMAND
    let $FZF_DEFAULT_COMMAND = initial_command
    call fzf#run(fzf#wrap('note-grep', wrapped, a:fullscreen))
  finally
    let $FZF_DEFAULT_COMMAND = prev_cmd
  endtry
endfunc

func! notes#journal(...)
  let l:fname = expand($NOTES_DIR.'/journal/').strftime('%F').'.md'
  exec 'e '.l:fname
  if empty(glob(l:fname))
    call notes#header('')
  endif
endfunc

command! -nargs=* NoteNew call notes#edit(<f-args>)
command! -nargs=* -bang NoteFind call notes#find(<q-args>, <bang>0)
command! -nargs=* -bang NoteRg call notes#grep(<q-args>, <bang>0)
command! NoteJournal call notes#journal()
