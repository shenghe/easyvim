" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : cpp.vim
" Date : 2012/2/16 17:11:39

if exists("current_compiler")
  finish
endif
let current_compiler = "cpp"

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

function! s:EVCompilerC.VC(Cmds)
    let makeprgStr = 'cl\ /nologo\ '
    if a:Cmds != ""
        let makeprgStr .= substitute(substitute(a:Cmds,'\\','/','g'),'\(\s\+\|,\|"\)','\\\0','g')
    endif
    exe 'setlocal makeprg=cmd.bat\ \"'.makeprgStr.'\ %\"'
    CompilerSet errorformat=%+Wcl\ :\ %*[^']'%f'%.%#,
                \%+ELINK\ :\ fatal\ error\ %t%*[^0-9]%n:\ %*[^']'%f',
                \%+ELINK\ :\ %m,
                \%+W%f(%l)\ :\ warning%.%#,
                \%+W%f(%l):\ warning%.%#,
                \%E%f(%l):\ %m,
                \%E%f(%l)\ :\ %m,
                \%E%f\ :\ %m,
                \%-G%.%#
endfunction

function! s:EVCompilerC.GCC(Cmds)
    let makeprgStr = 'g++\ '
    if a:Cmds != ""
        let makeprgStr .= substitute(substitute(a:Cmds,'\\','/','g'),'\(\s\+\|,\|"\)','\\\0','g')
    endif
    exe 'setlocal makeprg=cmd.bat\ \"'.makeprgStr.'\ %\"'
    CompilerSet errorformat=
          \%*[^\"]\"%f\"%*\\D%l:%c:\ %m,
          \%*[^\"]\"%f\"%*\\D%l:\ %m,
          \\"%f\"%*\\D%l:%c:\ %m,
          \\"%f\"%*\\D%l:\ %m,
          \%-G%f:%l:\ %trror:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,
          \%-G%f:%l:\ %trror:\ for\ each\ function\ it\ appears\ in.),
          \%f:%l:%c:\ %trror:\ %m,
          \%f:%l:%c:\ %tarning:\ %m,
          \%f:%l:%c:\ %m,
          \%f:%l:\ %trror:\ %m,
          \%f:%l:\ %tarning:\ %m,
          \%f:%l:\ %m,
          \\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m,
          \%D%*\\a[%*\\d]:\ Entering\ directory\ `%f',
          \%X%*\\a[%*\\d]:\ Leaving\ directory\ `%f',
          \%D%*\\a:\ Entering\ directory\ `%f',
          \%X%*\\a:\ Leaving\ directory\ `%f',
          \%DMaking\ %*\\a\ in\ %f,
          \%*[^\(\.\|/\|\\\)]:%*[^(](%*[^:]:%f:%m,
          \%+W%f:\ In\ %m

    if exists('g:compiler_gcc_ignore_unmatched_lines')
      CompilerSet errorformat+=%-G%.%#
    endif
endfunction

let Class = s:EVCompilerC.New()
if has("win32") || has("win64") || has("win16")
    if isdirectory("C:/Program Files/Microsoft Visual Studio/VC98/") || isdirectory("C:/Program Files/Microsoft Visual Studio 10.0/VC/")
        call Class.VC("")
    else
        call Class.GCC("")
    endif
else
    call Class.GCC("")
endif
let &cpo = s:cpo_save
unlet s:cpo_save
