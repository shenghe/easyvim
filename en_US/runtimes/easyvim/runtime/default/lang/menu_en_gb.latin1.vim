" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : menu_en_gb.latin1.vim
" Date : 2/23/2012 7:38:45 PM


if exists("did_menu_trans")
  finish
endif
let did_menu_trans = 1

scriptencoding latin1

" Help menu
menutrans &Help                                         Help(&H)
menutrans VimInfo                                       VimInfo
menutrans Overview                                      Overview
menutrans Vimtutor                                      Vimtutor
menutrans SearchHelp                                    Search\ Help
menutrans Navigation                                    Navigation
menutrans Function                                      Function
menutrans Option                                        Option
menutrans Eval                                          Eval
menutrans Map                                           Map
menutrans About                                         About

" File menu
menutrans &File                                         File(&F)
menutrans New                                           New
menutrans NewTemplate                                   New\ Template
menutrans Open                                          Open
menutrans Save                                          Save
menutrans SaveAs                                        Save\ As
menutrans SaveALL                                       Save\ All
menutrans Convert                                       Convert
menutrans ToDos                                         To\ Dos
menutrans ToMac                                         To\ Mac
menutrans ToUnix                                        To\ Unix
menutrans ToANCI                                        To\ ANCII
menutrans ToUTF8                                        To\ UTF-8
menutrans ToUtf8-Bom                                    To\ UTF-8(BOM)
menutrans ToBIGEndian                                   To\ UCS-2\ Big\ Endian
menutrans ToLittleEndian                                To\ UCS-2\ Little\ Endian
menutrans HistoryRecords                                History\ Records
menutrans Print                                         Print
menutrans Exit                                          Save\ And\ Exit
" Edit menu
menutrans &Edit                                         Edit(&E)
menutrans Undo                                          Undo
menutrans Redo                                          Redo
menutrans Repeat                                        Repeat
menutrans Cut                                           Cut
menutrans Copy                                          Copy
menutrans Paste                                         Paste
menutrans CopyAll                                       Copy\ All
menutrans Settype                                       Settype
menutrans Promptfind                                    Search
menutrans Replace                                       Replace
menutrans GoTo                                          Go\ To
menutrans Advanced                                      Advanced
menutrans Remove\ Unnecessary\ Blank\ And\ Eol          Remove\ Unnecessary\ Blank\ And\ Eol
menutrans Tab\ To\ Blank                                Tab\ To\ Blank
menutrans Blank\ To\ Tab                                Blank\ To\ Tab
menutrans Uppercase\ or\ Lowercase                      Uppercase\ or\ Lowercase
menutrans Replace\ ^M                                   Replace\ ^M
menutrans Hide\ or\ Show\ Blanks                        Hide\ or\ Show\ Blanks
menutrans Comment\ or\ Uncomment                        Comment\ or\ Uncomment
menutrans Increase\ Line\ Indent                        Increase\ Line\ Indent
menutrans Decrease\ Line\ Indent                        Decrease\ Line\ Indent
menutrans Paragraph                                     Paragraph
menutrans center                                        Center
menutrans left                                          Left
menutrans right                                         Right
"--View---
menutrans &View                                         View(&V)
menutrans FileExplore                                   FileExplore
menutrans Toggle\ FileExplore                           Toggle\ FileExplore
menutrans Toggle\ MarksTree                             Toggle\ MarksTree
menutrans Toggle\ TagsBrowser                           Toggle\ TagsBrowser
menutrans Shell                                         Toggle\ Shell
menutrans Quickfix                                      Quickfix
menutrans Update\ Quickfix                              Update\ Quickfix
menutrans Toggle\ Quickfix                              Toggle\ Quickfix
menutrans Bookmark                                      Bookmark
menutrans Add\ Bookmark                                 Add\ Bookmark
menutrans Toggle\ Bookmark                              Toggle\ Bookmark
menutrans Fold\ or\ Unfold\ All                         Fold\ or\ Unfold\ All
menutrans Windows\ Manager                              Windows\ Manager
menutrans Close\ This\ Window                           Close\ This\ Window
menutrans Close\ Other\ Windows                         Close\ Other\ Windows
menutrans Split\ This\ Window                           Split\ This\ Window
menutrans Close\ Other\ Tabs                            Close\ Other\ Tabs
menutrans New\ Window                                   New\ Window
menutrans Synchronize\ Window                           Synchronize\ Window
menutrans Customized                                    Customized
menutrans Hide\ or\ Show\ Toolbar                       Hide\ or\ Show\ Toolbar
menutrans Hide\ or\ Show\ Menubar                       Hide\ or\ Show\ Menubar
menutrans Hide\ or\ Show\ Right\ Scrollbar              Hide\ or\ Show\ Right\ Scrollbar
menutrans Hide\ or\ Show\ Bottom\ Scrollbar             Hide\ or\ Show\ Bottom\ Scrollbar
menutrans Hide\ or\ Show\ Line\ Number                  Hide\ or\ Show\ Line\ Number
menutrans Hide\ or\ Show\ Statusbar                     Hide\ or\ Show\ Statusbar
menutrans Hide\ or\ Show\ Ruler                         Hide\ or\ Show\ Ruler
menutrans Hide\ or\ Show\ Tab&Blank                     Hide\ or\ Show\ Tab&Blank
menutrans Save\ Session                                 Save\ Session
menutrans Color\ Scheme                                 Color\ Scheme
menutrans Highlight\ Search                             Highlight\ Search
menutrans Switch\ View                                  Switch\ View
menutrans Toggle\ AutoComplete                          Toggle\ AutoComplete
menutrans Font                                          Font
menutrans Summary                                       Summary
menutrans Window\ Setting                               Window\ Setting
menutrans Alpha                                         Alpha
menutrans Reset\ Alpha                                  Reset\ Alpha
menutrans Maximized\ Enable                             Maximized\ Enable
menutrans Maximized\ Disable                            Maximized\ Disable
menutrans TopMost\ Enable                               TopMost\ Enable
menutrans TopMost\ Disable                              TopMost\ Disable
"--Tools--
menutrans   &Tools                                      Tools(&T)
menutrans   Run\ VimScript                              Run\ VimScript
menutrans   Compiler                                    Compiler
menutrans   SetCompiler                                 Set\ Compiler
menutrans   Preview                                     Preview
menutrans   Add\ Plugin                                 Add\ Plugin
menutrans   Insert                                      Insert
menutrans   Insert\ File                                Insert\ File
menutrans   Insert\ Datetime                            Insert\ Datetime
menutrans   Insert\ Filepath                            Insert\ Filepath
menutrans   Hex                                         Hex
menutrans   To\ Hex                                     To\ Hex
menutrans   To\ Ascii                                   To\ Ascii
menutrans   Export\ To\ Html                            Export\ To\ Html
menutrans   Spell\ Checker                              Spell\ Checker
menutrans   Make\ Tags                                  Make\ Tags
menutrans   Vim\ Diff                                   Vim\ Diff
menutrans   Macros                                      Macros
menutrans   Tape                                        Tape
menutrans   Stop                                        Stop
menutrans   Play                                        Play
menutrans   VimInfo                                     Vim
menutrans   Color                                       Color
menutrans   Hitest                                      Highlight\ Test
menutrans   BugReport                                   Bugreport
menutrans   Version                                     Version
menutrans   Scriptname                                  ScriptsInfo
menutrans   G2B                                         Translate
menutrans   Tocn                                        Traditional\ To\ Simplified
menutrans   Totw                                        Simplified\ To\ Traditional

