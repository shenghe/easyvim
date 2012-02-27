" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : javascript.vim
" Date : 2012/2/16 21:28:20

if exists("current_compiler")
  finish
endif
let current_compiler = "javascript"

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

function! s:EVCompilerC.Jsl(Cmds)
    let EVPath = tolower(substitute($PATH,'\\','/','g'))
    let makeprgStr = 'jsl\ -nofilelisting\ -nocontext\ -nosummary\ -nologo\ -process\ '
    if a:Cmds != ""
        let makeprgStr .= substitute(substitute(a:Cmds,'\\','/','g'),'\(\s\+\|,\|"\)','\\\0','g')
    endif
    exe 'setlocal makeprg=cmd.bat\ \"'.makeprgStr.'\ %\"'
    CompilerSet errorformat=
                            \%f(%l):\ %m,
                            \%f(%l)\ :\ %m,
                            \%f\ :\ %m,
                            \%f(%l,%c)\ :\ %m,
                            \%f(%l,%c):%m,
                            \%f:%l:%c:%m,
                            \%f\|%l\|\ %m,
                            \%-G%.%#
endfunction

let Class = s:EVCompilerC.New()
call Class.Jsl("")
let &cpo = s:cpo_save
unlet s:cpo_save
