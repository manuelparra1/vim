" ~/.vim/config/keymaps.vim

inoremap jk <Esc>
vnoremap jk <Esc>

nnoremap <leader>nh :nohlsearch<CR>
nnoremap <leader>f :find **/*

nnoremap <expr> p SmartPaste(1)
nnoremap <expr> P SmartPaste(0)

" Maps <Leader>p to format the current file and reload it
nnoremap <Leader>p :w<CR>:!prettier -w %<CR>:edit<CR>

" In visual mode, 'x' cuts the selection to the system clipboard
vnoremap x "+d
" In visual mode, 'p' pastes from the system clipboard
vnoremap p "+p

function! SafeWrite()
  if expand('%:t') ==# ''
    echohl WarningMsg
    echo "Cannot save an unnamed buffer!"
    echohl None
  else
    write
  endif
endfunction

nnoremap <leader>w :call SafeWrite()<CR>

" Insert date: M/D/YY
inoremap <C-d> <C-r>=strftime('%-m/%-d/%y')<CR>
