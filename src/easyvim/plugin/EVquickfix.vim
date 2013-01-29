" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVquickfix.vim
" Date : 2012/2/24 12:28:00

function! s:GetPath(subpath,filename)
    let Path = exists("g:EVPath") ? substitute(g:EVPath,'[\\\|/]\+\s*$','','g') :
                \exists("$HOME") ? $HOME : $VIMRUNTIME
    let Path .= "/".a:subpath
    if !isdirectory(Path)
        call mkdir(Path,'p')
    endif
    let Path .= "/".a:filename
    return substitute(Path,'\\','/','g')
endfunction

function! s:hasQuickfix()
    let tabWinCounts = tabpagewinnr(tabpagenr(),"$")
    let hasqf = [0,0]
    for Nr in range(1,tabWinCounts)
        if getwinvar(Nr,'&bt') == 'quickfix'
            let hasqf = [1,Nr] | break
        endif
    endfor
    return hasqf
endfunction

let s:Fav = {}
function s:Fav.New()
    let Class = copy(self)
    let Class.file = s:GetPath("EVquickfix/fav","fav.txt")
    let Class.favs = []
    return Class
endfunction

function! s:Fav.Add()
    if &bt == "quickfix" || &bt == "nofile" || &bt == "nowrite"
        echomsg "此类缓冲区不能添加进收藏夹!"
    endif
    let title = inputdialog("请输入收藏名称:",expand("<cword>"))
    if title == '' | return | endif
    if substitute(title,'\s','','g') == ''
        let title = bufname("%").localtime()
    endif
    let i = 0
    let favs = self.favs
    for fav in favs
        if fav[3] == title
            call remove(favs,i) | break
        endif
        let i += 1
    endfor
    let favs += [[expand("%:p"),line("."),col("."),title]]
    let favsString = []
    for favInfo in favs
        let favsString += [join(favInfo,"|")]
    endfor
    try
        call writefile(favsString,self.file)
        let quickfixVar = s:hasQuickfix()
        if  quickfixVar[0] == 1 && getwinvar(quickfixVar[1],"&statusline") == "[Quickfix-Fav]"
            call self.SetFavs()
            call self.Show("")
        endif
        echomsg "Successed!"
    catch /.*/
        echomsg "Failed!"
    endtry
endfunction

function! s:Fav.Delete(isAll)
    if a:isAll == 1
        let isOk = confirm("你确定删除此收藏吗?","&Yes\n&No")
        if isOk != 1 | return | endif
        if delete(self.file) == 0
            call self.Toggle()
            echomsg "Succeeded!" | return
        else
            echomsg "Failed!" | return
        endif
    endif
    let favname = inputdialog("请输入要删除的收藏名称:")
    if favname == "" | return | endif
    let favsString = []
    for favInfo in self.favs
        if favInfo[3] != favname
            let favsString += [join(favInfo,"|")]
        endif
    endfor
    try
        call writefile(favsString,self.file)
        let quickfixVar = s:hasQuickfix()
        if  quickfixVar[0] == 1 && getwinvar(quickfixVar[1],"&statusline") == "[Quickfix-Fav]"
            call self.SetFavs()
            call self.Show("")
        endif
        echomsg "成功删除!"
    catch /.*/
        echomsg "未能删除!"
    endtry
endfunction

function! s:Fav.Search()
    let favname = inputdialog("请输入要查找的收藏名称:")
    if favname == "" | return | endif
    let patten = substitute(favname,'\(\$\|\.\|\*\|\\\|\^\|\[\|\]\)','\\\0','g')
    let foundedList = []
    for favInfo in self.favs
        if matchstr(favInfo[3],patten) != ''
            let foundedList += [favInfo]
        endif
    endfor
    if foundedList == []
        echomsg "未能找到相应内容!"
    else
        let favsInQf = []
        for favInfo in foundedList
            let favsInQf += [{"filename":favInfo[0],"lnum":favInfo[1],"col":favInfo[2],"text":favInfo[3]}]
        endfor
        call setqflist(favsInQf)
        if favsInQf != []
            copen
            setlocal statusline=[Quickfix-Fav]
        endif
    endif
endfunction

function! s:Fav.Show(filter)
    let favsInQf = []
    if a:filter == "local"
        for fav in self.favs
            if fav[0] == expand("%:p")
                let favsInQf += [fav]
            endif
        endfor
    endif
    if favsInQf == []
        let favsInQf = self.favs
    endif
    let qfInfoList = []
    for fav in favsInQf
        let qfInfoList += [{"filename":fav[0],"lnum":fav[1],"col":fav[2],"text":fav[3]}]
    endfor
    call setqflist(qfInfoList)
    if qfInfoList != []
        copen
        setlocal statusline=[Quickfix-Fav]
    endif
