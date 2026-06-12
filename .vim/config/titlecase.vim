" ~/.vim/config/titlecase.vim

function! TitleCaseRange() range abort
  silent keepjumps keeppatterns execute a:firstline . ',' . a:lastline . 's/\v<(\a)(\a*)>/\u\1\L\2\E/g'
endfunction

" Visual mode: Title Case selected lines/text
xnoremap <silent> <leader>tc :call TitleCaseRange()<CR>

" Optional: Visual mode sort selected lines alphabetically
xnoremap <silent> <leader>S :sort i<CR>

" Optional: Title Case and then sort selected lines
xnoremap <silent> <leader>tS :call TitleCaseRange()<CR>gv:sort i<CR>
