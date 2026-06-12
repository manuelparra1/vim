" ~/.vim/config/llm_keymaps.vim

" Main study prompt with OpenRouter DeepSeek reasoning
"xnoremap <silent> <leader>no :<C-u>silent call LLMVisual('openrouter_mimo', 'study_concise')<CR>
xnoremap <silent> <leader>no :<C-u>silent call LLMVisual('openrouter_mimo', 'chatbox')<CR>

" Simple rewrite
xnoremap <silent> <leader>nr :<C-u>call LLMVisual('openrouter_mimo', 'rewrite_simple')<CR>

" Code-only prompt
xnoremap <silent> <leader>ct :<C-u>call LLMVisual('openrouter_mimo', 'code_only')<CR>

" Cerebras test
xnoremap <silent> <leader>nc :<C-u>silent call LLMVisual('cerebras_gpt_oss', 'study_concise')<CR>