endfunction

function! s:Fav.SetFavs()
    let file = self.file
    let favsInfo = []
    if filereadable(file)
        let favsInfo = readfile(file)
        for fav in favsInfo
            call filter(favsInfo,'v:val =~ "[^|]\\+|\\s*\\d\\+\\s*|\\s*\\d\\+\\s*|.*"')
        endfor
    endif
    let favs = []
    for fav in favsInfo
        let infoList = matchlist(fav,'^\([^|]\+\)|\s*\(\d\+\)\s*|\s*\(\d\+\)\s*|\(.*\)')
        "filepath|lineNum|colNum|favName
        let favs += [[infoList[1],infoList[2],infoList[3],infoList[4]]]
    endfor
    let self.favs = favs
endfunction

function! s:Fav.Toggle(...)
    let quickfixVar = s:hasQuickfix()
    if  (quickfixVar[0] == 1 && getwinvar(quickfixVar[1],"&statusline") != "[Quickfix-Fav]")
                \ || quickfixVar[0] == 0
        let type = exists("a:1") ? a:1 : "global"
        call self.Show(type) | return
    endif
    cclose
endfunction

function! s:Fav.Init()
    call self.SetFavs()
endfunction

let s:Mark = {}
function! s:Mark.New()
    let Class = copy(self)
    let Class.signs = []
    let Class.Marks = []
    return Class
endfunction

function! s:Mark.SetSigns()
    redir => signString
       silent exec "sign place buffer=".bufnr("%")
    redir END
    let signList = split(signString, '\n')
    call filter(signList, "v:val =~ '^\\s\\+[^=]\\+=[^=]\\+\\s\\+[^=]\\+=[^=]\\+\\s\\+[^=]\\+=.*'")
    let signs = []
    for var in signList
        let formatList = matchlist(var,'^\s\+[^=]\+=\([^=]\+\)\s\+[^=]\+=\([^=]\+\)\s\+[^=]\+=\(.*\)')
        "line,id,define
        let signs += [[formatList[1],formatList[2],formatList[3]]]
    endfor
    let self.signs = signs
endfunction

function! s:Mark.SetMarks()
    redir => markString
       silent marks
    redir END
    let markList = split(markString,'\n')
    call filter(markList,'v:val =~ "\\d"')
    let marks = []
    for str in markList
        if str =~ '^\s*.\s\+\d\+\s\+\d\+\s\+'
            let formatList = matchlist(str,'^\s*\(.\)\s\+\(\d\+\)\s\+\(\d\+\)\s\+\(.*\)')
            "filename,line,col,markname
            if formatList[1] =~# '[A-Z0-9]'
                if filereadable(formatList[4])
                    let marks += [[formatList[4],formatList[2],formatList[3],formatList[1]]]
                else
                    let marks += [[expand("%:p"),formatList[2],formatList[3],formatList[1]]]
                endif
            else
                let marks += [[expand("%:p"),formatList[2],formatList[3],formatList[1]]]
            endif
        endif
    endfor
    let self.Marks = marks
endfunction

function! s:Mark.Show()
    let qfInfoList = []
    for markInfo in self.Marks
        let qfInfoList += [{"filename":markInfo[0],"lnum":markInfo[1],"col":markInfo[2],"text":markInfo[3]}]
    endfor
    call setqflist(qfInfoList)
    copen
    setlocal statusline=[Quickfix-Mark]
endfunction

function! s:Mark.ToggleSign()
    for markInfo in self.Marks
        if markInfo[0] == expand("%:p") && markInfo[1] == line(".")
                    \&& markInfo[3] =~# '[0-9a-zA-Z]'
            let markInfoList = markInfo | break
        endif
    endfor
    for signInfo in self.signs
        if signInfo[0] == line(".")
            let signInfoList = signInfo | break
        endif
    endfor
    if exists("markInfoList") && exists("signInfoList")
        exe "delmarks ".markInfoList[3]
        exe "sign unplace ".signInfoList[0]." buffer=".bufnr("%")
        exe "sign undefine ".signInfoList[0]
    elseif exists("markInfoList") && !exists("signInfoList")
        call self.DeleteSpecificSign(markInfoList[3])
        exe "sign define ".line(".")."  text=".markInfoList[3]." texthl=Normal"
        exe "sign place ".line(".")." line=".line(".")." name=".line(".")." buffer=".bufnr("%")
    elseif !exists("markInfoList") && exists("signInfoList")
        exe "mark ".signInfoList[1]
    else
        let markLetterList = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    \"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                    \]
        for markN in self.Marks
            let letterIndex= index(markLetterList,markN[3])
            if  letterIndex != -1
                call remove(markLetterList,letterIndex)
            endif
        endfor
        if markLetterList != []
            exe "mark ".markLetterList[0]
            exe "sign define ".line(".")."  text=".markLetterList[0]." texthl=Normal"
            exe "sign place ".line(".")." line=".line(".")." name=".line(".")." buffer=".bufnr("%")
            call self.DeleteSpecificSign(markLetterList[0])
        endif
    endif
