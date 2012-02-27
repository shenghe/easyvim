" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVnote.vim
" Date : 2012/2/24 12:34:19

if exists("g:EVnote")
    finish
endif
let g:EVnote = 1
if !exists("g:EVnoteAutoInsertCopyright")
    let g:EVnoteAutoInsertCopyright = 1
endif

if !exists("g:EVnoteAutoInsertDoc")
    let g:EVnoteAutoInsertDoc = 1
endif

if !exists("g:EVnoteAutoFormat")
    let g:EVnoteAutoFormat = 1
endif

"g:EVCommentDict   {{{
let g:EVCommentDict = {}
let g:EVCommentDict['notation'] ={
    \ 'actionscript':['/**',' *',' */','//'],
    \ 'ahk': ['/**',' *',' */',';'],
    \ 'apache':["","","",'#'],
    \ 'apachestyle':["","","",'#'],
    \ 'autohotkey':["","","",';'],
    \ 'awk':["","","",'#'],
    \ 'c':['/**',' *',' */','//'],
    \ 'cc':['/**',' *',' */','//'],
    \ 'cfg':["","","",'#'],
    \ 'cmake': ["","","",'#'],
    \ 'cpp':['/**',' *',' */','//'],
    \ 'crontab':["","","",'#'],
    \ 'cs':['/**',' *',' */','//'],
    \ 'css':['/*','',"*/",""],
    \ 'cvs':['','','',"CVS:"],
    \ 'd':['/**',' *',' */','//'],
    \ 'def':["","","",';'],
    \ 'desktop':["","","",'#'],
    \ 'diff':["","","",'#'],
    \ 'dns':["","","",';'],
    \ 'gdb':["","","",'#'],
    \ 'gitcommit':["","","",'#'],
    \ 'gitconfig':["","","",';'],
    \ 'gitrebase':["","","",'#'],
    \ 'gnuplot':["","","",'#'],
    \ 'gtkrc':["","","",'#'],
    \ 'h':['/**','*','*/','//'],
    \ 'hostsaccess':["","","",'#'],
    \ 'html':["<!--","","-->",''],
    \ 'inittab':["","","",'#'],
    \ 'java':['/**',' *',' */','//'],
    \ 'javac':['/**',' *',' */','//'],
    \ 'js':['/**',' *',' */','//'],
    \ 'javascript.jquery':['/**',' *',' */','//'],
    \ 'jsp': ['<%--','','--%>',''],
    \ 'lilo':["","","",'#'],
    \ 'mail':["","","","> "],
    \ 'man':["","","",'."'],
    \ 'matlab':["","","",'%'],
    \ 'nsi':["/**"," *"," */",'#'],
    \ 'objc':['/**','*','*/','//'],
    \ 'objcpp':['/**','*','*/','//'],
    \ 'objj':['/**','*','*/','//'],
    \ 'pdf':["","","","%"],
    \ 'php':['/**','*','*/','//'],
    \ 'python':["","","",'#'],
    \ 'rc': ['/**',' *',' */','//'],
    \ 'registry':["","","",';'],
    \ 'rgb':["","","",'!'],
    \ 'robots': ["","","",'#'],
    \ 'sed':["","","",'#'],
    \ 'smarty':['{*','','*}',''],
    \ 'sql':["","","",'--'],
    \ 'squid': ["","","",'#'],
    \ 'tags':["","","",';'],
    \ 'tcl':["","","",'#'],
    \ 'tpl':["<!--","","-->",""],
    \ 'txt':['/**',' *',' */','//'],
    \ 'txt2tags':["","","",'%'],
    \ 'vbs': ["","","","'"],
    \ 'vim':['','','','"'],
    \ 'wget':["","","",'#'],
    \ 'Wikipedia':["<!--","","-->",""],
    \ 'xhtml':["<!--","","-->",""],
    \ 'xml':["<!--","","-->",""],
    \ }
"}}}

inoremap <silent> <F2> <C-o>:call EVnote#Toggle("Comments","i",0)<CR>
nnoremap <silent> <F2> <C-o>:call EVnote#Toggle("Comments","i",0)<CR>
vnoremap <silent> <F2> :call EVnote#Toggle("Comments","",0)<CR>
inoremap <silent> <S-F2>     <C-o>:call EVnote#Toggle("Copyright","i",0)<CR>
vnoremap <silent> <S-F2>     :call EVnote#Toggle("Copyright","",0)<CR>
nnoremap <silent> <S-F2>     :call EVnote#Toggle("Copyright","i",0)<CR>

inoremap <silent> <Leader>qw <C-o>:call EVnote#Toggle("Blackslash","i",0)<CR>
vnoremap <silent> <Leader>qw :call EVnote#Toggle("Blackslash","s",0)<CR>
nnoremap <silent> <Leader>qw :call EVnote#Toggle("Blackslash","i",0)<CR>

"if g:EVnoteAutoInsertDoc == 1 && g:EVnoteAutoFormat == 1
"    inoremap <silent> <CR> <CR><C-o>:call EVnote#Format(1) <Bar> call EVnote#Toggle("Doc","i",1)<CR>
"elseif g:EVnoteAutoInsertDoc == 1
"    inoremap <silent> <CR> <CR><C-o>:call EVnote#Toggle("Doc","i",1)<CR>
"elseif g:EVnoteAutoFormat == 1
"    inoremap <silent> <CR> <CR><C-o>:call EVnote#Format(1)<CR>
"endif
inoremap <silent> <Leader>qt <C-o>:call EVnote#Toggle("Doc","i",0)<CR>
nnoremap <silent> <Leader>qt :call EVnote#Toggle("Doc","i",0)<CR>

inoremap <silent> <Leader>qf <C-o>:call EVnote#Format(0)<CR>
nnoremap <silent> <Leader>qf :call EVnote#Format(0)<CR>

inoremap <silent> <Leader>qd <C-o>:call EVnote#Toggle("UserDefined","i",0)<CR>
nnoremap <silent> <Leader>qd :call EVnote#Toggle("UserDefined","i",0)<CR>

inoremap <silent> <Leader>qs <C-o>:call EVnote#Toggle("LineNum","i",0)<CR>
vnoremap <silent> <Leader>qs :call EVnote#Toggle("LineNum","",0)<CR>
nnoremap <silent> <Leader>qs :call EVnote#Toggle("LineNum","i",0)<CR>

if g:EVnoteAutoInsertCopyright
    augroup EVnote
        au!
        au BufWritePre * call EVnote#Toggle("Copyright","i",0)
    augroup END
endif
