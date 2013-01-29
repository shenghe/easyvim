" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : menu_zh_tw.utf-8.vim
" Date : 2012/2/18 21:03:26

if exists("did_menu_trans")
  finish
endif
let did_menu_trans = 1

scriptencoding Utf-8
menut clear
" Help menu
menutrans &Help                                         輔助(&H)
menutrans SearchHelp                                    查找輔助
menutrans Navigation                                    導航
menutrans Overview                                      縱覽
menutrans Vimtutor                                      新手手冊
menutrans Function                                      函數列表
menutrans Option                                        選項列表
menutrans Eval                                          腳本入門
menutrans Map                                           鍵盤映射
menutrans VimInfo                                       Vim相關
menutrans Color                                         色彩測試
menutrans Hitest                                        高亮測試
menutrans BugReport                                     報告BUG
menutrans Version                                       編譯信息
menutrans Scriptname                                    腳本載入信息
menutrans About                                         關于

" File menu
menutrans &File                                         檔案(&F)
menutrans New                                           新增
menutrans NewTemplate                                   新增模板
menutrans Open                                          打開
menutrans Save                                          存儲
menutrans SaveAs                                        另存新檔
menutrans SaveALL                                       全部存儲
menutrans Convert                                       轉換
menutrans ToDos                                         轉換為Dos編碼
menutrans ToMac                                         轉換為Mac編碼
menutrans ToUnix                                        轉換為Unix編碼
menutrans ToANCI                                        轉換為ANCI編碼
menutrans ToUTF8                                        轉換為UTF-8編碼
menutrans ToUtf8-Bom                                    轉換為UTF-8(帶BOM)
menutrans ToBIGEndian                                   轉換為UCS-2\ Big\ Endian編碼
menutrans ToLittleEndian                                轉換為UCS-2\ Little\ Endian編碼
menutrans HistoryRecords                                檔案打開記錄
menutrans Print                                         立印
menutrans Exit                                          存儲並退出
" Edit menu
menutrans &Edit                                         編輯(&E)
menutrans Undo                                          撤銷
menutrans Redo                                          重做
menutrans Repeat                                        重複上次操作
menutrans Cut                                           剪下
menutrans Copy                                          複制
menutrans Paste                                         貼上
menutrans CopyAll                                       全選
menutrans Settype                                       排版
menutrans Search                                        查找與替換
menutrans Promptfind                                    查找
menutrans Replace                                       替換
menutrans GoTo                                          行跳轉
menutrans Advanced                                      高級
menutrans Remove\ Unnecessary\ Blank\ And\ Eol          清除空行和行尾空白
menutrans Tab\ To\ Blank                                將制表符轉換為空格
menutrans Blank\ To\ Tab                                將空格轉換成制表符
menutrans Uppercase\ Or\ Lowercase                      大小寫轉換
menutrans Replace\ ^M                                   將^M替換為換行符
menutrans Hide\ Or\ Show\ Blanks                        顯示或隱藏空白字符
menutrans Comment\ Or\ Uncomment                        選定內容添加或去掉注解
menutrans Increase\ Line\ Indent                        增加行縮排
menutrans Decrease\ Line\ Indent                        減少行縮排
menutrans Paragraph                                     行列
menutrans Center                                        居中對齊
menutrans Left                                          左對齊
menutrans Right                                         右對齊
"--View---
menutrans &View                                         檢視(&V)
menutrans FileExplore                                   檔案瀏覽器
menutrans Toggle\ FileExplore                           開關檔案瀏覽器
menutrans Toggle\ MarksTree                             開關書簽樹
menutrans Toggle\ TagsBrowser                           對象瀏覽器
menutrans Shell                                         命令視窗
menutrans Quickfix                                      錯誤列表
menutrans Update\ Quickfix                              更新錯誤列表
menutrans Toggle\ Quickfix                              開關錯誤列表
menutrans Bookmark                                      書簽列表
menutrans Add\ Bookmark                                 添加書簽
menutrans Toggle\ Bookmark                              開關書簽列表
menutrans Fold\ Or\ Unfold\ All                         折疊或伸展所有層次
menutrans Windows\ Manager                              視窗管理
menutrans Close\ This\ Window                           關閉當前視窗
menutrans Close\ Other\ Windows                         關閉其它視窗
menutrans Split\ This\ Window                           分割當前視窗
menutrans Close\ Other\ Tabs                            關閉其他標簽頁
menutrans New\ Window                                   新增視窗
menutrans Synchronize\ Window                           開關同步滾動
menutrans Customized                                    自定義視圖
menutrans Hide\ Or\ Show\ Toolbar                       顯示或隱藏工具欄
menutrans Hide\ Or\ Show\ Menubar                       顯示或隱藏菜單欄
menutrans Hide\ Or\ Show\ Right\ Scrollbar              顯示或隱藏右端滾動條
menutrans Hide\ Or\ Show\ Bottom\ Scrollbar             顯示或隱藏底部滾動條
menutrans Hide\ Or\ Show\ Line\ Number                  顯示或隱藏行號
menutrans Hide\ Or\ Show\ Statusbar                     顯示或隱藏狀態欄
menutrans Hide\ Or\ Show\ Ruler                         顯示或隱藏標尺
menutrans Hide\ Or\ Show\ Tab&Blank                     顯示或隱藏空白字符
menutrans Save\ Session                                 存儲當前視圖
menutrans Color\ Scheme                                 選擇主題
menutrans Highlight\ Search                             顯示或隱藏搜尋高亮
menutrans Switch\ View                                  切換視圖顯示方式
menutrans Toggle\ AutoComplete                          開啟或關閉自動提示
menutrans Font                                          選擇字體
menutrans Summary                                       字數統計
menutrans Window\ Setting                               視窗設置
menutrans Alpha                                         視窗透明
menutrans Reset\ Alpha                                  關閉視窗透明
menutrans Maximized\ Enable                             最大化視窗
menutrans Maximized\ Disable                            關閉視窗最大化
menutrans TopMost\ Enable                               視窗置頂
menutrans TopMost\ Disable                              關閉視窗置頂