endfunction

function! s:Mark.DeleteSpecificSign(text)
    for Sign in self.signs
        if Sign[2] == a:text
            exe "sign unplace ".Sign[1]." buffer=".bufnr("%")
            exe "sign undefine ".Sign[1]
        endif
    endfor
endfunction

function! s:Mark.ToggleMark()
    let quickfixVar = s:hasQuickfix()
    if  (quickfixVar[0] == 1 && getwinvar(quickfixVar[1],"&statusline") != "[Quickfix-Mark]")
                \ || quickfixVar[0] == 0
        call self.Show() | return
    endif
    cclose
endfunction

function! s:Mark.Init()
    call self.SetSigns()
    call self.SetMarks()
endfunction


let s:Tag = {}
function! s:Tag.New()
    let Class = copy(self)
    let Class.Tags = []
    return Class
endfunction

function! s:Tag.Show()
    let qfInfoList = []
    for TagInfo in self.Tags
        let lineNr = TagInfo[1] == 0 ? 1 : TagInfo[1]
        let qfInfoList += [{"filename":TagInfo[0],"lnum":lineNr,"text":TagInfo[2]}]
    endfor
    call setqflist(qfInfoList)
    copen
    setlocal statusline=[Quickfix-Tag]
endfunction

function! s:Tag.SetTags()
    redir => TagsString
        silent! tags
    redir END
    let TagsList = split(TagsString,'\n')
    call filter(TagsList,"v:val =~ '[0-9]'")
    let Tags = []
    for Tag in TagsList
        let lineNr = matchstr(Tag,'^>\?\s*\d\+\s\+\d\+\s\+[^\s]\+\s\+\zs\d\+\ze')
        let file = matchstr(Tag,'^>\?\s*\d\+\s\+\d\+\s\+[^\s]\+\s\+\d\+\s\+\zs.*\ze')
        if !filereadable(file)
            let file = expand("%:p")
        endif
        "filename,line,text
        let Tags += [[file,lineNr,Tag]]
    endfor
    let self.Tags = Tags
endfunction

function! s:Tag.Toggle()
    let quickfixVar = s:hasQuickfix()
    if  (quickfixVar[0] == 1 && getwinvar(quickfixVar[1],"&statusline") != "[Quickfix-Tag]")
                \ || quickfixVar[0] == 0
        call self.Show() | return
    endif
    cclose
endfunction

function! s:Tag.Init()
    call self.SetTags()
endfunction


let s:Buffer = {}

function! s:Buffer.New()
    let Class = copy(self)
    let Class.Buffers = []
    return Class
endfunction

function! s:Buffer.Show()
    let qfInfoList = []
    for bufferInfo in self.Buffers
        let lineNr = bufferInfo[1] == 0 ? 1 : bufferInfo[1]
        let qfInfoList += [{"bufnr":bufferInfo[0],"lnum":lineNr,"text":bufferInfo[2]."(".bufferInfo[0].")"}]
    endfor
    call setqflist(qfInfoList)
    copen
    setlocal statusline=[Quickfix-Buffer]
endfunction

function! s:Buffer.SetBuffers()
    silent! redir => BuffersString
       silent! buffers!
    silent! redir END
    let BuffersList = split(BuffersString,'\n')
    call filter(BuffersList,"v:val =~ '[0-9]'")
    let Buffers = []
    for Buffer in BuffersList
        let BufferNr = matchstr(Buffer,'^\s*\zs\d\+\ze')
        let lineNr = matchstr(Buffer,'\zs\(\d\+\)\ze[^0-9]*$')
        let text = matchstr(Buffer,'"\zs[^"]*\ze"')
        let Buffers += [[BufferNr,lineNr,text]]
    endfor
    let self.Buffers = Buffers
endfunction

function! s:Buffer.Toggle()
    let quickfixVar = s:hasQuickfix()
    if  (quickfixVar[0] == 1 && getwinvar(quickfixVar[1],"&statusline") != "[Quickfix-Buffer]")
                \ || quickfixVar[0] == 0
        call self.Show() | return
    endif
    cclose
endfunction

function! s:Buffer.Init()
    call self.SetBuffers()
endfunction

function! EVquickfix(class,func,arg)
    let class = "s:".a:class.".New()"
    let Class = eval(class)
    call Class.Init()
    let func = "Class.".a:func."(".a:arg.")"
    call eval(func)
