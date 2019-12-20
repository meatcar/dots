set laststatus=2

" for vim-line-no-indicator
let g:line_no_indicator_chars = ['⎺', '⎻', '─', '⎼', '⎽']

function! StatusBranchName()
   if fugitive#head() != ""
      return " ".fugitive#head()
   else
      return ""
   endif
endfunction

function! StatusEncoding()
  let l:enc = &fenc!=#"" ? &fenc : &enc
  return l:enc == "utf-8" ? "" : l:enc
endfunction

function! StatusFileType()
  if &filetype == ""
    return "no ft"
  elseif &filetype == "help"
    return ":h"
  elseif exists("g:webdevicons_enable") && g:webdevicons_enable == 1
    return WebDevIconsGetFileTypeSymbol()
  else
    return &filetype
  endif
endfunction

function! StatusFileFormat()
  if &fileformat == "unix"
    return ""
  elseif exists("g:webdevicons_enable") && g:webdevicons_enable == 1
    return WebDevIconsGetFileFormatSymbol()
  else
    return &fileformat
  endif
endfunction

function! StatusModified()
   return &modified ? '*' : ''
endfunction

function! StatusReadonly()
  if &readonly && exists("g:webdevicons_enable") && g:webdevicons_enable == 1
    return ""
  elseif &readonly
    return "RO"
  else
    return ""
  endif
endfunction

function! StatusALEWarnings()
   let l:counts = ale#statusline#Count(bufnr(''))
   let l:warnings = l:counts.total - l:counts.error - l:counts.style_error
   return l:warnings == 0 ? '' : l:warnings
endfunction

function! StatusALEErrors()
   let l:counts = ale#statusline#Count(bufnr(''))
   let l:errors = l:counts.error + l:counts.style_error
   return l:errors == 0 ? '' : l:errors
endfunction

function! Statusline(active) abort
    let l:line=''
    let l:line.='%* %{mode()} '
    let l:line.='%#CursorLine#'
    let l:line.='%( %{&paste?"paste":""}%)'
    let l:line.='%( %{&spell?"spell":""}%)'
    let l:line.='%='
    if a:active
      let l:line.='%#Visual#'
    else
      let l:line.='%*'
    endif
    let l:line.=' %{StatusFileType()}'
    if winwidth(0) < 80
      let l:line.=' %t'
    else
      let l:line.=' %f'
    endif
    let l:line.='%( %{StatusReadonly()}%)'
    let l:line.=' '
    let l:line.='%#DiffAdd#%( %{StatusModified()} %)%*'
    let l:line.='%#CursorLine#'
    let l:line.='%<'
    let l:line.='%='
    let l:line.='%#ALEWarningLine#%( %{StatusALEWarnings()} %)%*'
    let l:line.='%#ALEErrorLine#%( %{StatusALEErrors()} %)%*'
    let l:line.='%*'
    let l:line.='%( %{StatusBranchName()}%)'
    let l:line.='%( %{StatusEncoding()}%)'
    let l:line.='%( %{StatusFileFormat()}%)'
    let l:line.=' %l/%L'
    if exists('*LineNoIndicator')
      let l:line.=' %{LineNoIndicator()}'
    endif
    let l:line.=' '
    return l:line
endfunction

function! AssignStatuslines()
  let l:active   = Statusline(1)
  let l:inactive = Statusline(0)
  let l:curwin = winnr()
  for w in range(1, winnr('$'))
    if w == l:curwin
      call setwinvar(w, '&statusline', l:active)
    else
      call setwinvar(w, '&statusline', l:inactive)
    endif
  endfor
endfunction

augroup statusline
  autocmd!
  autocmd WinEnter,BufEnter,SessionLoadPost * call AssignStatuslines()
augroup END

call AssignStatuslines()

