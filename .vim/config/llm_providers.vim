" ~/.vim/config/llm_providers.vim

let g:llm_providers = get(g:, 'llm_providers', {})

let g:llm_providers.openrouter_mimo = {
      \ 'base_url': 'https://openrouter.ai/api/v1/chat/completions',
      \ 'api_key_env': 'OPENROUTER_API_KEY',
      \ 'model': 'xiaomi/mimo-v2.5',
      \ 'temperature': 0.7,
      \ 'reasoning': {'effort': 'high'}
      \ }

let g:llm_providers.openrouter_gpt_oss = {
      \ 'base_url': 'https://openrouter.ai/api/v1/chat/completions',
      \ 'api_key_env': 'OPENROUTER_API_KEY',
      \ 'model': 'openai/gpt-oss-120b',
      \ 'temperature': 0.7
      \ }

let g:llm_providers.cerebras_gpt_oss = {
      \ 'base_url': 'https://api.cerebras.ai/v1/chat/completions',
      \ 'api_key_env': 'CEREBRAS_API_KEY',
      \ 'model': 'gpt-oss-120b',
      \ 'temperature': 0.85,
      \ 'extra': {
      \   'max_tokens': 32768,
      \   'top_p': 1,
      \   'reasoning_effort': 'high'
      \ }
      \ }
