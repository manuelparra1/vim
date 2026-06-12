" ~/.vim/colors/mocha.vim

highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "mocha"

set termguicolors
set background=dark

" =========================
" Catppuccin Mocha Palette
" =========================
let s:rosewater = "#f5e0dc"
let s:flamingo  = "#f2cdcd"
let s:pink      = "#f5c2e7"
let s:mauve     = "#cba6f7"
let s:red       = "#f38ba8"
let s:maroon    = "#eba0ac"
let s:peach     = "#fab387"
let s:yellow    = "#f9e2af"
let s:green     = "#a6e3a1"
let s:teal      = "#94e2d5"
let s:sky       = "#89dceb"
let s:sapphire  = "#74c7ec"
let s:blue      = "#89b4fa"
let s:lavender  = "#b4befe"
let s:text      = "#cdd6f4"
let s:subtext1  = "#bac2de"
let s:subtext0  = "#a6adc8"
let s:overlay2  = "#9399b2"
let s:overlay1  = "#7f849c"
let s:overlay0  = "#6c7086"
let s:surface2  = "#585b70"
let s:surface1  = "#45475a"
let s:surface0  = "#313244"
let s:base      = "#1e1e2e"
let s:mantle    = "#181825"
let s:crust     = "#11111b"

" =========================
" Helper
" =========================
function! s:HL(group, fg, bg, attr) abort
  let l:cmd = "highlight " . a:group

  if a:fg !=# ""
    let l:cmd .= " guifg=" . a:fg
  endif

  if a:bg !=# ""
    let l:cmd .= " guibg=" . a:bg
  endif

  if a:attr !=# ""
    let l:cmd .= " gui=" . a:attr . " cterm=" . a:attr
  endif

  execute l:cmd
endfunction

" =========================
" Editor UI
" =========================
call s:HL("Normal",       s:text,     s:base,     "")
call s:HL("NormalFloat",  s:text,     s:mantle,   "")
call s:HL("ColorColumn",  "",         s:surface0, "")
call s:HL("Cursor",       s:base,     s:text,     "")
call s:HL("CursorLine",   "",         s:surface0, "")
call s:HL("CursorColumn", "",         s:surface0, "")
call s:HL("LineNr",       s:surface1, s:base,     "")
call s:HL("CursorLineNr", s:yellow,   s:base,     "bold")
call s:HL("SignColumn",   "",         s:base,     "")

" =========================
" Search / Visual
" =========================
call s:HL("Search",    s:base, s:sky,      "bold")
call s:HL("IncSearch", s:base, s:peach,    "bold")
call s:HL("Visual",    "",     s:surface2, "")

" =========================
" Splits / Status
" =========================
call s:HL("VertSplit",    s:surface1, "",        "")
call s:HL("StatusLine",   s:text,     s:mantle,  "")
call s:HL("StatusLineNC", s:surface1, s:mantle,  "")

" =========================
" Messages
" =========================
call s:HL("ErrorMsg",   s:red,    "", "bold")
call s:HL("WarningMsg", s:yellow, "", "bold")
call s:HL("MoreMsg",    s:blue,   "", "")
call s:HL("ModeMsg",    s:text,   "", "bold")

" =========================
" Syntax
" =========================
call s:HL("Comment",    s:overlay0, "", "italic")
call s:HL("Constant",   s:peach,    "", "")
call s:HL("String",     s:green,    "", "")
call s:HL("Character",  s:teal,     "", "")
call s:HL("Number",     s:peach,    "", "")
call s:HL("Boolean",    s:peach,    "", "bold")
call s:HL("Identifier", s:flamingo, "", "")
call s:HL("Function",   s:blue,     "", "bold")
call s:HL("Statement",  s:mauve,    "", "")
call s:HL("Keyword",    s:mauve,    "", "italic")
call s:HL("PreProc",    s:pink,     "", "")
call s:HL("Type",       s:yellow,   "", "")
call s:HL("Special",    s:pink,     "", "")
call s:HL("Underlined", "",         "", "underline")
call s:HL("Error",      s:red,      s:surface0, "bold")
call s:HL("Todo",       s:base,     s:yellow, "bold")

" =========================
" Markdown
" =========================
" Heading text
call s:HL("markdownH1",                s:mauve,     "", "bold")
call s:HL("markdownH2",                s:blue,      "", "bold")
call s:HL("markdownH3",                s:green,     "", "bold")
call s:HL("markdownH4",                s:yellow,    "", "bold")
call s:HL("markdownH5",                s:peach,     "", "bold")
call s:HL("markdownH6",                s:pink,      "", "bold")

" Heading # prefix
call s:HL("markdownHeadingDelimiter", s:overlay1, "", "bold")
call s:HL("markdownH1Delimiter",      s:mauve,    "", "bold")
call s:HL("markdownH2Delimiter",      s:blue,     "", "bold")
call s:HL("markdownH3Delimiter",      s:green,    "", "bold")
call s:HL("markdownH4Delimiter",      s:yellow,   "", "bold")
call s:HL("markdownH5Delimiter",      s:peach,    "", "bold")
call s:HL("markdownH6Delimiter",      s:pink,     "", "bold")
call s:HL("markdownRule",              s:surface2,  "", "")

call s:HL("markdownBold",              s:peach,     "", "bold")
call s:HL("markdownItalic",            s:pink,      "", "italic")
call s:HL("markdownBoldItalic",        s:mauve,     "", "bold,italic")

call s:HL("markdownCode",              s:green,     s:surface0, "")
call s:HL("markdownCodeBlock",         s:green,     s:surface0, "")
call s:HL("markdownCodeDelimiter",     s:overlay1,  "", "")

call s:HL("markdownBlockquote",        s:overlay1,  "", "italic")
call s:HL("markdownListMarker",        s:mauve,     "", "bold")
call s:HL("markdownOrderedListMarker", s:mauve,     "", "bold")

call s:HL("markdownLinkText",          s:blue,      "", "underline")
call s:HL("markdownUrl",               s:sky,       "", "underline")
call s:HL("markdownIdDeclaration",     s:lavender,  "", "")
call s:HL("markdownAutomaticLink",     s:sky,       "", "underline")
