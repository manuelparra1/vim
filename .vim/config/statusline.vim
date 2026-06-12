" ~/.vim/config/statusline.vim

set laststatus=2
set noshowmode

function! SetupPowerlineHighlights() abort
  highlight PlFile       guibg=#313244 guifg=#89b4fa
  highlight PlFileSep    guibg=#181825 guifg=#313244
  highlight PlGap        guibg=#181825 guifg=#cdd6f4
  highlight PlType       guibg=#313244 guifg=#6c7086
  highlight PlTypeSep    guibg=#181825 guifg=#313244

  highlight PlModeNormal guibg=#89b4fa guifg=#11111b gui=bold
  highlight PlSepNormal  guibg=#313244 guifg=#89b4fa
  highlight PlPosNormal  guibg=#89b4fa guifg=#11111b gui=bold

  highlight PlModeInsert guibg=#a6e3a1 guifg=#11111b gui=bold
  highlight PlSepInsert  guibg=#313244 guifg=#a6e3a1
  highlight PlPosInsert  guibg=#a6e3a1 guifg=#11111b gui=bold

  highlight PlModeVisual guibg=#cba6f7 guifg=#11111b gui=bold
  highlight PlSepVisual  guibg=#313244 guifg=#cba6f7
  highlight PlPosVisual  guibg=#cba6f7 guifg=#11111b gui=bold

  highlight PlModeCommand guibg=#f9e2af guifg=#11111b gui=bold
  highlight PlSepCommand  guibg=#313244 guifg=#f9e2af
  highlight PlPosCommand  guibg=#f9e2af guifg=#11111b gui=bold

  highlight PlModeReplace guibg=#f38ba8 guifg=#11111b gui=bold
  highlight PlSepReplace  guibg=#313244 guifg=#f38ba8
  highlight PlPosReplace  guibg=#f38ba8 guifg=#11111b gui=bold
endfunction

function! GetModeInfo() abort
  let l:m = mode()

  if l:m =~# '^i'
    return [' INSERT ', 'Insert']
  elseif l:m ==# 'v'
    return [' VISUAL ', 'Visual']
  elseif l:m ==# 'V'
    return [' V-LINE ', 'Visual']
  elseif l:m ==# "\<C-v>"
    return [' V-BLOCK ', 'Visual']
  elseif l:m =~# '^R'
    return [' REPLACE ', 'Replace']
  elseif l:m ==# 'c'
    return [' COMMAND ', 'Command']
  else
    return [' NORMAL ', 'Normal']
  endif
endfunction

function! MyStatusline() abort
  let l:info = GetModeInfo()
  let l:mode_name = l:info[0]
  let l:mode_group = l:info[1]

  return '%#PlMode' . l:mode_group . '#' . l:mode_name .
        \ '%#PlSep' . l:mode_group . '#' .
        \ '%#PlFile# %f %m%r ' .
        \ '%#PlFileSep#' .
        \ '%#PlGap#%=' .
        \ '%#PlTypeSep#' .
        \ '%#PlType# %y  %p%% ' .
        \ '%#PlSep' . l:mode_group . '#' .
        \ '%#PlPos' . l:mode_group . '# %l:%c '
endfunction

call SetupPowerlineHighlights()
set statusline=%!MyStatusline()

augroup PowerlineRefresh
  autocmd!
  autocmd ColorScheme * call SetupPowerlineHighlights()
augroup END
