" ~/.vim/config/llm.vim

if exists('g:loaded_simple_llm')
  finish
endif
let g:loaded_simple_llm = 1

let g:llm_openrouter_model = get(g:, 'llm_openrouter_model', 'openai/gpt-oss-120b')
let g:llm_openrouter_api_key_env = get(g:, 'llm_openrouter_api_key_env', 'OPENROUTER_API_KEY')
let g:llm_openrouter_system_prompt = get(g:, 'llm_openrouter_system_prompt',
      \ 'You are an assistant inside Vim. Be concise. Return useful text only.')

function! s:GetVisualSelection() abort
  let l:start = getpos("'<")
  let l:end = getpos("'>")

  let l:start_line = l:start[1]
  let l:start_col = l:start[2]
  let l:end_line = l:end[1]
  let l:end_col = l:end[2]

  if l:start_line > l:end_line
    let [l:start_line, l:end_line] = [l:end_line, l:start_line]
    let [l:start_col, l:end_col] = [l:end_col, l:start_col]
  endif

  let l:lines = getline(l:start_line, l:end_line)

  if visualmode() !=# 'V'
    let l:lines[-1] = strpart(l:lines[-1], 0, l:end_col)
    let l:lines[0] = strpart(l:lines[0], l:start_col - 1)
  endif

  return join(l:lines, "\n")
endfunction

function! s:CleanLines(lines) abort
  let l:lines = copy(a:lines)

  while len(l:lines) > 0 && l:lines[0] =~# '^\s*$'
    call remove(l:lines, 0)
  endwhile

  while len(l:lines) > 0 && l:lines[-1] =~# '^\s*$'
    call remove(l:lines, -1)
  endwhile

  return join(l:lines, "\n")
endfunction

function! s:AddMessage(messages, role, lines) abort
  let l:content = s:CleanLines(a:lines)

  if l:content !=# ''
    call add(a:messages, {
          \ 'role': a:role,
          \ 'content': l:content
          \ })
  endif
endfunction

function! s:ParsePrefixedConversation(text) abort
  let l:lines = split(a:text, "\n", 1)

  let l:messages = []
  let l:context = []
  let l:user = []
  let l:assistant = []

  let l:saw_user = 0
  let l:in_user = 0
  let l:first_user_done = 0

  for l:line in l:lines
    if l:line =~# '^\s*??>'
      " Starting first user block.
      if !l:saw_user
        let l:saw_user = 1
        let l:in_user = 1

      " Starting a new user block after assistant text.
      elseif !l:in_user
        call s:AddMessage(l:messages, 'assistant', l:assistant)
        let l:assistant = []
        let l:user = []
        let l:in_user = 1
      endif

      call add(l:user, substitute(l:line, '^\s*??>\s*', '', ''))

    else
      " Text before the first ??> is context.
      if !l:saw_user
        call add(l:context, l:line)

      " First non-prefixed line after a user block starts assistant text.
      elseif l:in_user
        if !l:first_user_done
          if s:CleanLines(l:context) !=# ''
            let l:first = ['Context:'] + l:context + ['', 'Question:'] + l:user
          else
            let l:first = l:user
          endif

          call s:AddMessage(l:messages, 'user', l:first)
          let l:first_user_done = 1
        else
          call s:AddMessage(l:messages, 'user', l:user)
        endif

        let l:user = []
        let l:in_user = 0
        call add(l:assistant, l:line)

      else
        call add(l:assistant, l:line)
      endif
    endif
  endfor

  " No prefix found: treat the whole selection as one user prompt.
  if !l:saw_user
    call s:AddMessage(l:messages, 'user', l:lines)
    return l:messages
  endif

  " Selection ended while still inside a user block.
  if l:in_user
    if !l:first_user_done
      if s:CleanLines(l:context) !=# ''
        let l:first = ['Context:'] + l:context + ['', 'Question:'] + l:user
      else
        let l:first = l:user
      endif

      call s:AddMessage(l:messages, 'user', l:first)
    else
      call s:AddMessage(l:messages, 'user', l:user)
    endif
  else
    call s:AddMessage(l:messages, 'assistant', l:assistant)
  endif

  if len(l:messages) == 0 || l:messages[-1].role !=# 'user'
    echoerr 'Selection must end with a ??> user question.'
    return []
  endif

  return l:messages
