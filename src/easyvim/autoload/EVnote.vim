" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVnote.vim
" Date : 2012/10/28 12:35:27

if exists("g:EVnote_autoload")
    finish
endif
let g:EVnote_autoload = 1

let s:Utility = {}

function! s:Utility.New()
    let Class = copy(self)
    let Class.type = "c"
    let Class.fileExt = "txt"
    let Class.fold = "EVnote"
    let Class.publicFileName = "public"
    return Class
endfunction

function! s:Utility.GetPath()
    let EasyVimPath = exists('g:EVPath') ? substitute(g:EVPath,'[/\|\\]\s*$','','g') : $VIMRUNTIME
    if !isdirectory(EasyVimPath."/".self.fold)
        try | call mkdir(EasyVimPath."/".self.fold,'p') | catch /.*/ |endtry
    endif
    return EasyVimPath."/". self.fold
endfunction

function! s:Utility.Readfile()
    let path = self.GetPath()
    let file = path."/".self.type.".".self.fileExt
    let publicFile = path."/".self.publicFileName.".".self.fileExt
    if filereadable(file)
        return readfile(file)
    elseif filereadable(publicFile)
        return readfile(publicFile)
    endif
    return []
endfunction

function! s:Utility.Eval(string)
    let string = a:string
    if type(string) != 1
        return ""
    endif
    if stridx(string, '`') != -1
        while match(string, '`.\{-}`') != -1
            try
                let string = substitute(string, '`.\{-}`',substitute(eval(matchstr(string, '`\zs.\{-}\ze`')),"\n\\%$", '', ''), '')
            catch /.*/
            endtry
        endwhile
        let string = substitute(string, "\r", "\n", 'g')
    endif
    if &et
        let string = substitute(string, '\t', repeat(' ', &sts ? &sts : &sw), 'g')
    endif
    return string
endfunction

function! s:Utility.GetPattenlist(stringList)
    let stringList = a:stringList
    if type(stringList) != 3
        return []
    endif
    let pattenList = []
    let setPatten = 0
    let i = 0
    for lineString in stringList
        let i += 1
        if setPatten == 1
            if lineString =~ '^\t' || lineString == "" || lineString =~ '^\s\{4}'
                let docs += [matchstr(lineString,'^\(\t\|\s\{4}\)\zs.*\ze')]
            endif
        endif
        if lineString =~ '^patten\s' || i == len(stringList)
            if setPatten
                let pattenList += [[patten,docs]]
            endif
            let patten = matchstr(lineString,'^patten\s\+\zs.*\ze')
            let setPatten = 1
            let docs = []
        endif
    endfor
    return pattenList
endfunction

let s:Comments = {}

function! s:Comments.New()
    let Class = copy(self)
    call extend(Class,s:Utility.New(),"keep")
    let Class.lineList = [line("."),line("'<"),line("'>")]
    let Class.colList = [col("."),col("'<"),col("'>")]
    let Class.status = "i"
    let Class.notation = ["/**"," *"," */","//"]
    return Class
endfunction

function! s:Comments.InsertWrapComments(pattenList)
    let notation = [self.notation[0],self.notation[1],self.notation[2]]
    if self.notation[0] == "" || self.notation[2] == ""
        let notation = [self.notation[3],self.notation[3],self.notation[3]]
    endif
    let indent = indent(self.lineList[1])
    for lineNr in range(self.lineList[1],self.lineList[2])
        if indent(lineNr) < indent
            let indent = indent(lineNr)
        endif
    endfor
    for lineNr in range(self.lineList[1],self.lineList[2])
        let lineStr = getline(lineNr)
        if indent(lineNr) > indent
            let lineStr = repeat(" ",indent).notation[1].eval("lineStr[".indent.":]")
        else
            let lineStr = matchstr(lineStr,'^\s*').notation[1].substitute(lineStr,'^\s*','','')
        endif
        call setline(lineNr,lineStr)
    endfor
    if self.notation[0] != "" && self.notation[2] != ""
        call append(self.lineList[2], repeat(" ",indent).notation[2])
        call append(self.lineList[1] - 1, repeat(" ",indent).notation[0])
    endif
endfunction

function! s:Comments.DeleteWrapComments(pattenList)
    let notation = a:pattenList[1]
    if self.notation[0] == "" || self.notation[2] == ""
        let notation = a:pattenList[3]
    endif
    for lineNr in range(self.lineList[1],self.lineList[2])
        call setline(lineNr,substitute(getline(lineNr),'^\s*\zs'.notation.'\ze','',''))
    endfor
    if self.notation[0] != "" && self.notation[2] != ""
        exe self.lineList[2].'d'
        exe self.lineList[1].'d'
    endif
endfunction

