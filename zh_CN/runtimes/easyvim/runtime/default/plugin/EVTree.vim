" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVTree.vim
" Date : 2012/2/24 12:42:46

if exists("g:EVTree")
    finish
endif
let g:EVTree = "1.0"

let globalVarDict = {
            \ "g:EVTreeWinLocation": "left",
            \ "g:EVTreeWinSize": 25,
            \ "g:EVTreeOpenByDefault": 1,
            \ "g:EVTreeResolveLinkfile": 1,
            \ "g:EVTreeShowDirOnly": 0,
            \ "g:EVTreeShowBookmarkInOpen": 0,
            \ "g:EVTreeCloneTreeInNewTab": 0
            \}
function! s:SetGlobalVar(dict)
    if type(a:dict) != 4
        return
    endif
    for [key,value] in items(a:dict)
        if !exists(key)
            let {key} = value
        endif
    endfor
endfunction

call s:SetGlobalVar(globalVarDict)

function! EVTreeToggle()
    let tabNr = tabpagenr()
    if bufwinnr("_EVTree_") != -1 || bufwinnr("_EVTree_".tabNr) != -1
        call s:Tree.Close()
        call s:Bookmark.Close()
    else
        call s:Tree.Create()
        if g:EVTreeShowBookmarkInOpen
            call s:Bookmark.Create()
        endif
    endif
endfunction

function! EVTreeToggleBookmark()
    let tabNr = tabpagenr()
    if bufwinnr("_EVTreeBookmark_") != -1 || bufwinnr("_EVTreeBookmark_".tabNr) != -1
        call s:Bookmark.Close()
    else
        call s:Bookmark.Create()
    endif
endfunction

function! EVTreeOnClick()
    if s:Vailability() == 0
        return
    endif
    let lineInfo = s:GetLineInfo(line("."))
    if lineInfo[2] == "file"
        call s:File.Open()
    elseif lineInfo[2] == "closedFold"
        call s:Fold.Open()
    elseif lineInfo[2] == "openFold"
        call s:Fold.Close()
    endif
endfunction

function! EVTreeRefresh()
    if bufname("%") =~ '_EVTree_\d*'
        call s:Tree.Init()
    elseif bufname("%") =~ '_EVTreeBookmark_\d*'
        call s:Bookmark.Init()
    endif
endfunction

function! EVTreeFilter()
    if bufname("%") =~ '_EVTree_\d*'
        call s:Tree.Filter()
    endif
endfunction

function! EVTreeDelete()
    let lineInfoList = s:GetLineInfo(line("."))
    if lineInfoList[2] == "file"
        call s:File.Delete()
    elseif lineInfoList[2] == "openFold" || lineInfoList[2] == "closedFold"
        call s:Fold.Delete()
    endif
endfunction

function! EVTreeRename()
    let lineInfoList = s:GetLineInfo(line("."))
    if lineInfoList[2] == "file"
        call s:File.Rename()
    elseif lineInfoList[2] == "openFold" || lineInfoList[2] == "closedFold"
        call s:Fold.Rename()
    endif
endfunction

function! EVTreeSearch(type)
    let lineInfoList = s:GetLineInfo(line("."))
    if lineInfoList[2] != "openFold" && lineInfoList[2] != "closedFold"
        return
    endif
    if a:type == "contents"
        call s:Fold.SearchByContents()
    elseif a:type == "names"
        call s:Fold.SearchByNames()
    endif
endfunction

function! EVTreeAddBookmark()
    call s:Bookmark.Add()
endfunction

function! EVTreeDeleteBookmark()
    call s:Bookmark.Delete()
endfunction


function! EVTreeOpen(method,...)
    if exists("a:1")
        call s:File.Open(a:method,a:1)
    else
        call s:File.Open(a:method)
    endif
endfunction

function! s:GetPlatform()
    if has("win16") || has("win32") || has("win64") || has("win32unix")
        return "win"
    elseif has("mac")
        return "mac"
    else
        return "linux"
    endif
endfunction

