" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVHelp.vim
" Date : 2012/2/24 12:07:10

if exists("g:EVHelp_autoload")
    finish
endif
let g:EVHelp_autoload = "1.0"

function! EVHelp#EVHelp(...) range
    let keyword = ""
    if exists("a:1")
        let keyword = a:1
    endif
    let searchContent = s:GetWord(keyword,"help")
    if searchContent == ''
        return
    endif
    let oldHelpFile = &helpfile
    let docList = []
    if &ft != ''
        let ExtPath = $VIM
        if exists('g:EVPath')
            let ExtPath = substitute(g:EVPath,'/$','','g')
        endif
        if exists('g:EVPluginPath')
            let ExtPath .= substitute(substitute(g:EVPath,'^[^/]','\\\0','g'),'[^/]$','\0/','g')
        else
            let ExtPath .= '/easyvim/'
        endif
        let docList = split(globpath(ExtPath,'**/'.&ft.'/**/help.txt'),'\n')
    endif
    let docList += [oldHelpFile]
    let counts = 0
    for var in docList
        let counts += 1
        try
            exe 'setlocal helpfile='.substitute(var,'\s','\\\0','g')
            exe 'help '.searchContent
            break
        catch /.*/
            if counts == len(docList)
                call s:HelpGrep(searchContent)
            endif
        endtry
    endfor
    exe 'setlocal helpfile='.substitute(oldHelpFile,' ','\\\0','g')
endfunction

function! EVHelp#SetHelpFile()
    let oldHelpFile = &helpfile
    let helpfileList = split(oldHelpFile,';')
    let helpfilePathList = []
    let listIndex = 0
    for perfile in helpfileList
        let helpfilePathList += [substitute(perfile,'[\\\|/][^\\\|/]\+\zs\.[^\\\|/]\+\ze$','','')]
        let listIndex += 1
    endfor
    let helpfilesList = []
    let extList = ['txt','cnx','dex','itx','frx','pex','pox','rux']
    for perpath in helpfilePathList
        for perext in extList
            if filereadable(perpath.'.'.perext)
                let helpfilesList += [substitute(perpath.'.'.perext,'\s','\\\0','g')]
            endif
        endfor
    endfor
    exe "set helpfile=".join(helpfilesList,';')
endfunction

function! EVHelp#setEngine() range
    let engine = inputdialog("请输入搜索引擎名称:",'','')
    if engine != ''
        let counts = 0
        while !exists('engineValue') || engineValue == ''
            let counts += 1
            let engineValue = inputdialog("请输入搜索引擎链接({q}代表要被替换的内容)",'','')
            if (counts == 3) && engineValue == ''
                return
            endif
        endwhile
        let dict = s:GetDict()
        if !filereadable(dict)
            return
        endif
        let ValueDict = readfile(dict)
        let ValueDict += [engine.':'.engineValue]
        try
            call writefile(ValueDict,dict)
            echohl WarningMsg| echomsg "添加成功!"|echohl None
        catch /.*/
            echohl WarningMsg| echomsg "写入失败,请检查文件或文件夹权限!"|echohl None
        endtry
    endif
endfunction

function! EVHelp#SearchInBrowse(word,engine) range
    let searchContent = a:word
    let engine = a:engine
    if a:word =~ '^file:///'
        let searchContent = substitute(a:word,'^file:///','','')
        let engine = "file"
    elseif a:word == ""
        let searchContent = s:GetWord("","browse")
        if searchContent == ""
            return
        endif
    endif
    if engine == ""
        let engine = inputdialog("请输入搜索引擎名称:\nGoogle wikipedia msdn",'','')
    endif
    let engineUrl = substitute(s:GetEngineUrl(engine),'{q}',substitute(searchContent,'\\','\\\0','g'),'g')
    if exists("g:default_web_browser")
        try | call system(g:default_web_browser . " \"" . engineUrl . "\" &") | catch /.*/ | endtry
    else
        try
            if (has("mac"))
                call system( "open \"" . engineUrl . "\"")
            elseif (has("win32") || has("win32unix"))
                call system('cmd /q /c start "\""dummy title"\"" ' . "\"" . engineUrl . "\"")
            elseif (has("unix"))
                call system("xdg-open \"" . engineUrl . "\"")
            endif
        catch /.*/
        endtry
    endif
endfunction