function! s:Comments.ToggleWrapComments()
    let pattenList = [self.notation[0],self.notation[1],self.notation[2],self.notation[3]]
    call map(pattenList,"s:sub(v:val)")
    if self.notation[0] == "" || self.notation[2] == ""
        for lineNr in range(self.lineList[1],self.lineList[2])
            if getline(lineNr) !~ '^\s*'.pattenList[3]
                call self.InsertWrapComments(pattenList) | return
            endif
        endfor
    else
        if getline(self.lineList[1]) !~ '^\s*'.pattenList[0].'\s*' || getline(self.lineList[2]) !~ '^\s*'.pattenList[2].'\s*$'
            call self.InsertWrapComments(pattenList) | return
        endif
    endif
    call self.DeleteWrapComments(pattenList)
endfunction

function! s:Comments.InsertNestComments(strList)
    let strList = a:strList
    let str = strList[0].self.notation[0].strList[1].self.notation[2].strList[2]
    call setline(self.lineList[0],str)
endfunction

function! s:Comments.DeleteNestComments(strList,pattenList)
    let strList = a:strList
    let pattenList = a:pattenList
    let midStr = substitute(substitute(strList[1],'^\s*'.pattenList[0],'',''),pattenList[1].'\s*$','','')
    call setline(self.lineList[0],strList[0].midStr.strList[2])
endfunction

function! s:Comments.ToggleNestComments()
    if self.notation[0] == '' || self.notation[2] == ''
        call self.ToggleHeadComments() | return
    endif
    let lineStr = getline(self.lineList[0])
    let leftColNr = col("'<")-(&selection == 'exclusive' ? 1 : 0)
    let rightColNr = col("'>")-(&selection == 'exclusive' ? 1 : 0)
    let midStrLength = col("'>") - col("'<")
    let leftStr = strpart(lineStr,0,leftColNr)
    let rightStr = strpart(lineStr,rightColNr)
    let midStr = strpart(lineStr,leftColNr,midStrLength)
    let leftPatten = s:sub(self.notation[0])
    let rightPatten = s:sub(self.notation[2])
    let patten = '\m^\s*'.leftPatten.'.*'.rightPatten.'\s*$'
    let strList = [leftStr,midStr,rightStr]
    if midStr =~ patten
        call self.DeleteNestComments(strList,[leftPatten,rightPatten])
    else
        call self.InsertNestComments(strList)
    endif
endfunction

function! s:Comments.InsertHeadComments()
    let lineStr = getline(self.lineList[0])
    let spaceStr = matchstr(lineStr,'^\zs\s*\ze')
    let noSpaceStr = matchstr(lineStr,'^\s*\zs.*\ze')
    if self.notation[3] != ""
        let lineStr = spaceStr.self.notation[3].noSpaceStr
        call setline(self.lineList[0],lineStr)
    elseif self.notation[0] != "" && self.notation[2] != ""
        exe self.lineList[0]."d"
        let lineStr = spaceStr.self.notation[1].noSpaceStr
        call append(self.lineList[0] - 1,[self.notation[0],lineStr,self.notation[2]])
    endif
endfunction

function! s:Comments.DeleteHeadComments()
    let lineStr = getline(self.lineList[0])
    let patten = '\m^\s*\zs'.s:sub(self.notation[3]).'\ze'
    call setline(self.lineList[0],substitute(lineStr,patten,'','g'))
endfunction

function! s:Comments.ToggleHeadComments()
    if getline(self.lineList[0]) !~ '\m^\s*'.self.notation[3]
        call self.InsertHeadComments()
    else
        call self.DeleteHeadComments()
    endif
endfunction

function! s:Comments.ToggleComments()
    if self.status == "i"
        call self.ToggleHeadComments()
    elseif self.status == "v"
        call self.ToggleNestComments()
    elseif self.status == "s"
        call self.ToggleWrapComments()
    endif
endfunction

function! s:Comments.InsertBlackslash()
    if self.status == "i"
        call setline(self.lineList[0],getline(self.lineList[0])."\\")
    else
        for lineNr in range(self.lineList[1],self.lineList[2])
            call setline(lineNr,getline(lineNr)."\\")
        endfor
    endif
endfunction

function! s:Comments.DeleteBlackslash()
    if self.status == "i"
        call setline(self.lineList[0],substitute(getline(self.lineList[0]),'\zs\\\ze\s*$','',''))
    else
        for lineNr in range(self.lineList[1],self.lineList[2])
            call setline(lineNr,substitute(getline(lineNr),'\zs\\\ze\s*$','',''))
        endfor
    endif
endfunction

function! s:Comments.ToggleBlackslash()
    if (self.status == "i" || self.status == "v") && getline(self.lineList[0]) =~ '\\$'
        call self.DeleteBlackslash()
    elseif self.status == "s" && getline(self.lineList[1]) =~ '\\$' && getline(self.lineList[2]) =~ '\\$'
        call self.DeleteBlackslash()
    else
        call self.InsertBlackslash()
    endif
endfunction

function! s:Comments.InsertCopyright()
    let CpList = self.Readfile()
    let NewCpList = []
    for Cp in CpList
        let NewCpList += [self.Eval(Cp)]
    endfor
    if NewCpList == []
        return
    endif
    if getline(1) == NewCpList[0] && getline(len(NewCpList)) == NewCpList[-1]
        call setline(1,NewCpList)
    else
        call append(0,NewCpList)
    endif