function! s:GetLineInfo(line)
    let lineNr = (type(a:line) == 0 && a:line <= line("$")) ? a:line : line(".")
    "line
    let lineInfoList = [lineNr]
    "level
    let levelStr = matchstr(getline(lineNr),'^\zs\(\s\s|\)*\ze\s\(\[+\]-\|\[-\]-\||--\)')
    let lineInfoList += [len(split(levelStr,"|"))]
    "type
    let typeStr = matchstr(getline(lineNr),'^\(\s\s|\)*\s\zs\(\[+\]-\|\[-\]-\||--\)\ze')
    if typeStr == "[+]-"
        let lineInfoList += ["closedFold"]
    elseif typeStr == "[-]-"
        let lineInfoList += ["openFold"]
    elseif typeStr == "|--"
        let lineInfoList += ["file"]
    else
        let lineInfoList += ["unknown"]
    endif
    "path
    if lineInfoList[2] == "unknown"
        let lineInfoList += ["",""]
    else
        let sublevel = lineInfoList[1]
        let Path = matchstr(getline(lineNr),'^\(\s\s|\)*\s\(\[+\]-\|\[-\]-\||--\)\zs.*\ze')
        let Name = Path
        while sublevel > 0
            let sublevel -= 1
            let line = search('^\(\s\s|\)\{'.sublevel.'}\s\[-\]-','bnW')
            let subPath = matchstr(getline(line),'^\(\s\s|\)*\s\[-\]-\zs.*\ze')
            let Path = subPath.'/'.Path
        endwhile
        let lineInfoList += [Path,Name]
    endif
    "return
    return lineInfoList
endfunction

function! s:Vailability()
    if bufname("%") =~ '\(_EVTree_\|_EVTreeBookmark_\)\d*'
        return 1
    endif
    return 0
endfunction

let s:File = {}

function! s:File.Open(...)
    let lineNr = line(".")
    let lineInfo = s:GetLineInfo(lineNr)
    if lineInfo[2] != "file"
        return
    endif
    let openMethod = "tabnew"
    if exists("a:1")
        if a:1 == "split"
            let openMethod = "silent keepalt botright vertical split"
        elseif a:1 == "edit"
            let openMethod = "edit"
        endif
    endif
    let fileTypesList = [
                \"rmvb","rm","avi","mp4","3gp","wmv","mkv","mpg","vob","mov","flv","swf","xv",
                \"mp3","wma","flac","aac","mmf","amr","m4a","m4r","ogg","mp2","wav",
                \"jpg","gif","bmp","png","ico","tif","pcx","tga",
                \"exe","dll","so","deb","iso","psd","chm","pdf","doc","docx","wps"
                \]
    let fileExt = tolower(matchstr(lineInfo[4],'[\.\|\\\|/]\zs[^\.\|\\\|/]\+\ze$'))
    if g:EVTreeResolveLinkfile && fileExt == "lnk"
        let fileExt = tolower(matchstr(resolve(lineInfo[3]),'[\.\|\\\|/]\zs[^\.\|\\\|/]\+\ze$'))
    endif
    if g:EVTreeOpenByDefault == 1 && index(fileTypesList,fileExt) != -1 && !exists("a:2")
        if (has("mac"))
            call system( "open \"" . lineInfo[3] . "\"")
        elseif (has("win32") || has("win32unix"))
            call system('cmd /q /c start "\""dummy title"\"" ' . "\"" . lineInfo[3] . "\"")
        elseif (has("unix"))
            call system("xdg-open \"" . lineInfo[3] . "\"")
        endif
    else
        if g:EVTreeResolveLinkfile && fileExt == "lnk"
            exe openMethod." ".resolve(lineInfo[3])
        else
            exe openMethod." ".lineInfo[3]
        endif
    endif
endfunction

function! s:File.Delete()
    let lineNr = line(".")
    let lineInfo = s:GetLineInfo(lineNr)
    if lineInfo[2] != "file"
        return
    endif
    let allowed = confirm("确定要删除吗?","&OK\n&No")
    if allowed != 1
        return
    endif
    let returnValue = delete(lineInfo[3])
    if returnValue == 0
        if !&modifiable
            setlocal modifiable
        endif
        exe "silent ".lineInfo[0]."d"
        if &modifiable
            setlocal nomodifiable
        endif
        exe 'echohl WarningMsg | echo "删除成功!"  | echohl None'
    else
        exe 'echohl WarningMsg | echo "删除失败!"  | echohl None'
    endif
