" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : php.vim
" Date : 2012/2/17 16:18:43

if exists("current_compiler")
  finish
endif
let current_compiler = "php"

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

function! s:EVCompilerC.Java(Cmds)
    let EVPath = tolower(substitute($PATH,'\\','/','g'))
    let makeprgStr = 'php\ -f\ '
    if a:Cmds != ""
        let makeprgStr .= substitute(substitute(a:Cmds,'\\','/','g'),'\(\s\+\|,\|"\)','\\\0','g')
    endif
    exe 'setlocal makeprg=cmd.bat\ \"'.makeprgStr.'\ %\"'
    CompilerSet errorformat=%E<b>Parse\ error</b>:\ %m\ in\ <b>%f</b>\ on\ line\ <b>%l</b><br\ />,
               \%W<b>Notice</b>:\ %m\ in\ <b>%f</b>\ on\ line\ <b>%l</b><br\ />,
               \%EParse\ error:\ %m\ in\ %f\ on\ line\ %l,
               \%WNotice:\ %m\ in\ %f</b>\ on\ line\ %l,
               \%-G%.%#
endfunction

let Class = s:EVCompilerC.New()
call Class.Java("")
let &cpo = s:cpo_save
unlet s:cpo_save
