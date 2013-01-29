" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : python.vim
" Date : 2012/2/16 21:46:33

if exists("current_compiler")
  finish
endif
let current_compiler = "python"

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

function! s:EVCompilerC.Python(Cmds)
    let EVPath = tolower(substitute($PATH,'\\','/','g'))
    let makeprgStr = 'python\ '
    if a:Cmds != ""
        let makeprgStr .= substitute(substitute(a:Cmds,'\\','/','g'),'\(\s\+\|,\|"\)','\\\0','g')
    endif
    exe 'setlocal makeprg=cmd.bat\ \"'.makeprgStr.'\ %\"'
    exe 'CompilerSet errorformat=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%-C\ %.%#,%+Z%*[^:]:%m,%-GSetting\ %.%#,'.&errorformat
endfunction

let Class = s:EVCompilerC.New()
call Class.Python("")
let &cpo = s:cpo_save
unlet s:cpo_save
