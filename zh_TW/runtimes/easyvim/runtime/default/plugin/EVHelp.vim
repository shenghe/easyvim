" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : EVHelp.vim
" Date : 2012/2/24 11:53:38

if exists("g:EVHelp_Version")
    finish
endif
let g:EVHelp_Version = "1.0"
"Command    {{{
command! -nargs=? Help call EVHelp#EVHelp(<args>)
command! -nargs=0 SetEngine call EVHelp#setEngine()
command! -nargs=+ Bsearch call EVHelp#SearchInBrowse(<args>)
command! -n=0   Browse call EVHelp#SearchInBrowse("file:///".expand("%:p"),"")
"}}}
"Map {{{
inoremap <silent> <F1>                  <C-o>:call EVHelp#EVHelp()<CR>
nnoremap <silent> <F1>                  :call EVHelp#EVHelp()<CR>
vnoremap <silent> <F1>                  :call EVHelp#EVHelp()<CR>
noremap! <silent> <S-F1>                <C-o>:call EVHelp#SearchInBrowse("","google")<CR>
nnoremap <silent> <S-F1>                :call EVHelp#SearchInBrowse("","google")<CR>
inoremap <silent> <F3>                  <C-o>:call EVHelp#Vimgrep()<CR>
nnoremap <silent> <F3>                  :call EVHelp#Vimgrep()<CR>
inoremap <silent> <S-F3>                <C-o>:call EVHelp#Replace()<CR>
nnoremap <silent> <S-F3>                :call EVHelp#Replace()<CR>
inoremap <silent> <F3><F3>              <C-o>n
nnoremap <silent> <F3><F3>              n
noremap! <silent> <F9>                  <C-o>:call EVHelp#SearchInBrowse("file:///".expand("%:p"),"")<CR>
nnoremap <silent> <F9>                  :call EVHelp#SearchInBrowse("file:///".expand("%:p"),"")<CR>
"}}}
call EVHelp#SetHelpFile()
