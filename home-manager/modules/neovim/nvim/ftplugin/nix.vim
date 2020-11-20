" Update fetcher under cursor, note that this might take a little while if the
" fetched path is large.
function! UpdateNixFetcher()
  " preserve the cursor location with filters
  let w = winsaveview()
  execute "%!update-nix-fetchgit --location=" . line(".") . ":" . col(".")
  call winrestview(w)
endfunction

function! s:bind_nix_keys()
  nmap <buffer><nowait> <localleader>u :call UpdateNixFetcher()<CR>
  vmap <buffer><nowait> <localleader>u :call UpdateNixFetcher()<CR>
endfunction

augroup filetype_nix
  autocmd!
  autocmd FileType nix call s:bind_nix_keys()
augroup END