" The popup menu
menutrans PopUp\ Copy                                   copy
menutrans Copy\ Whole\ Line                             Copy\ Whole\ Line
menutrans Copy\ To\ Tail                                Copy\ To\ Tail
menutrans Copy\ To\ Head                                Copy\ To\ Head
menutrans PopUp\ Cut                                    cut
menutrans Cut\ Whole\ Line                              Cut\ Whole\ Line
menutrans Cut\ To\ Tail                                 Cut\ To\ Tail
menutrans Cut\ To\ Head                                 Cut\ To\ Head
menutrans PopUp\ Delete                                 delete
menutrans Delete\ Whole\ Line                           Delete\ Whole\ Line
menutrans Delete\ To\ Tail                              Delete\ To\ Tail
menutrans Delete\ To\ Head                              Delete\ To\ Head
menutrans PopUp\ Search                                 Search
menutrans Add\ Bookmark                                 Add\ Bookmark
menutrans Delete\ Bookmark                              Delete\ Bookmark
menutrans Insert\ Line\ Number                          Insert\ Line\ Number
menutrans Ascii                                         Ascii
menutrans Comment                                       Comment
menutrans EVTree                                        FileExplore
menutrans Refresh                                       Refresh
menutrans Filter                                        Filter
menutrans Rename                                        Rename
menutrans SearchByNames                                 Search\ In\ FileNames
menutrans SearchByContents                              Search\ In\ Contents
