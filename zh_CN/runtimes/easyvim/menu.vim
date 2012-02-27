" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : menu.vim
" Date : 2012/2/23 18:03:24

if exists("g:EVMenu_version")
    finish
endif
let g:EVMenu_version = "1.0"

"LangMenu   {{{
if exists("v:lang") || &langmenu != ""
  " Try to find a menu translation file for the current language.
  if &langmenu != ""
    if &langmenu =~ "none"
      let s:lang = ""
    else
      let s:lang = &langmenu
    endif
  else
    let s:lang = v:lang
  endif
  " A language name must be at least two characters, don't accept "C"
  if strlen(s:lang) > 1
    " When the language does not include the charset add 'encoding'
    if s:lang =~ '^\a\a$\|^\a\a_\a\a$'
      let s:lang = s:lang . '.' . &enc
    endif

    " We always use a lowercase name.
    " Change "iso-8859" to "iso_8859" and "iso8859" to "iso_8859", some
    " systems appear to use this.
    " Change spaces to underscores.
    let s:lang = substitute(tolower(s:lang), '\.iso-', ".iso_", "")
    let s:lang = substitute(s:lang, '\.iso8859', ".iso_8859", "")
    let s:lang = substitute(s:lang, " ", "_", "g")
    " Remove "@euro", otherwise "LC_ALL=de_DE@euro gvim" will show English menus
    let s:lang = substitute(s:lang, "@euro", "", "")
    " Change "iso_8859-1" and "iso_8859-15" to "latin1", we always use the
    " same menu file for them.
    let s:lang = substitute(s:lang, 'iso_8859-15\=$', "latin1", "")
    menutrans clear
    exe "runtime! lang/menu_" . s:lang . ".vim"

    if !exists("did_menu_trans")
      " There is no exact match, try matching with a wildcard added
      " (e.g. find menu_de_de.iso_8859-1.vim if s:lang == de_DE).
      let s:lang = substitute(s:lang, '\.[^.]*', "", "")
      exe "runtime! lang/menu_" . s:lang . "[^a-z]*vim"

      if !exists("did_menu_trans") && strlen($LANG) > 1 && s:lang !~ '^en_us'
          exe "runtime! lang/menu_" . tolower($LANG) . "[^a-z]*vim"
      endif
    endif
  endif
endif
"}}}

" File menu         {{{
an <silent> 10.10  &File.New                      :tabnew<CR>
an <silent> 10.20  &File.Open                     :browse confirm tabnew<CR>
an <silent> 10.30  &File.Save                     :if expand("%") == ""<Bar>browse confirm w<Bar>else<Bar>confirm w<Bar>endif<CR>
an <silent> 10.40  &File.SaveAs                   :browse confirm saveas<CR>
an <silent> 10.50  &File.SaveALL                  :browse confirm wa<CR>
an 10.355 &File.-SEP1-                            <Nop>
an <silent> 10.60.10 &File.Convert.ToDos          :set ff=dos<CR>
an <silent> 10.60.20 &File.Convert.ToMac          :set ff=mac<CR>
an <silent> 10.60.30 &File.Convert.ToUnix         :set ff=unix<CR>
an <silent> 10.60.35 &File.Convert.-sep-          <Nop>
an <silent> 10.60.40 &File.Convert.ToANCI          :setlocal fileencoding=chinese<CR>
an <silent> 10.60.50 &File.Convert.ToUTF8          :setlocal fileencoding=utf-8<Bar>setlocal nobomb<CR>
an <silent> 10.60.60 &File.Convert.ToUtf8-Bom      :setlocal fileencoding=utf-8<Bar>setlocal bomb<CR>
an <silent> 10.60.70 &File.Convert.ToBIGEndian     :setlocal fileencoding=ucs-2<CR>
an <silent> 10.60.80 &File.Convert.ToLittleEndian  :setlocal fileencoding=ucs-2le<CR>
augroup EVMenu
  au!
  au VimEnter * call EVOldFiles()
augroup END

an 10.85 &File.-SEP3-                              <Nop>
if has("printer")
  an <silent> 10.90 &File.Print                   :hardcopy<CR>
  vunmenu   &File.Print
  vnoremenu <silent> 10.90 &File.Print            :hardcopy<CR>
elseif has("unix")
  an <silent> 10.90 &File.Print                   :w !lpr<CR>
  vunmenu   &File.Print
  vnoremenu <silent> 10.90 &File.Print            :w !lpr<CR>