endfunction

function! s:File.Rename()
    let lineNr = line(".")
    let lineInfo = s:GetLineInfo(lineNr)
    if lineInfo[2] == "unknown"
        return
    endif
    let newName = inputdialog("请输入新的名称:")
    if newName == ""
        return
    endif
    let Path = substitute(lineInfo[3],'[\\\|/]\zs[^\\\|/]\+\ze[\\\|/]\?$',newName,'')
    if rename(lineInfo[3],Path) == 0
        let newLine = substitute(getline(lineInfo[0]),'^\(\s\s|\)*\s\(\[+\]-\|\[-\]-\||--\)\zs.*\ze',newName,'')
        if !&modifiable
            setlocal modifiable
        endif
        call setline(lineInfo[0],newLine)
        if &modifiable
            setlocal nomodifiable
        endif
        exe 'echohl WarningMsg | echo "重命名成功!"  | echohl None'
    else
        exe 'echohl WarningMsg | echo "重命名失败!"  | echohl None'
    endif
endfunction

let s:Fold = {}

function! s:Fold.Open(...)
    let lineNr = exists("a:1") && type(a:1) == 0 ? a:1 : line(".")
    let lineInfo = s:GetLineInfo(lineNr)
    if lineInfo[2] != "closedFold"
        return
    endif
    if !&modifiable
        setlocal modifiable
    endif
    let TreesList = []
    let filesPathList = split(globpath(lineInfo[3]."/","*"),'\n')
    for filePath in filesPathList
        let fileName = matchstr(filePath,'[\\\|/]\zs[^\\\|/]\+\ze$')
        if fileName == "" || (exists("b:filter") && b:filter != "" && !isdirectory(lineInfo[3]."/".fileName) && fileName !~?  b:filter)
            continue
        endif
        if g:EVTreeShowDirOnly != 1 && filereadable(lineInfo[3]."/".fileName)
            let TreesList += [repeat('  |',lineInfo[1] + 1).' |--'.fileName]
        elseif isdirectory(lineInfo[3]."/".fileName)
            let TreesList += [repeat('  |',lineInfo[1] + 1).' [+]-'.fileName]
        endif
    endfor
    call setline(lineInfo[0],substitute(getline(lineInfo[0]),'^\(\s\s|\)*\zs\s\[+\]-\ze',' [-]-',''))
    call append(lineInfo[0],TreesList)
    if &modifiable
        setlocal nomodifiable
    endif
endfunction

function! s:Fold.Close(...)
    let lineNr = exists("a:1") && type(a:1) == 0 ? a:1 : line(".")
    let lineInfo = s:GetLineInfo(lineNr)
    if lineInfo[2] != "openFold"
        return
    endif
    if !&modifiable
        setlocal modifiable
    endif
    let cursorCol = col(".")
    let lineString = substitute(getline(lineInfo[0]),'^\(\s\s|\)*\s\zs\[-\]-\ze','[+]-','')
    call setline(lineInfo[0],lineString)
    let sublevel = lineInfo[1]
    let endLine = 0
    while sublevel >= 0
        let matchLine = search('^\(\s\s|\)\{'.sublevel.'}\s\(\[+\]-\|\[-\]-\||--\)','nW')
        if endLine == 0 || (matchLine !=0 && matchLine < endLine)
            let endLine = matchLine
        endif
        let sublevel -= 1
    endwhile
    if endLine == 0
        exe "silent ".(lineInfo[0] + 1).",$d"
    else
        if lineInfo[0] + 1 >= endLine
            return
        endif
        exe "silent ".(lineInfo[0] + 1).",".(endLine - 1)."d"
    endif
    call cursor(lineInfo[0],cursorCol)
    if &modifiable
        setlocal nomodifiable
    endif
endfunction

