" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : easyvim.vim
" Date : 2012/2/23 12:32:49

" For EasyVim Project
" Maintainer:   HeSheng <sheng.he.china@gmail.com>


hi clear
set background=light
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "easyvim"
hi Normal		  guifg=#000000  guibg=#ffffff
hi Scrollbar	  guifg=darkcyan guibg=cyan
hi Conceal        guifg=#FF0000     guibg=#ffffff
hi Menu			  guifg=black guibg=cyan
hi SpecialKey	  term=bold  cterm=bold  ctermfg=darkred  guifg=#12dd12
hi NonText		  term=bold  cterm=bold  ctermfg=black  guibg=#ffffff      guifg=#ffffff
hi Directory	  term=bold  cterm=bold  ctermfg=brown  guifg=#cc8000
hi ErrorMsg		  term=standout  cterm=bold  ctermfg=red  ctermbg=black  guifg=#fe0404  guibg=#ffffff
hi Search		  term=reverse  ctermfg=white  ctermbg=red      guifg=#800000  guibg=#e0dfe3
hi MoreMsg		  term=bold  cterm=bold  ctermfg=darkgreen	gui=bold  guifg=#008000
hi ModeMsg		  term=bold  cterm=bold  gui=bold  guifg=White	guibg=Blue
hi LineNr		  term=underline  cterm=bold  ctermfg=darkcyan	guifg=#f73600 guibg=#f0f0f0
hi Question		  term=standout  cterm=bold  ctermfg=darkgreen  guifg=red
hi StatusLine	  gui=bold guifg=#f0f0f0 guibg=#323200
hi StatusLineNC   guifg=#f0f0f0 guibg=#323230
hi Title		  term=bold  cterm=bold  ctermfg=darkmagenta  gui=bold	guifg=#000000
hi Visual		  term=reverse	cterm=reverse  gui=None guibg=#a3adc7
hi VertSplit gui=None guifg=#f0f0f0 guibg=#262a2b
hi Folded         gui=underline guifg=#FF8000 guibg=#ffffff
hi FoldColumn     gui=bold guifg=black guibg=#ffffff
hi SignColumn     gui=bold guifg=black guibg=#ffffff
hi Pmenu          guifg=#ffffff guibg=#cb2f27
hi WarningMsg	  term=standout  cterm=bold  ctermfg=darkred guifg=Red
hi Cursor		  guifg=#fe0404	guibg=#000000

hi CursorLine	  term=underline  guibg=#ffffcd cterm=underline
hi CursorColumn	  term=underline  guibg=#555555 cterm=underline
hi MatchParen	  term=reverse  ctermfg=blue guifg=#fe0404  guibg=#ffffff gui=bold
hi Comment		  term=bold  cterm=bold ctermfg=cyan  guifg=#FF8000
hi Constant		  term=underline  cterm=bold ctermfg=magenta  guifg=#0086d2
hi Special		  term=bold  cterm=bold ctermfg=red  guifg=#000000
hi Identifier	  term=underline   ctermfg=brown  gui=italic guifg=#000080
hi Statement	  term=bold  cterm=bold ctermfg=yellow	gui=bold  guifg=#804000
hi PreProc		  term=underline  ctermfg=darkmagenta   guifg=#ff0007
hi Type			  term=underline  cterm=bold ctermfg=lightgreen  gui=bold  guifg=#010180
hi Error		  term=reverse	ctermfg=darkcyan  ctermbg=black  guifg=#000000	guibg=#d40000
hi Todo			  term=standout  ctermfg=black	ctermbg=darkcyan  guifg=#e50808  guibg=#dbf3cd
"hi TabLine		  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=bold guifg=blue guibg=white
"hi TabLineFill	  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=bold guifg=blue guibg=white
"hi TabLineSel	  term=reverse	ctermfg=white ctermbg=lightblue guifg=white guibg=blue
hi link IncSearch	    Search 
hi String term=underline  cterm=bold ctermfg=magenta  guifg=#008000
hi link Character		Constant
hi Number	term=underline  cterm=bold ctermfg=magenta  guifg=#ff0036
hi link Boolean			Constant
hi link Float			Number
hi Function	term=underline   ctermfg=brown  guifg=#804000
hi link Conditional		Statement
hi link Repeat			Statement
hi Label  term=bold  cterm=bold ctermfg=yellow	gui=bold  guifg=#ff0086
hi link Operator		Statement
hi link Keyword			Statement
hi link Exception		Statement
hi link Include			PreProc
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link SpecialChar		Special
hi Delimiter term=bold  cterm=bold ctermfg=red  guifg=#fd0000
hi link SpecialComment	Special
hi link Debug			Special

