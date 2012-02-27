" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVTemplate.vim
" Date : 2012/2/21 18:28:34

if exists("g:EVTemplate")
    finish
endif
let g:EVTemplate = "1.0"
if !exists("g:EVTemplate_prefix")
    let g:EVTemplate_prefix = "UnTitled"
endif
"Function   {{{
function!   EVSetTemplate(...)
    let method = "tabnew"
    if exists("a:2")
        let method = a:2
    endif
    let EmptyWinNr = 0
    if &bt == "" && &ft == "" && expand("%") == ""
        let EmptyWinNr = winnr()
        let EmptyTabNr = tabpagenr()
    endif
    let FileName = !exists("a:1") ? inputdialog("请输入文件名称:") : s:GetTempName(a:1)
    if FileName == ""
        return
    endif
    try | exe method." ".FileName | catch /.*/ | return | endtry
    if EmptyWinNr != 0
        exe "tabn ".EmptyTabNr
        exe EmptyWinNr." wincmd w"
        wincmd c
    endif
    if getline(1,$) != []
        return
    endif
    let TemplatePath = s:GetTemplatePath()
    let TemplateType = strridx(FileName,".") == -1 ? s:GetTemplateType() : strpart(FileName,strridx(FileName,".")+1)
    if !filereadable(TemplatePath."/".TemplateType.".template")
        return
    endif
    let TplContentList = readfile(TemplatePath."/".TemplateType.".template")
    call setline(1,TplContentList)
endfunction

function!   s:GetTemplateType()
    let TemplateType = expand("%:e") == "" ? &ft : expand("%:e")
    return TemplateType
endfunction

function!   s:GetTemplatePath()
    if exists("g:EVPath")
        let TemplatePath = substitute(g:EVPath,'[\\\|/]\+\s*$','','g').'/template'
    endif
    if !exists("TemplatePath")
        let TemplatePath = $VIMRUNTIME.'/template'
    endif
    if !isdirectory(TemplatePath)
        call mkdir(TemplatePath,'p')
    endif
    return TemplatePath
endfunction

function! s:GetTempName(filename)
    let FileName = matchstr(a:filename,'\zs[^\\\|/]\+\ze\.[^\\\|/]\+$')
    let FileExt = matchstr(a:filename,'[^\\\|/]\+\.\zs[^\\\|/]\+\ze$')
    let startNum = 1
    "bufName
    let BufList = s:buildBufList()
    if index(BufList,a:filename) == -1
        if !filereadable(expand("%:p:h")."/".a:filename)
            return a:filename
        else
            let fileCounts = len(split(globpath(expand("%:p:h")."/",'*'),'\n'))
            if fileCounts == 0
                let fileCounts = 1
            endif
            for counts in range(1,fileCounts)
                if !filereadable(expand("%:p:h")."/".FileName."-".counts.".".FileExt)
                    let startNum = counts
                    break
                endif
            endfor
        endif
    endif
    for counts in range(startNum,startNum + bufnr("$"))
        if index(BufList,FileName."-".counts.".".FileExt) == -1
            return FileName."-".counts.".".FileExt
        endif
    endfor
    return FileName."-".(startNum + bufnr("$") + 1).".".FileExt
endfunction

function! s:buildBufList()
    let BufList = []
    let BufCounts = bufnr("$")
    for bufNum in range(1,BufCounts)
        let BufList += [bufname(bufNum)]
    endfor
    return BufList
endfunction
"}}}

"Menu   {{{
    an <silent> 10.10.10  &File.NewTemplate.TXT                  :call EVSetTemplate(g:EVTemplate_prefix.".txt")<CR>
    an <silent> 10.10.20  &File.NewTemplate.C                    :call EVSetTemplate(g:EVTemplate_prefix.".c")<CR>
    an <silent> 10.10.30  &File.NewTemplate.CPP                  :call EVSetTemplate(g:EVTemplate_prefix.".cpp")<CR>
    an <silent> 10.10.40  &File.NewTemplate.Javascript           :call EVSetTemplate(g:EVTemplate_prefix.".js")<CR>
    an <silent> 10.10.50  &File.NewTemplate.PHP                  :call EVSetTemplate(g:EVTemplate_prefix.".php")<CR>
    an <silent> 10.10.60  &File.NewTemplate.HTML                 :call EVSetTemplate(g:EVTemplate_prefix.".html")<CR>
    an <silent> 10.10.70  &File.NewTemplate.New                  :call EVSetTemplate()<CR>
"}}}

"Command    {{{
    command -nargs=*  New call EVSetTemplate(<args>)
"}}}
"   vim:foldmethod=marker
