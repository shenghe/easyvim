" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : nsis.vim
" Date : 2012/2/17 12:24:57

if exists("current_compiler")
  finish
endif
let current_compiler = "nsis"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

let s:EVCompilerC = {}

function! s:EVCompilerC.New()
    let Class = copy(self)
    return Class
endfunction

function! s:EVCompilerC.Nsis(Cmds)
    let EVPath = tolower(substitute($PATH,'\\','/','g'))
    let makeprgStr = 'makensis\ /V3\ '
    if a:Cmds != ""
        let makeprgStr .= substitute(substitute(a:Cmds,'\\','/','g'),'\(\s\+\|,\|"\)','\\\0','g')
    endif
    exe 'setlocal makeprg=cmd.bat\ \"'.makeprgStr.'\ %\"'
    CompilerSet errorformat=
                        \%+E%*[^\"]\"%f\"%*[^%\\d]%l%.%#,
                        \%+E%*[^:]\"%f\",
                        \%-G%.%#
endfunction

let Class = s:EVCompilerC.New()
call Class.Nsis("")
let &cpo = s:cpo_save
unlet s:cpo_save
