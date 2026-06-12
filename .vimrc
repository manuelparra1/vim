" ~/.vimrc

source ~/.vim/config/leader.vim
source ~/.vim/config/options.vim
source ~/.vim/config/clipboard.vim
source ~/.vim/config/search-path.vim
source ~/.vim/config/filetypes.vim
source ~/.vim/config/keymaps.vim
source ~/.vim/config/terminal.vim
source ~/.vim/config/statusline.vim

" LLM Plugin
source ~/.vim/config/llm_prompts.vim
source ~/.vim/config/llm_providers.vim
source ~/.vim/config/llm.vim
source ~/.vim/config/llm_keymaps.vim

" Custom Functions
source ~/.vim/config/markdown_preview.vim
source ~/.vim/config/markdown_frontmatter.vim
source ~/.vim/config/titlecase.vim
source ~/.vim/config/number_lines.vim

" leader.vim      -> before keymaps
" options.vim     -> early defaults
" clipboard.vim   -> defines SmartPaste()
" keymaps.vim     -> maps p/P to SmartPaste()
" filetypes.vim   -> syntax, filetype, colorscheme
" statusline.vim  -> after colorscheme so highlights apply cleanly
