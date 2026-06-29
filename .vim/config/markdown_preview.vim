" ~/.vim/config/markdown_preview.vim

if exists('g:loaded_md_preview')
  finish
endif
let g:loaded_md_preview = 1

let g:md_preview_files = []

function! PreviewMarkdown() abort
  if &filetype !=# 'markdown'
    echohl WarningMsg
    echo "Not a markdown buffer!"
    echohl None
    return
  endif

  " 1. Define your specific macOS Typora theme paths
  let l:theme_dir = expand('~/Library/Application Support/abnerworks.Typora/themes')
  let l:css_name = 'google-sans-flex.css'
  let l:font_dir_name = 'google-sans-flex'
  let l:orig_css_path = l:theme_dir . '/' . l:css_name

  if !filereadable(l:orig_css_path)
    echohl ErrorMsg
    echo "Could not find theme CSS at: " . l:orig_css_path
    echohl None
    return
  endif

  " 2. Dynamically patch the CSS with absolute paths
  let l:css_lines = readfile(l:orig_css_path)
  let l:abs_font_path = l:theme_dir . '/' . l:font_dir_name
  
  call map(l:css_lines, 'substitute(v:val, ''\.\/'' . l:font_dir_name, l:abs_font_path, ''g'')')
  call map(l:css_lines, 'substitute(v:val, ''#write'', ''body'', ''g'')')

  let l:tmp_css = tempname() . '.css'
  call writefile(l:css_lines, l:tmp_css)

  " 3. Set up the HTML preview file (Creates once per buffer)
  if !exists('b:md_preview_path')
    let b:md_preview_path = tempname() . '.html'
    call add(g:md_preview_files, b:md_preview_path)
  endif

" 4. Pre-process Markdown & Run Pandoc
  " Grab the current buffer and convert ??> into an invisible #q anchor
  let l:md_lines = getline(1, '$')
  call map(l:md_lines, 'substitute(v:val, ''^??>\s*\(.*\)'', ''> [](#q) \1'', '''')')
  
  " Convert <think> and </think> into native HTML5 collapsible blocks
  call map(l:md_lines, 'substitute(v:val, ''<think>'', ''<details class="think-block"><summary>Model Reasoning</summary>'', ''g'')')
  call map(l:md_lines, 'substitute(v:val, ''</think>'', ''</details>'', ''g'')')

  " Write the patched markdown to a temp file
  let l:tmp_md = tempname() . '.md'
  call writefile(l:md_lines, l:tmp_md)
  call add(g:md_preview_files, l:tmp_md) " Ensures Vim deletes this on exit too

  let l:resource_path = expand('%:p:h')
  " NOTICE: We are now passing l:tmp_md to Pandoc instead of expand('%:p')
  let l:cmd = 'pandoc ' . shellescape(l:tmp_md) .
        \ ' --standalone --embed-resources' .
        \ ' --mathjax' .
        \ ' --metadata title=""' .
        \ ' --resource-path=' . shellescape(l:resource_path) .
        \ ' --css ' . shellescape(l:tmp_css) .
        \ ' -o ' . shellescape(b:md_preview_path)

  call system(l:cmd)
  call delete(l:tmp_css)

  if v:shell_error
    echohl ErrorMsg
    echo "Pandoc conversion failed!"
    echohl None
    return
  endif

  " 5. ALWAYS open the file in the browser
  if has('mac')
    call system('open ' . shellescape(b:md_preview_path) . ' &')
  else
    call system('xdg-open ' . shellescape(b:md_preview_path) . ' &')
  endif
  
  echo "Preview compiled and opened!"
endfunction

augroup MarkdownPreviewCleanup
  autocmd!
  autocmd VimLeavePre * call s:CleanupPreviewFiles()
augroup END

function! s:CleanupPreviewFiles() abort
  for l:file in g:md_preview_files
    if filereadable(l:file)
      call delete(l:file)
    endif
  endfor
endfunction

nnoremap <silent> <leader>mp :call PreviewMarkdown()<CR>