"--Tools--
menutrans   &Tools                                      工具(&T)
menutrans   Add\ Plugin                                 安裝外掛模組
menutrans   Run\ VimScript                              運行腳本
menutrans   Preview                                     預覽檔案
menutrans   Compiler                                    編譯
menutrans   SetCompiler                                 設定編譯器
menutrans   Insert                                      插入
menutrans   Insert\ File                                插入檔案
menutrans   Insert\ Datetime                            插入日期
menutrans   Insert\ Filepath                            插入路徑
menutrans   Hex                                         十六進制轉換
menutrans   To\ Hex                                     轉換為十六進制
menutrans   To\ Ascii                                   轉換為正常模式
menutrans   Export\ To\ Html                            轉換為HTML檔案
menutrans   Spell\ Checker                              拼寫檢查
menutrans   Make\ Tags                                  新增Tags檔案
menutrans   Vim\ Diff                                   檔案比較
menutrans   Macros                                      巨集
menutrans   Tape                                        錄制
menutrans   Stop                                        停止
menutrans   Play                                        播放
menutrans   G2B                                         簡繁轉換
menutrans   Tocn                                        繁轉簡
menutrans   Totw                                        簡轉繁
" The popup menu
menutrans PopUp\ Copy                                   複\ 制
menutrans Copy\ Whole\ Line                             複制行
menutrans Copy\ To\ Tail                                複制至行尾
menutrans Copy\ To\ Head                                複制至行首
menutrans PopUp\ Cut                                    剪\ 下
menutrans Cut\ Whole\ Line                              剪下行
menutrans Cut\ To\ Tail                                 剪下至行尾
menutrans Cut\ To\ Head                                 剪下至行首
menutrans PopUp\ Delete                                 清\ 除
menutrans Delete\ To\ Tail                              清除至行尾
menutrans Delete\ To\ Head                              清除至行首
menutrans Delete\ Whole\ Line                           清除行
menutrans PopUp\ Search                                 搜尋
menutrans Add\ Bookmark                                 添加書簽
menutrans Delete\ Bookmark                              清除書簽
menutrans Insert\ Line\ Number                          插入行號
menutrans Ascii                                         查閱ASCII碼
menutrans Comment                                       添加或消去注解
menutrans EVTree                                        檔案瀏覽器
menutrans Refresh                                       刷新
menutrans Filter                                        檔案過濾
menutrans Rename                                        重新命名
menutrans SearchByNames                                 按檔案名稱搜尋
menutrans SearchByContents                              按檔案內容搜尋