function! s:Fold.Delete()
    let lineNr = line(".")
    let lineInfo = s:GetLineInfo(lineNr)
    if lineInfo[2] != "openFold" && lineInfo[2] != "closedFold"
        return
    endif
    let allowed = confirm("确定删除吗 ?","&OK\n&No")
    if allowed != 1
        return
    endif
    if lineInfo[2] == "openFold"
        call self.Close(lineInfo[0])
    endif
    if s:GetPlatform() == "win"
        let RemoveDirCmd = 'rmdir /s /q "'.lineInfo[3].'"'
    else
        let RemoveDirCmd =  'rm -rf "'.lineInfo[3].'"'
    endif
    let returnvalue = system(RemoveDirCmd)
    if v:shell_error != 0
        exe 'echohl WarningMsg | echo "删除失败!"  | echohl None'
    else
        if !&modifiable
            setlocal modifiable
        endif
        exe "silent ".lineInfo[0]."d"
        if &modifiable
            setlocal nomodifiable
        endif
        exe 'echohl WarningMsg | echo "成功删除!"  | echohl None'
    endif
endfunction

function! s:Fold.Rename(...)
    call s:File.Rename()
endfunction

function! s:Fold.SearchByContents(...)
    let pattenStr = inputdialog("请输入要搜索的内容:")
    if pattenStr == ""
        return
    endif
    let lineNr = exists("a:1") && type(a:1) == 0 ? a:1 : line(".")
    let lineInfo = s:GetLineInfo(lineNr)
    if isdirectory(lineInfo[3])
        let targetFile = lineInfo[3]."/*"
    else
        let targetFile = lineInfo[3]
    endif
    try
        exe "vimgrep /".pattenStr."/j ".substitute(targetFile,'\s','\\\0','g')
        copen
    catch /.*/
        exe 'echohl WarningMsg | echo "未找到相关内容!"  | echohl None'
    endtry
endfunction

function! s:Fold.SearchByNames(...)
    let pattenStr = inputdialog("请输入要搜索的内容:")
    if pattenStr == ""
        return
    endif
    let lineNr = exists("a:1") && type(a:1) == 0 ? a:1 : line(".")
    let lineInfo = s:GetLineInfo(lineNr)
    if !isdirectory(lineInfo[3])
         exe 'echohl WarningMsg | echo "未找到相关内容!"  | echohl None' | return
    endif
    let filesPathList = split(globpath(lineInfo[3]."/","*"),'\n')
    let resultsDict = []
    for perFile in filesPathList
        let fileName = matchstr(perFile,'[\\\|/]\zs[^\\\|/]\+\ze$')
        if fileName =~? pattenStr
            let resultsDict += [{"filename":perFile,"lnum":1,"col":1,"text":fileName}]
        endif
    endfor
    call setqflist(resultsDict)
    if len(resultsDict) > 0
        copen
    else
        exe 'echohl WarningMsg | echo "未找到相关内容!"  | echohl None'
    endif
endfunction

let s:Bookmark = {}

function! s:Bookmark.Create()
    let tabNr = tabpagenr()
    if bufname("_EVTreeBookmark_") != "" || bufname("_EVTreeBookmark_".tabNr) != ""
        return
    endif
    if bufname("_EVTree_") != ""
        exe bufwinnr("_EVTree_")." wincmd w"
        silent keepalt bel split _EVTreeBookmark_
    elseif bufname("_EVTree_".tabNr) != ""
        exe bufwinnr("_EVTree_".tabNr)." wincmd w"
        exe "silent keepalt bel split _EVTreeBookmark_".tabNr
    else
        exe "silent keepalt topleft vertical ".g:EVTreeWinSize."split _EVTreeBookmark_"
    endif
    call self.SetOptions()
    call self.Mapkeys()
    call self.Init()
endfunction

function! s:Bookmark.Close()
    let bufNr = bufwinnr('_EVTreeBookmark_') == -1 ? bufwinnr('_EVTreeBookmark_'.tabpagenr()) : bufwinnr('_EVTreeBookmark_')
    if bufNr != -1
        execute bufNr ." wincmd w"
        if tabpagewinnr(tabpagenr(),"$") == 1 && tabpagenr("$") == 1
            q!
        else
            wincmd c
        endif
    endif
endfunction