endfunction

function! ToogleQuickfix()
    let hasqf = s:hasQuickfix()
    if hasqf[0] == 1
        cclose
    else
        copen
    endif
endfunction

set switchbuf=newtab
"MAP {{{
inoremap <silent> <F4>      <C-o>:call EVquickfix("Mark","ToggleSign","")<CR>
nnoremap <silent> <F4>      :call EVquickfix("Mark","ToggleSign","")<CR>
inoremap <silent> <S-F4>    <C-o>:call EVquickfix("Mark","ToggleMark","")<CR>
nnoremap <silent> <S-F4>    :call EVquickfix("Mark", "ToggleMark", "")<CR>
inoremap <silent> <S-F5>    <C-o>:call ToogleQuickfix()<CR>
nnoremap <silent> <S-F5>    :call ToogleQuickfix()<CR>
inoremap <silent> <F7>      <C-o>:call EVquickfix("Fav","Add","")<CR>
nnoremap <silent> <F7>      :call EVquickfix("Fav","Add","")<CR>
inoremap <silent> <S-F7>    <C-o>:call EVquickfix("Fav","Toggle","")<CR>
nnoremap <silent> <S-F7>    :call EVquickfix("Fav", "Toggle", "")<CR>
inoremap <silent> <S-F8>    <C-o>:call EVquickfix("Tag","Toggle","")<CR>
nnoremap <silent> <S-F8>    :call EVquickfix("Tag","Toggle","")<CR>
inoremap <silent> <S-F9>    <C-o>:call EVquickfix("Buffer", "Toggle", "")<CR>
nnoremap <silent> <S-F9>    :call EVquickfix("Buffer","Toggle","")<CR>
inoremap <silent> <Leader>ff <C-o>:call EVquickfix("Fav","Toggle","")<CR>
nnoremap <silent> <Leader>ff :call EVquickfix("Fav","Toggle","")<CR>
inoremap <silent> <Leader>df <C-o>:call EVquickfix("Fav","Delete","0")<CR>
nnoremap <silent> <Leader>df :call EVquickfix("Fav","Delete","0")<CR>
inoremap <silent> <Leader>da <C-o>:call EVquickfix("Fav","Delete","1")<CR>
nnoremap <silent> <Leader>da :call EVquickfix("Fav","Delete","1")<CR>
inoremap <silent> <Leader>sf <C-o>:call EVquickfix("Fav","Search","")<CR>
nnoremap <silent> <Leader>sf :call EVquickfix("Fav","Search","")<CR>
inoremap <silent> <Leader>bb <C-o>:call EVquickfix("Buffer","Toggle","")<CR>
nnoremap <silent> <Leader>bb :call EVquickfix("Buffer","Toggle","")<CR>
inoremap <silent> <Leader>mm <C-o>:call EVquickfix("Mark","ToggleMark","")<CR>
nnoremap <silent> <Leader>mm :call EVquickfix("Mark","ToggleMark","")<CR>
inoremap <silent> <Leader>s <C-o>:call EVquickfix("Mark","ToggleSign","")<CR>
nnoremap <silent> <Leader>s :call EVquickfix("Mark","ToggleSign","")<CR>
inoremap <silent> <Leader>tt <C-o>:call EVquickfix("Tag","Toggle","")<CR>
nnoremap <silent> <Leader>tt :call EVquickfix("Tag","Toggle","")<CR>
"}}}

"Menu {{{
an <silent> 30.50.10 &View.Bookmark.Add\ Bookmark               :call EVquickfix("Fav","Add","")<CR>
an <silent> 30.50.20 &View.Bookmark.Toggle\ Bookmark            :call EVquickfix("Fav","Toggle","")<CR>
an <silent> 30.50.30 &View.Bookmark.Delete\ Bookmark            :call EVquickfix("Fav","Delete","0")<CR>
an <silent> 30.50.40 &View.Bookmark.Search\ Bookmark            :call EVquickfix("Fav","Search","")<CR>

an <silent> 30.60.10 &View.Other\ Windows.Toggle\ Buffer           :call EVquickfix("Buffer","Toggle","")<CR>
an <silent> 30.60.20 &View.Other\ Windows.Toggle\ Mark             :call EVquickfix("Mark","ToggleMark","")<CR>
an <silent> 30.60.30 &View.Other\ Windows.Toggle\ Tag              :call EVquickfix("Tag","Toggle","")<CR>

an <silent> 1.140 PopUp.Toggle\ Sign                            :call EVquickfix("Mark","ToggleSign","")<CR>
inoremenu <silent> 1.150 PopUp.Add\ Bookmark                    <C-o>:call EVquickfix("Fav","Add","")<CR>
"}}}
