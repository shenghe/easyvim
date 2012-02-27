" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVCompiler.vim
" Date : 2012/2/26 11:32:08

if exists("g:EVCompiler")
    finish
endif
let g:EVCompiler = 1

if !exists("g:EVCompilerAutoConv")
    let g:EVCompilerAutoConv = 1
endif

if !exists("g:EVCompilerAutoCopen")
    let g:EVCompilerAutoCopen = 1
endif

let s:Compiler = {}

function! s:Compiler.New()
    let Class = copy(self)
    let Class.type = "c"
    return Class
endfunction

function! s:EVCompilerMake()
    if &bt == "help" || &bt == "quickfix" || &bt == "nofile" || &bt == "nowrite" || expand("%") == ""
        return
    endif
    silent make
endfunction

function! s:Compiler.SetCompiler() range
    if globpath(&rtp, "compiler/".self.type.".vim")!= ""
        exe 'compiler '.self.type
        return
    endif
endfunction

function! s:EVCompilerCreate() range
    let template = [
                \'" Compiler: '.&ft,
                \'" Maintainer: '.hostname(),
                \'" Created: '.strftime("%c"),
                \'if exists("current_compiler") | finish | endif',
                \'let current_compiler = '.&ft,
                \'let s:cpo_save = &cpo',
                \'set cpo-=C',
                \'if exists(":CompilerSet") != 2',
                \'  command -nargs=* CompilerSet setlocal <args>',
                \'endif',
                \'CompilerSet makeprg&',
                \'CompilerSet errorformat&',
                \'let &cpo = s:cpo_save',
                \'unlet s:cpo_save',
                \]
    if !isdirectory($VIMRUNTIME."/compiler/")
        try | call mkdir($VIMRUNTIME."/compiler/",'p') | catch /.*/ | endtry
    endif
    if filereadable($VIMRUNTIME."/compiler/".&ft.".vim")
        let answer = inputdialog("此編譯器文件已存在,要覆蓋嗎?")
    endif
    if !exists("answer") || answer != ""
        call writefile(template,$VIMRUNTIME."/compiler/".&ft.".vim")
    endif
endfunction

function! s:EVCompilerCopen() range
    let qflist = getqflist()
    if len(qflist) > 0
        copen
    endif
endfunction

function! s:EVCompilerConv() range
    let qflist = getqflist()
    if v:lang =~ "^zh_CN"
        let fromEncoding = "chinese"
    elseif v:lang =~ "^zh_TW"
        let fromEncoding = "taiwan"
    elseif  v:lang =~ "^ko"
        let fromEncoding = "korea"
    elseif  v:lang =~ "^ja_JP"
        let fromEncoding = "japan"
    endif
    for i in qflist
        let i.text = iconv(i.text,fromEncoding,&encoding)
    endfor
   call setqflist(qflist)
endfunction

function! s:EVCompiler() range
    if &bt == "help" || &bt == "quickfix" || &bt == "nofile" || &bt == "nowrite"
        return
    endif
    let Class = s:Compiler.New()
    if &ft != ""
        let Class.type = &ft
    endif
    call Class.SetCompiler()
endfunction

function! s:SetCompiler()
    let s:n = globpath(&runtimepath, "compiler/*.vim")
    let s:idx = 10
    while strlen(s:n) > 0
      let s:i = stridx(s:n, "\n")
      if s:i < 0
        let s:name = s:n
        let s:n = ""
      else
        let s:name = strpart(s:n, 0, s:i)
        let s:n = strpart(s:n, s:i + 1, 19999)
      endif
      " Ignore case for VMS and windows
      let s:name = substitute(s:name, '\c.*[/\\:\]]\([^/\\:]*\)\.vim', '\1', '')
      exe "an 40.20." . s:idx . ' &Tools.Compiler.SetCompiler.' . s:name . " :compiler " . s:name . "<CR>"
      unlet s:name
      unlet s:i
      let s:idx = s:idx + 10
    endwhile
    unlet s:n s:idx
endfunction

augroup EVCompiler
    au!
    au QuickFixCmdPost make,lmake  call s:EVCompilerConv() | call s:EVCompilerCopen()
    au BufWinEnter * call s:EVCompiler()
augroup END
command! -nargs=0 Make call s:EVCompilerMake()
command! -nargs=0 CCompiler call s:EVCompilerCreate()
inoremap <silent> <F5>                              <C-o>:Make<CR>
nnoremap <silent> <F5>                              :Make<CR>
an <silent> 40.20.10 &Tools.Compiler.Compiler               :Make<CR>
an <silent> 1.130 ToolBar.RunScript                         :Make<CR>
call s:SetCompiler()