function! s:Bookmark.Init()
    let BookmarkList = self.Bookmarks()
    if BookmarkList == []
        return
    endif
    let TreeList = []
    for bookmark in BookmarkList
        let part = split(bookmark,'|')
        if isdirectory(part[0])
            let TreeList += [' [+]-'.part[0]]
        else
            let TreeList += [' |--'.part[0]]
        endif
    endfor
    if !&modifiable
        setlocal modifiable
    endif
    1,$d
    call setline(1,TreeList)
    if &modifiable
        setlocal nomodifiable
    endif
endfunction

function! s:Bookmark.Add(...)
    if s:Vailability() == 0
        return
    endif
    let lineInfo = s:GetLineInfo(line("."))
    let bookmarkName = exists("a:1") && type(a:1) == 1 ? a:1 : lineInfo[4]
    let BookmarkList = self.Bookmarks()
    let i = 0
    for bookmark in BookmarkList
        let partList = split(bookmark,'^[^|]\+\zs|\ze')
        if partList[1] == bookmarkName
            if confirm("同名书签存在,确定覆盖吗?","&Yes\n&No") == 2
                return
            endif
            call remove(BookmarkList,i)
            break
        endif
        let i += 1
    endfor
    let BookmarkPath = self.GetPath()
    let BookmarkList += [lineInfo[3]."|".bookmarkName]
    if writefile(BookmarkList,BookmarkPath."/.bookmark") != -1
        echo "添加成功!"
    else
        echohl WarningMsg | echo "添加失败!"  | echohl None
    endif
endfunction

function! s:Bookmark.Delete(...)
    if s:Vailability() == 1
        let lineInfo = s:GetLineInfo(line("."))
        if exists("a:1")
            let bookmarkName = a:1
        elseif lineInfo[2] != "unknown"
            let bookmarkName = lineInfo[3]
        endif
    else
        if !exists("a:1")
            return
        endif
        let bookmarkName = a:1
    endif
    let BookmarkList = self.Bookmarks()
    let i = 0
    let founed = 0
    for bookmark in BookmarkList
        let bName = matchstr(bookmark,'^[^|]\+|\zs.*\ze')
        let bPath = matchstr(bookmark,'^\zs[^|]\+\ze')
        if bName == bookmarkName || bPath == bookmarkName
            let founed = 1
            call remove(BookmarkList,i)
            break
        endif
        let i += 1
    endfor
    let BookmarkPath = self.GetPath()
    if founed == 1 && writefile(BookmarkList,BookmarkPath."/.bookmark") != -1
        if !exists("a:1")
            setlocal modifiable
            let lineInfoList = s:GetLineInfo(line("."))
            if lineInfoList[2] == "file" || lineInfoList[2] == "closedFold"
                exe "silent ".lineInfoList[0]."d"
            elseif lineInfoList[2] == "openFold"
                call s:Fold.Close()
                exe "silent ".lineInfoList[0]."d"
            endif
            setlocal nomodifiable
        endif
        echo "成功删除!"
    else
        echohl WarningMsg | echo "删除失败!"  | echohl None
    endif
endfunction

function! s:Bookmark.SetOptions()
    call s:Tree.SetOptions()
    setlocal filetype="_EVTreeBookmark_"
    setlocal statusline=EVTreeBookmark
endfunction

function! s:Bookmark.Mapkeys()
    call s:Tree.Mapkeys()
    inoremap <silent> <buffer> <Del> <C-o>:call EVTreeDeleteBookmark()<CR>
    nnoremap <silent> <buffer> <Del> :call EVTreeDeleteBookmark()<CR>
    inoremap <silent> <buffer> dd <C-o>:call EVTreeDeleteBookmark()<CR>
    nnoremap <silent> <buffer> dd :call EVTreeDeleteBookmark()<CR>
endfunction

function! s:Bookmark.Bookmarks()
    let BookmarkPath = self.GetPath()
    if filereadable(BookmarkPath."/.bookmark")
        return readfile(BookmarkPath."/.bookmark")
    else
        return []
    endif
endfunction

function! s:Bookmark.GetPath()
    if exists("g:EVPath")
        let favPath = substitute(g:EVPath,'[\\\|/]\+\s*$','','g').'/EVTree/bookmark'
    endif
    if !exists("favPath")
        let favPath = exists("$HOME") ? $HOME.'/.easyvim/bookmark' : $VIMRUNTIME.'/EVTree/bookmark'
    endif
    if !isdirectory(favPath)
        call mkdir(favPath,'p')
    endif
    return favPath
