func! notes#edit(...)
  " build the file name
  let l:sep = ''
  if len(a:000) > 0
    let l:sep = '-'
  endif
  let l:fname = expand($NOTES_DIR . '/') . strftime("%F-%H%M") . l:sep . join(a:000, l:sep) . '.md'

  " edit the new file
  exec "e " . l:fname

  let l:wrap = "_"
  let l:title = ''
  if len(a:000) > 0
    let l:title = '# '. join(a:000)
  endif
  " enter the title and timestamp (using ultisnips) in the new file
  exec "normal ggO".l:title."\<cr>".l:wrap."\<C-r>=strftime('%Y-%m-%d %H:%M')\<cr>\<cr>\<esc>G"
endfunc

function! RipgrepNotes(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {
        \ 'options': ['--phony',
        \             '--query', a:query,
        \             '--bind', 'change:reload:'.reload_command],
        \ 'dir': $NOTES_DIR
        \}
  let spec = fzf#vim#with_preview(spec)
  let spec['options'] = add(spec['options'], '--preview-window=down:70%')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -nargs=* NoteNew call notes#edit(<f-args>)
command! -bang NoteRg call RipgrepNotes(<q-args>, <bang>0)
let g:leader_map.n = {'name': '+notes'}
" mnemonic Note Create
map <silent> <leader>nc :NoteNew<space>
" mnemonic Note Notes
map <silent> <leader>nn :FZF <C-r>=$NOTES_DIR<cr><cr>
" mnemonic Note /search
map <silent> <leader>n/ :NoteRg<cr>
