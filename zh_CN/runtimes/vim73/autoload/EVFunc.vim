" For EasyVim Project
" Maintainer:   HeSheng <sheng.he.china@gmail.com>
" Last Change:  2012/01/15


if exists('g:EVFunc')
    finish
endif
let g:EVFunc = '1.0'
function! EVFunc#SetEVPlugin(...)
    if exists('a:2') && substitute(a:2,'\s','','g') != ''
        let EasyVimPath = a:2
    elseif exists('g:EVPath') && substitute(g:EVPath,'\s','','g') != ''
        let EasyVimPath = g:EVPath
    else
        let EasyVimPath = $VIM.'/easyvim'
    endif
    if exists('a:1') && a:1 == ''
        let PluginPath = a:1
    elseif exists('g:EVPluginPath')
        let PluginPath = g:EVPluginPath
    else
        let PluginPath = 'runtime'
    endif
    let EasyVimPath = substitute(EasyVimPath,'[\\\|/]\+\s*$','','g')
    let PluginPath = substitute(substitute(PluginPath,'^\s*[\\\|/]\+','','g'),'[\\\|/]\+\s*$','','g')
    let expandPath = substitute(EasyVimPath.'/'.PluginPath.'/','\\','/','g')

    if !isdirectory(expandPath)
        try
            call mkdir(expandPath,'p')
        catch '.*'
            return
        endtry
    endif
    let pluginList = split(globpath(expandPath,'*/'),'\n')
    let subDirNameList =[]
    for val in pluginList
        let subDirName = matchstr(substitute(val,'\\','/','g'),'\zs[^/]*\ze/\{0,1}$')
        let subDirNameList += [subDirName]
    endfor
    let runtimepathList = split(&runtimepath,',')
    call map(runtimepathList,"substitute(v:val,'\\','/','g')")
    for val in subDirNameList
        if index(runtimepathList,substitute(expandPath.val,'\\','/','g')) == -1
            exe 'set runtimepath +='.substitute(EasyVimPath.'/'.PluginPath.'/'.val,'\s','\\\0','g')
        endif
    endfor
    unlet PluginPath EasyVimPath runtimepathList subDirNameList expandPath
endfunction

function! EVFunc#diff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

function! EVFunc#Sys()
    if has("win16") || has("win32") || has("win64") || has("win95")
        return "windows"
    elseif has("unix")
        return "linux"
    elseif has("mac")
        return "mac"
    endif
endfunction
function! EVFunc#enlargeWin()
    if &bt == "nofile" || &bt == "nowrite"
        return
    endif
    wincmd _
    "wincmd |
endfunction

function EVFunc#SetGuiFont()
    if has("gui_gtk2")
        set guifont=Luxi\ Mono\ 10
    elseif has("x11")
        " Also for GTK 1
        set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
    elseif has("mac")
        if getfontname( "Bitstream_Vera_Sans_Mono" ) != ""
            set guifont=Bitstream\ Vera\ Sans\ Mono:h13
        elseif getfontname( "DejaVu\ Sans\ Mono" ) != ""
            set guifont=DejaVu\ Sans\ Mono:h13
        endif
    elseif has("gui_win32")
        if getfontname("Consolas") != ""
            set guifont=Consolas:h10:cANSI " this is the default visual studio font
        elseif getfontname( "Bitstream_Vera_Sans_Mono" ) != ""
            set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
        else
            set guifont=Lucida_Console:h10:cANSI
        endif
    endif
endfunction

function! EVFunc#ToWin(...)
    let TabNr = tabpagenr()
    let TabCounts = tabpagenr('$')
    let WinCounts = tabpagewinnr(TabNr,'$')
    let WinNr = tabpagewinnr(TabNr)
    if exists('a:1')
        if a:1 == 'right'
            if TabNr == TabCounts
                tabn 1
            else
                exe 'tabn '.(TabNr + 1)
            endif
        elseif a:1 == 'left'
            if TabNr == 1
                exe 'tabn '.TabCounts
            else
                exe 'tabn '.(TabNr - 1)
            endif
        elseif a:1 == 'up'
            if WinNr == 1
                exe WinCounts.' wincmd w'
            else
                exe (WinNr - 1).' wincmd w'
            endif
        else
            wincmd w
        endif
    else
        wincmd w
    endif

endfunction

function! EVFunc#GetLargeFile()
        if expand('%:e') != ''
            exe "setlocal ft=".expand('%:e')
        else
            source $VIMRUNTIME/scripts.vim
        endif
        call setline("$",readfile(expand('%:p'),"",2000))
        if &fileencoding == ''
            exe 'setlocal fileencoding='.&encoding
        endif
        au  CursorHoldI <buffer>   let fileContentList = readfile(expand('%:p')) | if len(fileContentList) > 2000 | let fileContentList = filter(fileContentList,'v:key >= 2000') | call append("$",fileContentList) | endif | unlet fileContentList | au! CursorHoldI <buffer>  
endfunction

function! EVFunc#log(...)
    if !exists("a:1")
        let msg = "some warnings are founded!  you can check the warning on '$HOME/.easyvim/log/'"
    else
        let msg = a:1
    endif
    exe 'echohl WarningMsg | echo "'.msg.'"  | echohl None'
    if !isdirectory($HOME.'/.easyvim/log/')
        try
            call mkdir($HOME.'/.easyvim/log/','p')
        catch /.*/
        endtry
    endif
    call writefile([
                \'File:'.expand("%:p"),
                \'v:throwpoint:'.v:throwpoint,
                \'v:warningmsg:'.v:warningmsg,
                \'v:exception:'.v:exception,
                \'v:errmsg:'.v:errmsg
                \],
                \$HOME.'/.easyvim/log/'.expand("%:e")."_".localtime().'.log',
                \"b"
                \)
endfunction