endfunction

function! s:Bookmark.Refresh()
    call s:Bookmark.Init()
endfunction

let s:Tree = {}

function! s:Tree.Create()
    if bufname("_EVTree_") != "" || bufname("_EVTree_".tabpagenr()) != ""
        return
    endif
    let methodDict = {
                \"right": " botright vertical ",
                \"left": " topleft vertical ",
                \"up": " topleft ",
                \"bottom": " botright "
                \}
    let EVTreeBufname = "_EVTree_"
    if g:EVTreeCloneTreeInNewTab
        let EVTreeBufname .= tabpagenr()
    endif
    if bufname("_EVTreeBookmark_") != ""
        exe bufwinnr("_EVTreeBookmark_")." wincmd w"
        execute "silent keepalt split ".EVTreeBufname
    elseif bufname("_EVTreeBookmark_".tabpagenr()) != ""
        exe bufwinnr("_EVTreeBookmark_".tabpagenr())." wincmd w"
        execute "silent keepalt split ".EVTreeBufname
    else
        execute "silent keepalt ". methodDict[g:EVTreeWinLocation] . g:EVTreeWinSize ." split ".EVTreeBufname
    endif
    call self.SetOptions()
    call self.Mapkeys()
    call self.Init()
endfunction

function! s:Tree.Init()
    let Disks = [""]
    if s:GetPlatform() == "win"
        let Disks = ["A:","B:","C:","D:","E:","F:","G:","H:","I:","J:","K:","L:","M:","N:","O:","P:","Q:","R:","S:","T:","U:","V:","W:","X:","Y:","Z:"]
    endif
    let TreesList = []
    for disk in Disks
        if isdirectory(disk."/")
            let TreesList += [" [+]-".disk]
        endif
    endfor
    if !&modifiable
        setlocal modifiable
    endif
    1,$d
    call setline(1,TreesList)
    if &modifiable
        setlocal nomodifiable
    endif
endfunction

function! s:Tree.Close()
    let bufNr = bufwinnr('_EVTree_') == -1 ? bufwinnr('_EVTree_'.tabpagenr()) : bufwinnr('_EVTree_')
    if bufNr != -1
        execute bufNr ." wincmd w"
        if tabpagewinnr(tabpagenr(),"$") == 1 && tabpagenr("$") == 1
            q!
        else
            wincmd c
        endif
    endif
endfunction

function! s:Tree.SetOptions()
    setlocal noreadonly
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nobuflisted
    setlocal filetype="_EVTree_"
    setlocal nolist
    setlocal nowrap
    setlocal winfixwidth
    setlocal textwidth=0
    setlocal nocursorline
    setlocal nonu
    setlocal nocursorcolumn
    setlocal cursorline
    setlocal nohidden
    if exists('+relativenumber')
        setlocal norelativenumber
    endif
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal foldmethod&
    setlocal foldexpr&
    setlocal insertmode
    setlocal nomodifiable
    setlocal statusline=EVTree
endfunction

