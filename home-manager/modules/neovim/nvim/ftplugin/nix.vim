" Update fetcher under cursor, note that this might take a little while if the
" fetched path is large.
function! UpdateNixFetcher()
  " preserve the cursor location with filters
  let w = winsaveview()
  execute '%!update-nix-fetchgit --location=' . line('.') . ':' . col('.')
  call winrestview(w)
endfunction

nmap <buffer> <localleader>u :call UpdateNixFetcher()<CR>
vmap <buffer> <localleader>u :call UpdateNixFetcher()<CR>
