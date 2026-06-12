" ~/.vim/config/clipboard.vim

let g:last_vim_yank_to_clipboard = ''

function! MirrorYankToClipboard(event) abort
  if a:event.operator !=# 'y'
    return
  endif

  let l:reg = a:event.regname ==# '' ? '0' : a:event.regname

  call setreg('+', getreg(l:reg), getregtype(l:reg))
  let g:last_vim_yank_to_clipboard = getreg('+')
endfunction

function! SmartPaste(after) abort
  if getreg('+') !=# g:last_vim_yank_to_clipboard && getreg('+') !=# ''
    return '"+' . (a:after ? 'p' : 'P')
  endif

  return a:after ? 'p' : 'P'
endfunction

augroup SmartClipboard
  autocmd!
  autocmd TextYankPost * call MirrorYankToClipboard(v:event)
augroup END