endif
an 10.95 &File.-SEP4-                              <Nop>
an <silent> 10.100 &File.Exit                     :confirm wqa<CR>

function! EVOldFiles()
    try
        if exists("v:oldfiles") && type(v:oldfiles) == 3
            let MenuHeight = 0
            for sFile in v:oldfiles
                if filereadable(sFile) && sFile !~? '[\\\|/]doc[\\\|/].\+\.[cnx\|txt]'
                    let MenuHeight += 10
                    let sNewFile = substitute(substitute(sFile,'\','/','g'),'\.','\\.','g')
                    let sNewFile = substitute(sNewFile,'\s\+','\\ ','g')
                    exe "an <silent> 10.70.". MenuHeight ." &File.HistoryRecords.".sNewFile." :tabnew ".sFile."<CR>"
                endif
            endfor
        endif
    catch /.*/
    endtry
endfunction
"}}}

"--Edit menu--      {{{
an <silent> 20.10  &Edit.Undo                                  :u<CR>
an <silent> 20.20  &Edit.Redo                                  :redo<CR>
vnoremenu <silent> 20.30 &Edit.Cut                             "+yx
vnoremenu <silent> 20.40 &Edit.Copy                            "+y
cnoremenu <silent> 20.40 &Edit.Copy                            <C-Y>
nnoremenu <silent> 20.50 &Edit.Paste                           "+gP
cnoremenu <silent> 20.60 &Edit.Paste                           <C-R>+
exe 'vnoremenu <silent> <script> 20.60 &Edit.Paste ' . paste#paste_cmd['v']
exe 'inoremenu <silent> <script> 20.60 &Edit.Paste ' . paste#paste_cmd['i']
nnoremenu <silent> 20.70 &Edit.CopyAll                         gggH<C-O>G
inoremenu <silent> 20.70 &Edit.CopyAll                         <C-O>gg<C-O>gH<C-O>G
cnoremenu <silent> 20.70 &Edit.CopyAll                         <C-C>gggH<C-O>G
onoremenu <silent> 20.70 &Edit.CopyAll                         <C-C>gggH<C-O>G
snoremenu <silent> 20.70 &Edit.CopyAll                         <C-C>gggH<C-O>G
xnoremenu <silent> 20.70 &Edit.CopyAll                         <C-C>ggVG
an <silent> 20.80  &Edit.-SEP1-                                <Nop>
an <silent> 20.90 &Edit.GoTo                                   :call GoToPos()<CR>
an <silent> 20.100 &Edit.Settype                               :exe "normal gg=G"<CR>
function! GoToPos()
    let pos = inputdialog('Please input the line number:',line("$"))
    if type(str2nr(pos)) == 0
        call cursor(pos,1)
    endif
endfunction
an <silent> 20.110  &Edit.Promptfind                            :promptfind<CR>
vunmenu	 &Edit.Promptfind
vnoremenu <silent> 20.110  &Edit.Promptfind                     y:promptfind <C-R>=substitute(@", "[\r\n]", '', 'g')<CR><CR>
an <silent> 20.110  &Edit.Replace                               :promptrepl<CR>
vunmenu	 &Edit.Replace
vnoremenu <silent> 20.110 &Edit.Replace                         y:promptrepl <C-R>=substitute(@", "[\r\n]", '', 'g')<CR><CR>
"an <silent> 20.120  &Edit.Rep&Eat                               .
"iunmenu &Edit.Rep&Eat
"inoremenu <silent> 20.120  &Edit.Rep&Eat                        <C-O>.
an <silent> 20.125  &Edit.-SEP2-                                <Nop>
vnoremenu <silent> 20.130.10  &Edit.Paragraph.Center            :ce<CR>
vnoremenu <silent> 20.130.20  &Edit.Paragraph.Left              :le<CR>
vnoremenu <silent> 20.130.30  &Edit.Paragraph.Right             :ri<CR>
an <silent> 20.140.10  &Edit.Advanced.Remove\ Unnecessary\ Blank\ And\ Eol                    :let __a__ = line(".") <Bar>let __b__ =col(".")<Bar>g/^\s*$/d <Bar>%s/\s\+$//g<bar> call cursor(__a__,__b__)<CR>
an <silent> 20.140.20  &Edit.Advanced.Tab\ To\ Blank            :retab<CR>
an <silent> 20.140.30  &Edit.Advanced.Blank\ To\ Tab            :retab!<CR>
an <silent> 20.140.40  &Edit.Advanced.Replace\ ^M               :call Replace()<CR>
an <silent> 20.140.60  &Edit.Advanced.Comment\ Or\ Uncomment    :call EVComment#Toggle()<CR>
vnoremenu <silent> 20.140.70  &Edit.Advanced.Uppercase\ Or\ Lowercase       ~
vnoremenu <silent> 20.140.80  &Edit.Advanced.Increase\ Line\ Indent         1>
vnoremenu <silent> 20.140.90  &Edit.Advanced.Decrease\ Line\ Indent         1<
function! Replace()
    let cursorLine = line(".")
    let cursorCol = col(".")
    try
        %s//\r/g
    catch /.*/
    endtry
    call cursor(cursorLine,cursorCol)
endfunction
"}}}

"--View---          {{{
an <silent> 30.10 &View.Toggle\ TagsBrowser                     :TagbarToggle<CR>
an <silent> 30.20.10 &View.FileExplore.Toggle\ FileExplore      :call EVTreeToggle()<CR>
an <silent> 30.20.20 &View.FileExplore.Toggle\ MarksTree        :call EVTreeToggleBookmark()<CR>
an <silent> 30.40.10 &View.Quickfix.Toggle\ Quickfix            :call EVQuickfix()<CR>
an <silent> 30.40.20 &View.Quickfix.Update\ Quickfix            :cwin<CR>
an <silent> 30.65 &View.-sep1-                                  <Nop>
an <silent> 30.70 &View.Fold\ Or\ Unfold\ All                   :if &foldlevel == 0 <Bar> exe "normal zR" <Bar> else <Bar> exe "normal zM" <Bar> endif<CR>
an <silent> 30.80.10 &View.Windows\ Manager.New\ Window             :wincmd n<CR>
an <silent> 30.80.20 &View.Windows\ Manager.Close\ This\ Window :wincmd c<CR>
an <silent> 30.80.30 &View.Windows\ Manager.Close\ Other\ Windows :confirm only<CR>
an <silent> 30.80.40 &View.Windows\ Manager.Split\ This\ Window                      :setlocal scrollbind <Bar> split <Bar> setlocal scrollbind<CR>
an <silent> 30.80.50 &View.Windows\ Manager.Close\ Other\ Tabs              :tabonly<CR>
an <silent> 30.80.60 &View.Windows\ Manager.Synchronize\ Window                       :if &scrollbind <Bar> setlocal noscb <Bar> else <Bar> setlocal scrollbind <Bar> endif<CR>
an <silent> 30.80.10 &View.Windows\ Manager.Alpha                      :call libcallnr("vimtweak.dll", "SetAlpha", 200)<CR>
an <silent> 30.90.20 &View.Window\ Setting.Reset\ Alpha                 :call libcallnr("vimtweak.dll", "SetAlpha", 255)<CR>
an <silent> 30.90.30 &View.Window\ Setting.Maximized\ Enable            :call libcallnr("vimtweak.dll", "EnableMaximize", 1)<CR>
an <silent> 30.90.40 &View.Window\ Setting.Maximized\ Disable           :call libcallnr("vimtweak.dll", "EnableMaximize", 0)<CR>
an <silent> 30.90.50 &View.Window\ Setting.TopMost\ Enable              :call libcallnr("vimtweak.dll", "EnableTopMost", 1)<CR>
an <silent> 30.90.60 &View.Window\ Setting.TopMost\ Disable             :call libcallnr("vimtweak.dll", "EnableTopMost", 0)<CR>
an <silent> 30.95 &View.-sep2-                                  <Nop>
an <silent> 30.100.10 &View.Customized.Hide\ Or\ Show\ Toolbar                        :if stridx(&guioptions,"T") == -1 <Bar> set guioptions +=T <Bar> else <Bar> set guioptions -=T <Bar> endif<CR>
an <silent> 30.100.20 &View.Customized.Hide\ Or\ Show\ Menubar                     :if stridx(&guioptions,"m") == -1 <Bar> set guioptions +=m <Bar> else <Bar> set guioptions -=m <Bar> endif<CR>
an <silent> 30.100.30 &View.Customized.Hide\ Or\ Show\ Right\ Scrollbar                  :if stridx(&guioptions,"r") == -1 <Bar> set guioptions +=r <Bar> else <Bar> set guioptions -=r <Bar> endif<CR>
an <silent> 30.100.40 &View.Customized.Hide\ Or\ Show\ Bottom\ Scrollbar                  :if stridx(&guioptions,"b") == -1 <Bar> set guioptions +=b <Bar> else <Bar> set guioptions -=b <Bar> endif<CR>
an <silent> 30.100.50 &View.Customized.Hide\ Or\ Show\ Line\ Number                      :if &number <Bar> setlocal nonu <Bar> else <Bar> setlocal nu <Bar> endif<CR>
an <silent> 30.100.60 &View.Customized.Hide\ Or\ Show\ Statusbar                   :if &laststatus == 0 <Bar> setlocal ls=2 <Bar> else <Bar> setlocal ls=0 <Bar> endif<CR>
an <silent> 30.100.70 &View.Customized.Highlight\ Search                  :if !&hlsearch <Bar> setlocal hlsearch <Bar> else <Bar> setlocal nohls <Bar> endif<CR>
an <silent> 30.100.80 &View.Customized.Hide\ Or\ Show\ Ruler                       :if &ruler <Bar> setlocal noru <Bar> else <Bar> setlocal ruler <Bar> endif<CR>
an <silent> 30.100.90 &View.Customized.Hide\ Or\ Show\ Tab&Blank                   :if !&list <Bar> setlocal list <Bar> setlocal lcs=tab:--,trail:.,nbsp:. <Bar> else <Bar> setlocal nolist <Bar>endif<CR>

let s:n = globpath(&runtimepath, "colors/*.vim")
let s:names = sort(map(split(s:n, "\n"), 'substitute(v:val, "\\c.*[/\\\\:\\]]\\([^/\\\\:]*\\)\\.vim", "\\1", "")'), 1)
let s:idx = 10
for s:name in s:names
  exe "an 30.100.100." . s:idx . ' &View.Customized.Color\ Scheme.' . s:name . " :colors " . s:name . "<CR>"
  let s:idx = s:idx + 10
endfor
unlet s:names s:n s:idx

an <silent> 30.100.110 &View.Customized.Save\ Session                   :browse mksession!<CR>
an <silent> 30.100.120 &View.Customized.Font                       :set guifont=*<CR>

function! EVQuickfix()
    let tabWinCounts = tabpagewinnr(tabpagenr(),"$")
    let hasqf = 0
    for Nr in range(1,tabWinCounts)
        if getwinvar(Nr,'&bt') == 'quickfix'
            let hasqf = 1 | break
        endif
    endfor
    if hasqf == 1
        cclose
    else
        copen
    endif
endfunction
"}}}

"--tools----            {{{
an <silent> 40.20.10 &Tools.Preview.Default                                 :call EVHelp#SearchInBrowse("file:///".expand("%:p"),"")<CR>
an <silent> 40.20.20 &Tools.Preview.Google                                  :call EVHelp#SearchInBrowse("","google")<CR>
an <silent> 40.20.30 &Tools.Preview.Wikipedia                               :call EVHelp#SearchInBrowse("","wikipedia")<CR>
an <silent> 40.20.40 &Tools.Preview.MSDN                                    :call EVHelp#SearchInBrowse("","msdn")<CR>
an <silent> 40.20.50 &Tools.Preview.Cplusplus                               :call EVHelp#SearchInBrowse("","cplusplus")<CR>
an <silent> 40.20.60 &Tools.Preview.PHP                                     :call EVHelp#SearchInBrowse("","php")<CR>
an <silent> 40.20.70 &Tools.Preview.Whois                                   :call EVHelp#SearchInBrowse("","whois")<CR>
an <silent> 40.20.80 &Tools.Preview.Yahoo                                   :call EVHelp#SearchInBrowse("","yahoo")<CR>
an <silent> 40.30.10 &Tools.Insert.Insert\ File                             :browse r<CR>
if exists("*strftime")
    inoremenu <silent> 40.30.20 &Tools.Insert.Insert\ Datetime              <C-r>=strftime("%c")<Cr>
endif
inoremenu <silent> 40.30.30 &Tools.Insert.Insert\ Filepath                  <C-r>=expand("%:p")<Cr>
an <silent> 40.40.10 &Tools.&Hex.To\ Hex                                    :setlocal ft=xxd <Bar>%!xxd <CR>
an <silent> 40.40.20 &Tools.&Hex.To\ Ascii                                  :exe ":%!xxd -r" <Bar>setlocal ft=<Bar>doautocmd filetypedetect BufReadPost<CR>
function! InitCscope()
    if has("win32") || has("win64") || has("win16")
        silent! !dir /s /b *.c,*.cc,*.cpp,*.h,*.java > cscope.files
    else
        silent! !find -maxdepth 1000 -name "*.[c|h]" >cscope.files
        silent! !find -maxdepth 1000 -name "*.cpp" >> cscope.files
        silent! !find -maxdepth 1000 -name "*.java" >>cscope.files
    endif
    silent! !cscope -Rb
    set cst
    silent! cs add cscope.out
endfunction
an <silent> 40.50.10 &Tools.Tags\ and\ Cscope.Make\ Tags 
            \ :silent! !ctags -R .<CR>
an <silent> 40.50.20 &Tools.Tags\ and\ Cscope.Make\ Cscope\ Datebase
            \ :call InitCscope()<CR>
an <silent> 40.50.30 &Tools.Tags\ and\ Cscope.Find\ This\ C\ Symbol
            \ :scs find s <C-R>=expand("<cword>")<CR><CR>
an <silent> 40.50.40 &Tools.Tags\ and\ Cscope.Find\ This\ Function\ Definition
            \ :scs find g <C-R>=expand("<cword>")<CR><CR>
an <silent> 40.50.50 &Tools.Tags\ and\ Cscope.Find\ Functions\ Called\ By\ This\ Function
            \ :scs find c <C-R>=expand("<cword>")<CR><CR>
an <silent> 40.50.60 &Tools.Tags\ and\ Cscope.Find\ Functions\ Calling\ this\ Function
            \ :scs find d <C-R>=expand("<cword>")<CR><CR>
an <silent> 40.50.70 &Tools.Tags\ and\ Cscope.Find\ this\ text\ string
            \ :scs find t <C-R>=expand("<cword>")<CR><CR>
an <silent> 40.50.80 &Tools.Tags\ and\ Cscope.Find\ files\ including\ this\ file
            \ :scs find i <C-R>=expand("<cfile>")<CR><CR>
an <silent> 40.50.90 &Tools.Tags\ and\ Cscope.Find\ this\ egrep\ patten
            \ :scs find e <C-R>=expand("<cword>")<CR><CR>
an <silent> 40.50.100 &Tools.Tags\ and\ Cscope.Find\ this\ file
            \ :scs find f <C-R>=expand("<cfile>")<CR><CR>

an <silent> 40.60 &Tools.Spell\ Checker                                     :if &spell <Bar>set nospell <Bar>else<Bar>set spell<Bar>endif<CR>
an <silent> 40.80 &Tools.Vim\ Diff                                          :if !&diff <Bar> browse vert diffsplit<Bar>else<Bar>setlocal nodiff<Bar>endif<CR>
an <silent> 40.90 &Tools.Summary                                            g<C-G>
an <silent> 40.110.10 &Tools.Macros.Tape                                    qz
an <silent> 40.110.20 &Tools.Macros.Stop                                    q
an <silent> 40.110.30 &Tools.Macros.Play                                    @z
an <silent> 40.120.10 &Tools.Export\ And\ Import.Import\ Vimscript          :browse so<CR>
an <silent> 40.120.20 &Tools.Export\ And\ Import.Import\ The\ View          :loadview<CR>
an <silent> 40.120.30 &Tools.Export\ And\ Import.Export\ The\ View          :browse mkview! View.vim<CR>
an <silent> 40.120.40 &Tools.Export\ And\ Import.Export\ The\ Settings      :browse mkvimrc! Settings.vim<CR>
an <silent> 40.120.50 &Tools.Export\ And\ Import.Export\ To\ Html           :runtime syntax/2html.vim <Bar> w!<CR>
"}}}

"--Help--       {{{
an <silent> 9999.10 &Help.SearchHelp                            :call EVHelp#EVHelp()<CR>
an <silent> 9999.40.10 &Help.Navigation.Overview                :help<CR>
an <silent> 9999.40.20 &Help.Navigation.Vimtutor                :help tutor<CR>
an <silent> 9999.40.30 &Help.Navigation.Function                :help function-list<CR>
an <silent> 9999.40.40 &Help.Navigation.Option                  :help option-list<CR>
an <silent> 9999.40.50 &Help.Navigation.Eval                    :help eval<CR>
an <silent> 9999.40.60 &Help.Navigation.Map                     :help map<CR>
an <silent> 9999.50.10 &Help.VimInfo.Color                      :sp $VIMRUNTIME/syntax/colortest.vim<Bar>so %<CR>
an <silent> 9999.50.20 &Help.VimInfo.Hitest                     :runtime syntax/hitest.vim<CR>
an <silent> 9999.50.30 &Help.VimInfo.BugReport                  :so $vimruntime/bugreport.vim<CR>
an <silent> 9999.50.40 &Help.VimInfo.Version                    :browse redir > version.txt <Bar> silent! version <Bar> redir END<CR>
an <silent> 9999.50.50 &Help.VimInfo.Scriptname                 :redir >scriptname.txt <Bar> silent! scriptname <Bar> redir END <Bar> tabnew scriptname.txt<CR>
an <silent> 9999.55 &Help.-sep1-                                <Nop>
an <silent> 9999.60 &Help.EasyVim\ 1\.0Beta\ (GVIM7\.3)         <Nop>
an <silent> 9999.65 &Help.-sep2-                                <Nop>
an <silent> 9999.70 &Help.About                                 :intro<CR>
"}}}

"-ToolBar--         {{{
if has("toolbar")
    an <silent> 1.10 ToolBar.New                                :tabnew<CR>
    an <silent> 1.20 ToolBar.Open                               :browse confirm e<CR>
    an <silent> 1.30 ToolBar.Save                               :if expand("%") == ""<Bar>browse confirm w<Bar>else<Bar>confirm w<Bar>endif<CR>
    an 1.35 ToolBar.-sep1-                                      <Nop>
    an 1.40 ToolBar.Undo                                        :u<CR>
    an 1.50 ToolBar.Redo                                        :redo<CR>
    an 1.55 ToolBar.-sep2-                                      <Nop>
    vnoremenu   1.60 ToolBar.Cut                                "+x
    vnoremenu   1.70 ToolBar.Copy                               "+y
    cnoremenu   1.80 ToolBar.Copy                               <C-Y>
    nnoremenu   1.90 ToolBar.Paste                              "+gP
    cnoremenu   1.90 ToolBar.Paste                              <C-R>+
    exe 'vnoremenu <silent> <script>    ToolBar.Paste  ' . paste#paste_cmd['v']
    exe 'inoremenu <silent> <script>    ToolBar.Paste  ' . paste#paste_cmd['i']
    if !has("gui_athena")
        an 1.95   ToolBar.-sep3-                                <Nop>
        an <silent> 1.100  ToolBar.Replace                      :promptrepl<CR>
        vunmenu   ToolBar.Replace
        vnoremenu <silent> ToolBar.Replace                      y:promptrepl <C-R>=<SID>FixFText()<CR><CR>
        an 1.110  ToolBar.FindNext                              n
        an 1.120  ToolBar.FindPrev                              N
    endif
    an 1.125 ToolBar.-sep4-                                     <Nop>
    an <silent> 1.140 ToolBar.Shell                             :call EVHelp#SearchInBrowse("file:///".expand("%:p"),"")<CR>
    an 1.145 ToolBar.-sep5-                                     <Nop>
    an <silent> 1.150 ToolBar.Help                              :call EVHelp#EVHelp()<CR>
    tmenu ToolBar.New                                           新建文件
    tmenu ToolBar.Open                                          打开文件
    tmenu ToolBar.Save                                          保存文件
    tmenu ToolBar.Undo                                          取消操作
    tmenu ToolBar.Redo                                          重做操作
    tmenu ToolBar.Cut                                           剪切
    tmenu ToolBar.Copy                                          复制
    tmenu ToolBar.Paste                                         粘贴
    tmenu ToolBar.Replace                                       查找
    tmenu ToolBar.FindNext                                      查找下一个
    tmenu ToolBar.FindPrev                                      查找上一个
    tmenu ToolBar.RunScript                                     编译文件
    tmenu ToolBar.Shell                                         在线预览
    tmenu ToolBar.Help                                          查找帮助
endif
"}}}

" The popup menu        {{{
an 1.10 PopUp.Undo                                                                          :u<CR>
an 1.20 PopUp.Redo                                                                          :redo<CR>
an 1.25 PopUp.-sep1-                                                                        <Nop>
vnoremenu 1.30 PopUp.Cut                                                                    "+x
vnoremenu 1.40 PopUp.Copy                                                                   "+y
cnoremenu 1.40 PopUp.Copy                                                                   <C-Y>
nnoremenu 1.50 PopUp.Paste                                                                  "+gP
cnoremenu 1.50 PopUp.Paste                                                                  <C-R>+
exe 'vnoremenu <silent> <script> 1.50 PopUp.Paste  ' . paste#paste_cmd['v']
exe 'inoremenu <silent> <script> 1.50 PopUp.Paste  ' . paste#paste_cmd['i']
inoremenu <silent> 1.60 PopUp.CopyAll                                                       <C-O>gg<C-O>gH<C-O>G
an 1.65 PopUp.-SEP2-                                                                        <Nop>
inoremenu <silent> 1.70.10 PopUp.PopUp\ Copy.Copy\ Whole\ Line                              <C-o>:let @* = getline(".")<CR>
inoremenu <silent> 1.70.20 PopUp.PopUp\ Copy.Copy\ To\ Tail                                 <C-o>:let @* = strpart(getline("."),col(".")-1)<CR>
inoremenu <silent> 1.70.20 PopUp.PopUp\ Copy.Copy\ To\ Head                                 <C-o>:let @* = strpart(getline("."),0,)<CR>
inoremenu <silent> 1.80.10 PopUp.PopUp\ Cut.Cut\ Whole\ Line                                <C-o>:let @* = getline(".") <Bar> exe "normal dd"<CR>
inoremenu <silent> 1.80.20 PopUp.PopUp\ Cut.Cut\ To\ Tail                                   <C-o>:let @* = strpart(getline("."),col(".")-1) <Bar> exe "normal d$"<CR>
inoremenu <silent> 1.80.30 PopUp.PopUp\ Cut.Cut\ To\ Head                                   <C-o>:let @* = strpart(getline("."),0,col(".")) <Bar> exe "normal d0"<CR>
inoremenu <silent> 1.90.10 PopUp.PopUp\ Delete.Delete\ Whole\ Line                          <C-o>:exe "normal dd"<CR>
inoremenu <silent> 1.90.20 PopUp.PopUp\ Delete.Delete\ To\ Tail                             <C-o>:exe "normal d$"<CR>
inoremenu <silent> 1.90.30 PopUp.PopUp\ Delete.Delete\ To\ Head                             <C-o>:exe "normal d0"<CR>
vnoremenu <silent> 1.100 PopUp.PopUp\ Search                                                y:/<C-R>=@"<CR><CR>
vnoremenu <silent> 1.110 PopUp.SearchHelp                                                   :call EVHelp#EVHelp()<CR>
an 1.115 PopUp.-SEP3-                                                                       <Nop>
vnoremenu <silent> 1.120 PopUp.Insert\ Line\ Number                                         :call LineNum()<CR>
nnoremenu 1.130 PopUp.Ascii                                                                 ga
an <silent> 1.160  PopUp.Comment                                                            :call EVComment#Toggle()<CR>
inoremenu 1.165 PopUp.-SEP4-                                                                <Nop>
inoremenu <silent> 1.170.10 PopUp.Insert.Insert\ File                                       <C-o>:browse r<CR>
if exists("*strftime")
    inoremenu <silent> 1.170.20 PopUp.Insert.Insert\ Datetime                               <C-r>=strftime("%c")<Cr>
endif
inoremenu <silent> 1.170.30 PopUp.Insert.Insert\ Filepath                                   <C-r>=expand("%:p")<Cr>
vnoremenu <silent> 1.180.10 PopUp.Paragraph.Increase\ Line\ Indent                          1>
vnoremenu <silent> 1.180.20 PopUp.Paragraph.Decrease\ Line\ Indent                          1<
vnoremenu <silent> 1.180.30 PopUp.Paragraph.Center                                          :ce<CR>
vnoremenu <silent> 1.180.40 PopUp.Paragraph.Left                                            :le<CR>
vnoremenu <silent> 1.180.50 PopUp.Paragraph.Right                                           :ri<CR>
function! LineNum() range
    let firstLine = line("'<")
    let lastLine = line("'>")
    while firstLine <= lastLine
        call setline(firstLine,firstLine.".".getline(firstLine))
        let firstLine +=1
    endwhile
endfunction
"}}}
" vim:foldmethod=marker
