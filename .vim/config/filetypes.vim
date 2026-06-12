" ~/.vim/config/filetypes.vim

syntax on
filetype plugin indent on

augroup MarkdownSettings
  autocmd!
  autocmd FileType markdown setlocal wrap linebreak
  autocmd FileType markdown setlocal conceallevel=2
augroup END

colorscheme mocha