function! s:GetEngineUrl(engine)
    let engineDict ={
                \'google':"http://www.google.com/search?q={q}",
                \'wikipedia':"http://en.wikipedia.org/wiki/{q}",
                \'msdn':"http://search.msdn.microsoft.com/search/Default.aspx?query={q}&brand=msdn&locale=en-us&refinement=00&lang=en-us",
                \'cplusplus':"http://www.cplusplus.com/query/search.cgi?q={q}",
                \'php':"http://us2.php.net/manual-lookup.php?pattern={q}",
                \'networksolutions':"http://www.networksolutions.com/whois/results.jsp?domain={q}",
                \'thesaurus':"http://thesaurus.reference.com/browse/{q}",
                \'reference':"http://dictionary.reference.com/browse/{q}",
                \'whois':"http://www.whois.net/whois_new.cgi?d={q}",
                \'yahoo':"http://search.yahoo.com/search?p={q}",
                \'file':"file:///{q}"
                \}
    let dict = s:GetDict()
    let engineList = items(engineDict)
    if filereadable(dict)
        let engineStrList = readfile(dict)
        for var in engineStrList
            let subList = split(var,'^[^:]\+\zs:\ze')
            try | let engineList +=[[subList[0],subList[1]]] | catch /.*/ | endtry
        endfor
    endif
    let engineUrl = ""
    for [key,value] in engineList
        if key == a:engine
            let engineUrl = value
            break
        endif
    endfor
    if engineUrl == ""
        let engineUrl = engineDict["google"]
    endif
    return engineUrl
endfunction

function! s:GetDict()
    if exists("g:EVPath")
        let Path = substitute(g:EVPath,'[\\\|/]\+\s*$','','g').'/dict'
    endif
    if !exists("Path")
        let Path = exists("$HOME") ? $HOME.'/.easyvim/dict' : $VIMRUNTIME.'/dict'
    endif
    if !isdirectory(Path)
        call mkdir(Path,'p')
    endif
    return Path."/engine.dict"
endfunction

function! s:HelpGrep(word)
    if a:word == ""
        return
    endif
    try
        execute "helpgrep ".a:word
        let qflist = getqflist()
        for i in qflist
            let i.text = iconv(i.text,"utf-8",&encoding)
        endfor
        call setqflist(qflist)
        copen
    catch /.*/
        if exists('g:autoBrowserSearch')
            call EVHelp#SearchInBrowse(a:word,"google")
        else
            echohl WarningMsg| echomsg "没有找到相关内容!"|echohl None
        endif
    endtry
endfunction

function! s:GetWord(keyword,type)
    let searchContent = a:keyword
    if a:keyword == ""
        let action = ""
        if a:type == "help"
            if line("'<") == line("'>") && line('.') == line("'<") && col('.') == 1 && col('v') == 1
                let action = "singleLine"
            elseif line("'<") != line("'>") && col('.') == 1 && col('v') == 1
                let action = "multiLine"
            endif
        else
            if line("'<") == line("'>") && line('.') == line("'<") &&  col(".") == col("'>")
                let action = "singleLine"
            elseif line("'<") != line("'>") && col(".") == col("'>")
                let action = "multiLine"
            endif
        endif
        if action == "singleLine"
            let searchContent = strpart(getline(line("'<")),col("'<")-1,(col("'>")-col("'<")))
        elseif action == "multiLine"
            let firstVar = line("'<")
            let secondVar = line("'>")
            while firstVar <= secondVar
                if firstVar == line("'<")
                    let searchContent = strpart(getline(firstVar),col("'<")-1)
                elseif firstVar == line("'>")
                    let searchContent = searchContent.' '.strpart(getline(firstVar),0,col("'>"))
                else
                    let searchContent = searchContent.' '.getline(firstVar)
                endif
                let firstVar += 1
            endwhile
        endif
        if searchContent == ''
            let searchContent = inputdialog("请输入要搜索的内容:",'','')
        endif
    endif
    return substitute(searchContent,'\s','',"g")
endfunction

function! EVHelp#Vimgrep()
    let word = inputdialog("请输入您想查找的内容:")
    if word == "" | return | endif
    exec "vimgrep /".word."/ ./**/*.*"
    let qflist = getqflist()
    if qflist != []
        copen
    endif
endfunction

function! EVHelp#Replace()
    if has("gui_running")
        promptrepl
    else
        let findWord = inputdialog("请输入您想查找的内容:")
        if findWord == "" | return | endif
        let replaceWord = inputdialog("请输入您想替换的内容:")
        exec '1,$s/'.findWord.'/'.replaceWord.'/egI'
    endif
endfunction
