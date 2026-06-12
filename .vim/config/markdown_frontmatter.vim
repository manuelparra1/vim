" =========================
" Markdown Frontmatter
" =========================

augroup MarkdownFrontmatter
  autocmd!
  autocmd BufWritePre *.md call s:EnsureMarkdownFrontmatter()
augroup END

function! s:NowIso() abort
  return strftime('%Y-%m-%dT%H:%M:%S')
endfunction

function! s:SlugFromFilename() abort
  let l:name = expand('%:t:r')
  let l:id = tolower(l:name)
  let l:id = substitute(l:id, '[^a-z0-9_-]\+', '_', 'g')
  let l:id = substitute(l:id, '_\+', '_', 'g')
  let l:id = substitute(l:id, '^_', '', '')
  let l:id = substitute(l:id, '_$', '', '')
  return l:id
endfunction

function! s:TitleFromFilename() abort
  let l:name = substitute(expand('%:t:r'), '[_-]\+', ' ', 'g')
  return substitute(l:name, '\<\w', '\u&', 'g')
endfunction

function! s:GetFrontmatterEnd() abort
  if getline(1) !=# '---'
    return 0
  endif

  for lnum in range(2, line('$'))
    if getline(lnum) ==# '---'
      return lnum
    endif
  endfor

  return 0
endfunction

function! s:GetMarkdownH1(start_lnum) abort
  for lnum in range(a:start_lnum, line('$'))
    let l:line = getline(lnum)

    if l:line =~# '^#\s\+'
      return substitute(l:line, '^#\s\+', '', '')
    endif
  endfor

  return ''
endfunction

function! s:GetScalar(fm, key) abort
  for l:line in a:fm
    if l:line =~# '^' . a:key . ':\s*'
      return substitute(l:line, '^' . a:key . ':\s*', '', '')
    endif
  endfor

  return ''
endfunction

function! s:GetBlock(fm, key) abort
  let l:i = 0

  while l:i < len(a:fm)
    if a:fm[l:i] =~# '^' . a:key . ':\s*'
      let l:start = l:i
      let l:i += 1

      while l:i < len(a:fm) && a:fm[l:i] !~# '^\S[^:]*:\s*'
        let l:i += 1
      endwhile

      return a:fm[l:start : l:i - 1]
    endif

    let l:i += 1
  endwhile

  return []
endfunction

function! s:TopKey(line) abort
  if a:line =~# '^\S[^:]*:'
    return matchstr(a:line, '^\S[^:]*\ze:')
  endif

  return ''
endfunction

function! s:ExtraBlocks(fm, managed_keys) abort
  let l:out = []
  let l:i = 0

  while l:i < len(a:fm)
    let l:start = l:i
    let l:key = s:TopKey(a:fm[l:i])
    let l:i += 1

    while l:i < len(a:fm) && a:fm[l:i] !~# '^\S[^:]*:\s*'
      let l:i += 1
    endwhile

    if index(a:managed_keys, l:key) < 0
      call extend(l:out, a:fm[l:start : l:i - 1])
    endif
  endwhile

  return l:out
endfunction

function! s:EnsureMarkdownFrontmatter() abort
  let l:now = s:NowIso()
  let l:id = s:SlugFromFilename()

  let l:fm_end = s:GetFrontmatterEnd()

  if l:fm_end > 0
    let l:fm = getline(2, l:fm_end - 1)
    let l:body_start = l:fm_end + 1
  else
    let l:fm = []
    let l:body_start = 1
  endif

  let l:created = s:GetScalar(l:fm, 'created')
  if empty(l:created)
    let l:created = l:now
  endif

  let l:title = s:GetMarkdownH1(l:body_start)
  if empty(l:title)
    let l:title = s:GetScalar(l:fm, 'title')
  endif
  if empty(l:title)
    let l:title = s:TitleFromFilename()
  endif

  let l:aliases = s:GetBlock(l:fm, 'aliases')
  if empty(l:aliases)
    let l:aliases = ['aliases: []']
  endif

  let l:tags = s:GetBlock(l:fm, 'tags')
  if empty(l:tags)
    let l:tags = ['tags: []']
  endif

  let l:managed = ['id', 'aliases', 'tags', 'created', 'modified', 'title']
  let l:extras = s:ExtraBlocks(l:fm, l:managed)

  let l:newfm = ['---']
  call add(l:newfm, 'id: ' . l:id)
  call extend(l:newfm, l:aliases)
  call extend(l:newfm, l:tags)
  call add(l:newfm, 'created: ' . l:created)
  call add(l:newfm, 'modified: ' . l:now)
  call add(l:newfm, 'title: ' . l:title)

  if !empty(l:extras)
    call add(l:newfm, '')
    call extend(l:newfm, l:extras)
  endif

  call add(l:newfm, '---')
  call add(l:newfm, '')

  if l:fm_end > 0
    let l:delete_end = l:fm_end

    if l:fm_end < line('$') && getline(l:fm_end + 1) ==# ''
      let l:delete_end = l:fm_end + 1
    endif

    execute 'silent keepjumps 1,' . l:delete_end . 'delete _'
    call append(0, l:newfm)
  else
    call append(0, l:newfm)
  endif
endfunction