function! s:Tree.Mapkeys()
    inoremap <silent> <buffer> <2-leftMouse> <C-o>:call EVTreeOnClick()<CR>
    nnoremap <silent> <buffer> <2-leftMouse> :call EVTreeOnClick()<CR>
    inoremap <silent> <buffer> <CR> <C-o>:call EVTreeOnClick()<CR>
    nnoremap <silent> <buffer> <CR> :call EVTreeOnClick()<CR>
    inoremap <silent> <buffer> o <C-o>:call EVTreeOnClick()<CR>
    nnoremap <silent> <buffer> o :call EVTreeOnClick()<CR>
    inoremap <silent> <buffer> m <C-o>:call EVTreeAddBookmark()<CR>
    nnoremap <silent> <buffer> m :call EVTreeAddBookmark()<CR>
    inoremap <silent> <buffer> f <C-o>:call EVTreeRefresh()<CR>
    nnoremap <silent> <buffer> f :call EVTreeRefresh()<CR>
    inoremap <silent> <buffer> d <C-o>:call EVTreeDelete()<CR>
    nnoremap <silent> <buffer> d :call EVTreeDelete()<CR>
    inoremap <silent> <buffer> r <C-o>:call EVTreeRaname()<CR>
    nnoremap <silent> <buffer> r :call EVTreeRaname()<CR>
    inoremap <silent> <buffer> s <C-o>:call EVTreeSearch("names")<CR>
    nnoremap <silent> <buffer> s :call EVTreeSearch("names")<CR>
    inoremap <silent> <buffer> S <C-o>:call EVTreeSearch("contents")<CR>
    nnoremap <silent> <buffer> S :call EVTreeSearch("contents")<CR>
    inoremap <silent> <buffer> i <C-o>:call EVTreeOpen("split")<CR>
    nnoremap <silent> <buffer> i :call EVTreeOpen("split")<CR>
    inoremap <silent> <buffer> I <C-o>:call EVTreeOpen("tabnew","userDefault")<CR>
    nnoremap <silent> <buffer> I :call EVTreeOpen("tabnew","userDefault")<CR>
    inoremap <silent> <buffer> e <C-o>:call EVTreeOpen("edit")<CR>
    nnoremap <silent> <buffer> e :call EVTreeOpen("edit")<CR>
    inoremap <silent> <buffer> <C-leftMouse> <C-o>:call EVTreeOpen("tabnew","userDefault")<CR>
    nnoremap <silent> <buffer> <C-leftMouse> :call EVTreeOpen("tabnew","userDefault")<CR>
endfunction

function! s:Tree.Refresh()
    call s:Tree.Init()
endfunction

function! s:Tree.Filter()
    let defaultString = exists("b:filter") ? b:filter : ""
    let filterString = inputdialog("请输入过滤规则:",defaultString)
    let b:filter = filterString
    if filterString == ""
        return
    endif
    let lineNr = line("$")
    let perLine = 1
    while lineNr >= perLine
        let lineInfoList = s:GetLineInfo(perLine)
        let fileName = matchstr(lineInfoList[3],'[\\\|/]\zs[^\\\|/]\+\ze[\\\|/]\?$')
        if lineInfoList[2] == "file"
            if fileName !~ filterString
                if !&modifiable
                    setlocal modifiable
                endif
                exe "silent ".perLine.'d'
                let lineNr -= 1
                let perLine -= 1
                if &modifiable
                    setlocal nomodifiable
                endif
            endif
        endif
        let perLine += 1
    endwhile
endfunction

function! s:SetMenu()
    let valid = 0
    if bufname("%") =~ '\(_EVTree_\|_EVTreeBookmark_\)\d*'
        let valid = 1
    endif
    if valid == 1
            an <silent> 1.999.10  PopUp.EVTree.Refresh :call EVTreeRefresh()<CR>
            if bufname("%") =~ '_EVTree_\d*'
                an <silent> 1.999.20  PopUp.EVTree.Filter :call EVTreeFilter()<CR>
            endif
            an <silent> 1.999.20  PopUp.EVTree.Delete :call EVTreeDelete()<CR>
            an <silent> 1.999.30  PopUp.EVTree.Rename :call EVTreeRename()<CR>
            an <silent> 1.999.40  PopUp.EVTree.SearchByNames :call EVTreeSearch("names")<CR>
            an <silent> 1.999.50  PopUp.EVTree.SearchByContents :call EVTreeSearch("contents")<CR>
    else
        try | unmenu! PopUp.EVTree | catch /.*/ | endtry
    endif
endfunction

augroup EVFileExplore
  au!
  au MenuPopup * call s:SetMenu()
augroup END

"Map    {{{
inoremap <silent> <F6> <C-o>:call EVTreeToggle()<CR>
nnoremap <silent> <F6> :call EVTreeToggle()<CR>
inoremap <silent> <S-F6> <C-o>:call EVTreeToggleBookmark()<CR>
nnoremap <silent> <S-F6> :call EVTreeToggleBookmark()<CR>
"}}}

"Command    {{{
command! -n=0 EVTreeToggle :call EVTreeToggle()
command! -n=0 EVTreeBToggle :call EVTreeToggleBookmark()
command! -n=0 FileExplore :call EVTreeToggle()
"}}}