endfunction

function! s:GetProvider(provider_key) abort
  if !exists('g:llm_providers') || !has_key(g:llm_providers, a:provider_key)
    echoerr 'Unknown LLM provider: ' . a:provider_key
    return {}
  endif

  return g:llm_providers[a:provider_key]
endfunction

function! s:GetPrompt(prompt_key) abort
  if !exists('g:llm_prompts') || !has_key(g:llm_prompts, a:prompt_key)
    echoerr 'Unknown LLM prompt: ' . a:prompt_key
    return ''
  endif

  return g:llm_prompts[a:prompt_key]
endfunction

function! LLMVisual(provider_key, prompt_key) abort
  if !executable('curl')
    echoerr 'curl is required'
    return
  endif

  let l:provider = s:GetProvider(a:provider_key)
  if empty(l:provider)
    return
  endif

  let l:system_prompt = s:GetPrompt(a:prompt_key)
  if empty(l:system_prompt)
    return
  endif

  let l:api_key_env = get(l:provider, 'api_key_env', 'OPENROUTER_API_KEY')
  let l:api_key = getenv(l:api_key_env)

  if empty(l:api_key)
    echoerr 'Missing $' . l:api_key_env
    return
  endif

  let l:selected = s:GetVisualSelection()

  if empty(l:selected)
    echoerr 'No visual selection found'
    return
  endif

  let l:conversation = s:ParsePrefixedConversation(l:selected)

  if empty(l:conversation)
    return
  endif

  let l:messages = [
        \ {
        \   'role': 'system',
        \   'content': l:system_prompt
        \ }
        \ ] + l:conversation

  let l:payload = {
        \ 'model': l:provider.model,
        \ 'temperature': get(l:provider, 'temperature', 0.7),
        \ 'stream': v:false,
        \ 'messages': l:messages
        \ }

  if has_key(l:provider, 'reasoning')
    let l:payload.reasoning = l:provider.reasoning
  endif

  if has_key(l:provider, 'extra')
    call extend(l:payload, l:provider.extra, 'force')
  endif

  let l:insert_at = line("'>")
  call append(l:insert_at, ['', 'Thinking...'])
  let l:thinking_line = l:insert_at + 2
  redraw

  let l:payload_file = tempname()
  call writefile([json_encode(l:payload)], l:payload_file)

  let l:url = get(l:provider, 'base_url', 'https://openrouter.ai/api/v1/chat/completions')

  let l:cmd = 'curl -L -sS -X POST ' . shellescape(l:url)
        \ . ' -H ' . shellescape('Authorization: Bearer ' . l:api_key)
        \ . ' -H ' . shellescape('Content-Type: application/json')
        \ . ' --data-binary @' . shellescape(l:payload_file)

  let l:response = systemlist(l:cmd)

  call delete(l:payload_file)

  if v:shell_error
    echoerr join(l:response, "\n")
    return
  endif

  try
    let l:decoded = json_decode(join(l:response, "\n"))
    let l:content = l:decoded.choices[0].message.content
  catch
    echoerr 'Could not parse API response:'
    echoerr join(l:response, "\n")
    return
  endtry

  let l:output = split(l:content, "\n", 1)
  
  if empty(l:output)
    let l:output = ['']
  endif
  
  call setline(l:thinking_line, l:output[0])
  
  if len(l:output) > 1
    call append(l:thinking_line, l:output[1:])
  endif
endfunction

xnoremap <silent> <leader>no :<C-u>call LLMOpenRouterVisual()<CR>
