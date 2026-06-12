" ~/.vim/config/number_lines.vim

function! NumberSelectedLines() range abort
  let l:num = 1

  for l:lnum in range(a:firstline, a:lastline)
    call setline(l:lnum, l:num . '. ' . getline(l:lnum))
    let l:num += 1
  endfor
endfunction

xnoremap <silent> <leader>nl :call NumberSelectedLines()<CR>
