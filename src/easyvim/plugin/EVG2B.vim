" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVG2B.vim
" Date : 2012/2/10 19:39:15

if exists("g:EVG2B")
    finish
endif
let g:EVG2B = "1.0"

function! EVMark_To(...)
    if exists("a:1")
        let type = a:1 == "cn" ? "cn" : "tra"
    else
        let type = "tra"
    endif
    let cnString =s:GetString("cn")
    let traString =s:GetString("tra")
    let numList = range(1,line("$"))
    if type == "tra"
        for lnum in numList
            call setline(lnum,tr(getline(lnum),cnString,traString))
        endfor
    else
        for lnum in numList
            call setline(lnum,tr(getline(lnum),traString,cnString))
        endfor
    endif
endfunction

function! s:GetString(type)
    let Path = s:GetPath()
    if a:type == 'cn'
        let fileList = readfile(Path."/cn.txt")
    else
        let fileList = readfile(Path."/tra.txt")
    endif
    call map(fileList,"substitute(v:val,'\s','','g')")
    let fileString = join(fileList,'')
    return fileString
endfunction

function! s:GetPath()
    if exists("g:EVPath")
        let Path = substitute(g:EVPath,'[\\\|/]\+\s*$','','g').'/G2B'
    endif
    let Path = exists("Path") ? Path : $VIMRUNTIME.'/G2B'
    if !isdirectory(Path)
        call mkdir(Path,'p')
    endif
    return Path
endfunction

if v:lang =~ "^zh"
"Map    {{{
    noremap! <silent> <F11> <C-o>:call EVMark_To("tra")<CR>
    nnoremap <silent> <F11> :call EVMark_To("tra")<CR>
    noremap! <silent> <S-F11> <C-o>:call EVMark_To("cn")<CR>
    nnoremap <silent> <S-F11> :call EVMark_To("cn")<CR>
"}}}

"command    {{{
    command -narg=1 G2b call EVMark_To(<args>)
"}}}

"Menu   {{{
an <silent> 40.100.10 &Tools.G2B.Tocn                              :call EVMark_To("cn")<CR>
an <silent> 40.100.20 &Tools.G2B.Totw                              :call EVMark_To("tra")<CR>
"}}}
endif
