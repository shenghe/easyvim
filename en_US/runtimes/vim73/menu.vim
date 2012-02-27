if filereadable($VIM."/easyvim/menu.vim")
  source $VIM/easyvim/menu.vim
elseif filereadable($VIMRUNTIME."/menu_example.vim")
  source $VIMRUNTIME/menu_example.vim
else
  set guioptions-=m
endif