endfunction

function! s:Comments.UpdateCopyright()
    let CpList = self.Readfile()
    let NewCpList = []
    for Cp in CpList
        let NewCpList += [self.Eval(Cp)]
    endfor
    if NewCpList == []
        return
    endif
    if getline(1) == NewCpList[0] && getline(len(NewCpList)) == NewCpList[-1]
        call setline(1,NewCpList)
    endif
endfunction

function! s:Comments.DeleteCopyright()
endfunction

function! s:Comments.ToggleCopyright()
    call self.InsertCopyright()
endfunction

function! s:Comments.InsertUserDefined()
    let UDList = self.Readfile()
    let NewUDList = []
    for UD in UDList
        let NewUDList += [self.Eval(UD)]
    endfor
    let insertLine = self.lineList[0] - 1
    call append(insertLine,UDList)
endfunction

function! s:Comments.DeleteUserDefined()
endfunction

function! s:Comments.ToggleUserDefined()
    if self.status == "i" || self.status == "v"
        call self.InsertUserDefined()
    endif
endfunction

function! s:Comments.InsertDoc()
    if self.status != "i"
        return
    endif
    let cursorLine = self.lineList[0]
    let insertLine = self.lineList[0] - 1
    let patternList = self.GetPattenlist(self.Readfile())
    for [patten,docs] in patternList
        if getline(cursorLine) =~ patten
            let List =[]
            for doc in docs
                let List += [self.Eval(doc)]
            endfor
            let fline = cursorLine - len(List)
            if getline(fline) == List[0] && getline(insertLine) == List[-1]
                call setline(fline,List) | break
            else
                call append(insertLine,List) | break
            endif
        endif
    endfor
endfunction

function! s:Comments.DeleteDoc()
endfunction

function! s:Comments.ToggleDoc()
    call self.InsertDoc()
endfunction

function! s:Comments.InsertLineNum()
    if self.status == "i"
        call setline(self.lineList[0],self.lineList[0].getline(self.lineList[0]))
    else
        for lineNr in range(self.lineList[1],self.lineList[2])
            call setline(lineNr,lineNr.getline(lineNr))
        endfor
    endif
endfunction

function! s:Comments.DeleteLineNum()
    if self.status == "i"
        if getline(self.lineList[0]) =~ '^'.self.lineList[0]
            call setline(self.lineList[0],substitute(getline(self.lineList[0]),'^'.self.lineList[0],'',''))
        endif
    else
        for lineNr in range(self.lineList[1],self.lineList[2])
            if getline(lineNr) =~ '^'.lineNr
                call setline(lineNr,substitute(getline(lineNr),'^'.lineNr,'',''))
            endif
        endfor
    endif
endfunction

function! s:Comments.ToggleLineNum()
    if self.status == "s"
        let checkLine = self.lineList[1]
    else
        let checkLine = self.lineList[0]
    endif
    if getline(checkLine) =~ '^'.checkLine
        call self.DeleteLineNum()
    else
        call self.InsertLineNum()
    endif
endfunction

function! s:sub(val)
    return substitute(a:val,'[\$\|\.\|\*\|\\\|\^\|\[\|\]]','\\\0','g')
endfunction

function! s:GetStatus()
    if line("'<") != line("'>") && col('.') == 1 && col('v') == 1
        return "s"
    elseif line("'<") == line("'>") && line('.') == line("'<") && col('.') == 1 && col('v') == 1
        return "v"
    else
        return "i"
    endif
endfunction

function! EVnote#Toggle(funcName,status,isPreLine) range
    let status = a:status
    if index(["i","v","s"],status) == -1
        let status = s:GetStatus()
    endif
    let Class = s:Comments.New()
    let Class.status = status
    if a:isPreLine
        let Class.lineList = [line(".") - 1,line("'<"),line("'>")]
    endif
    let Class.type = expand("%:e")== "" ? &ft : tolower(expand("%:e"))
    if Class.type == ""
        let Class.type = "c"
    endif
    let Class.fold = "EVnote/".a:funcName
    if exists("g:EVCommentDict['notation']") && has_key(g:EVCommentDict['notation'],Class.type)
        let Class.notation = g:EVCommentDict['notation'][Class.type]
    endif
    let Func = "Class.".a:funcName."()"
    call eval(Func)
endfunction

function! EVnote#Format(isPreLine) range
    let Class = s:Utility.New()
    let Class.type = expand("%:e")== "" ? &ft : tolower(expand("%:e"))
    if Class.type == ""
        let Class.type = "c"
    endif
    let Class.fold = "EVnote/format"
    let pattenList = Class.GetPattenlist(Class.Readfile())
    let lineNr = a:isPreLine ? (line(".") - 1) : line(".")
    let string = getline(lineNr)
    for [patten,valueList] in pattenList
        let string = substitute(string,patten,Class.Eval(join(valueList,' ')),'g')
    endfor
    call setline(lineNr,string)
endfunction
