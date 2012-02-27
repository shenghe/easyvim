" The plugin file for EasyVim Project

" Maintainer : HESHENG-PC(sheng.he.china@gmail.com)
" File : menu_chinese_gb.936.vim
" Date : 2012/2/26 11:05:44

if exists("did_menu_trans")
  finish
endif
let did_menu_trans = 1

scriptencoding cp936
menut clear
" Help menu
menutrans &Help                                         帮助(&H)
menutrans SearchHelp                                    查找帮助
menutrans Navigation                                    导航
menutrans Overview                                      纵览
menutrans Vimtutor                                      新手手册
menutrans Function                                      函数列表
menutrans Option                                        选项列表
menutrans Eval                                          脚本入门
menutrans Map                                           键盘映射
menutrans VimInfo                                       Vim相关
menutrans Color                                         色彩测试
menutrans Hitest                                        高亮测试
menutrans BugReport                                     报告BUG
menutrans Version                                       编译信息
menutrans Scriptname                                    脚本载入信息
menutrans About                                         关于

" File menu
menutrans &File                                         文件(&F)
menutrans New                                           新建
menutrans NewTemplate                                   新建模板
menutrans Open                                          打开
menutrans Save                                          保存
menutrans SaveAs                                        另存为
menutrans SaveALL                                       全部保存
menutrans Convert                                       转换
menutrans ToDos                                         转换为Dos编码
menutrans ToMac                                         转换为Mac编码
menutrans ToUnix                                        转换为Unix编码
menutrans ToANCI                                        转换为ANCI编码
menutrans ToUTF8                                        转换为UTF-8编码
menutrans ToUtf8-Bom                                    转换为UTF-8(带BOM)
menutrans ToBIGEndian                                   转换为UCS-2\ Big\ Endian编码
menutrans ToLittleEndian                                转换为UCS-2\ Little\ Endian编码
menutrans HistoryRecords                                文件打开记录
menutrans Print                                         打印
menutrans Exit                                          保存并退出
" Edit menu
menutrans &Edit                                         编辑(&E)
menutrans Undo                                          撤销
menutrans Redo                                          重做
menutrans Repeat                                        重复上次操作
menutrans Cut                                           剪切
menutrans Copy                                          复制
menutrans Paste                                         粘贴
menutrans CopyAll                                       全选
menutrans Settype                                       排版
menutrans Search                                        查找与替换
menutrans Promptfind                                    查找
menutrans Replace                                       替换
menutrans GoTo                                          行跳转
menutrans Advanced                                      高级
menutrans Remove\ Unnecessary\ Blank\ And\ Eol          删除空行和行尾空白
menutrans Tab\ To\ Blank                                将制表符转换为空格
menutrans Blank\ To\ Tab                                将空格转换成制表符
menutrans Uppercase\ Or\ Lowercase                      大小写转换
menutrans Replace\ ^M                                   将^M替换为换行符
menutrans Hide\ Or\ Show\ Blanks                        显示或隐藏空白字符
menutrans Comment\ Or\ Uncomment                        选定内容添加或去掉注释
menutrans Increase\ Line\ Indent                        增加行缩进
menutrans Decrease\ Line\ Indent                        减少行缩进
menutrans Paragraph                                     段落
menutrans Center                                        居中对齐
menutrans Left                                          左对齐
menutrans Right                                         右对齐
"--View---
menutrans &View                                         视图(&V)
menutrans FileExplore                                   资源管理器
menutrans Toggle\ FileExplore                           开关资源管理器
menutrans Toggle\ MarksTree                             开关资源记录窗口
menutrans Toggle\ TagsBrowser                           对象浏览器
menutrans Shell                                         命令窗口
menutrans Quickfix                                      错误列表
menutrans Update\ Quickfix                              更新错误列表
menutrans Toggle\ Quickfix                              开关错误列表
menutrans Bookmark                                      书签列表
menutrans Add\ Bookmark                                 添加书签
menutrans Delete\ Bookmark                              删除书签
menutrans Search\ Bookmark                              查找书签
menutrans Toggle\ Bookmark                              开关书签列表
menutrans Other\ Windows                                更多窗口
menutrans Toggle\ Buffer                                开关Buffer窗口
menutrans Toggle\ Mark                                  开关标签窗口
menutrans Toggle\ Tag                                   开关Tags窗口
menutrans Toggle\ Sign                                  切换标记
menutrans Fold\ Or\ Unfold\ All                         展开或关闭所有折叠
menutrans Windows\ Manager                              窗口管理
menutrans Close\ This\ Window                           关闭当前窗口
menutrans Close\ Other\ Windows                         关闭其它窗口
menutrans Split\ This\ Window                           分割当前窗口
menutrans Close\ Other\ Tabs                            关闭其他标签页
menutrans New\ Window                                   新建窗口
menutrans Synchronize\ Window                           开关同步滚动
menutrans Customized                                    自定义视图
menutrans Hide\ Or\ Show\ Toolbar                       显示或隐藏工具栏
menutrans Hide\ Or\ Show\ Menubar                       显示或隐藏菜单栏
menutrans Hide\ Or\ Show\ Right\ Scrollbar              显示或隐藏右端滚动条
menutrans Hide\ Or\ Show\ Bottom\ Scrollbar             显示或隐藏底部滚动条
menutrans Hide\ Or\ Show\ Line\ Number                  显示或隐藏行号
menutrans Hide\ Or\ Show\ Statusbar                     显示或隐藏状态栏
menutrans Hide\ Or\ Show\ Ruler                         显示或隐藏标尺
menutrans Hide\ Or\ Show\ Tab&Blank                     显示或隐藏空白字符
menutrans Save\ Session                                 保存当前视图
menutrans Color\ Scheme                                 选择主题
menutrans Highlight\ Search                             显示或隐藏搜索高亮
menutrans Switch\ View                                  切换视图显示方式
menutrans Toggle\ AutoComplete                          开启或关闭自动提示
menutrans Font                                          选择字体
menutrans Summary                                       字数统计
menutrans Window\ Setting                               窗口设置
menutrans Alpha                                         窗口透明
menutrans Reset\ Alpha                                  关闭窗口透明
menutrans Maximized\ Enable                             最大化窗口
menutrans Maximized\ Disable                            关闭窗口最大化
menutrans TopMost\ Enable                               窗口置顶
menutrans TopMost\ Disable                              关闭窗口置顶

"--Tools--
menutrans   &Tools                                      工具(&T)
menutrans   Add\ Plugin                                 安装插件
menutrans   Run\ VimScript                              运行脚本
menutrans   Preview                                     预览文件
menutrans   Compiler                                    编译
menutrans   SetCompiler                                 设定编译器
menutrans   Insert                                      插入
menutrans   Insert\ File                                插入文件
menutrans   Insert\ Datetime                            插入日期
menutrans   Insert\ Filepath                            插入路径
menutrans   Hex                                         十六进制转换
menutrans   To\ Hex                                     转换为十六进制
menutrans   To\ Ascii                                   转换为正常模式
menutrans   Spell\ Checker                              拼写检查

menutrans Tags\ and\ Cscope                             Tags相关设置
menutrans Make\ Cscope\ Datebase                        创建Cscope数据库
menutrans Find\ This\ C\ Symbol                         查找本C符号
menutrans Find\ This\ Function\ Definition              查找本定义
menutrans Find\ Functions\ Called\ By\ This\ Function   查找调用本函数的函数
menutrans Find\ Functions\ Calling\ this\ Function      查找本函数调用的函数
menutrans Find\ this\ text\ string                      查找本字符串
menutrans Find\ files\ including\ this\ file            查找包含本文件的文件
menutrans Find\ this\ egrep\ patten                     查找本egrep模式
menutrans Find\ this\ file                              查找本文件

menutrans   Make\ Tags                                  新建Tags文件
menutrans   Vim\ Diff                                   文件比较
menutrans   Macros                                      录制宏
menutrans   Tape                                        录制
menutrans   Stop                                        停止
menutrans   Play                                        播放
menutrans   G2B                                         简繁转换
menutrans   Tocn                                        繁转简
menutrans   Totw                                        简转繁
menutrans Export\ And\ Import                           导入与导出
menutrans Import\ Vimscript                             导入脚本
menutrans Import\ The\ View                             导入视图
menutrans Export\ The\ View                             导出视图
menutrans Export\ The\ Settings                         导出设置
menutrans Export\ To\ Html                              导出为Html
" The popup menu
menutrans PopUp\ Copy                                   复\ 制
menutrans Copy\ Whole\ Line                             复制行
menutrans Copy\ To\ Tail                                复制至行尾
menutrans Copy\ To\ Head                                复制至行首
menutrans PopUp\ Cut                                    剪\ 切
menutrans Cut\ Whole\ Line                              剪切行
menutrans Cut\ To\ Tail                                 剪切至行尾
menutrans Cut\ To\ Head                                 剪切至行首
menutrans PopUp\ Delete                                 删\ 除
menutrans Delete\ To\ Tail                              删除至行尾
menutrans Delete\ To\ Head                              删除至行首
menutrans Delete\ Whole\ Line                           删除行
menutrans PopUp\ Search                                 搜索
menutrans Insert\ Line\ Number                          插入行号
menutrans Ascii                                         查阅ASCII码
menutrans Comment                                       添加或消去注释
menutrans EVTree                                        文件浏览器
menutrans Refresh                                       刷新
menutrans Filter                                        文件过滤
menutrans Delete                                        删除
menutrans Rename                                        重命名
menutrans SearchByNames                                 按文件名称搜索
menutrans SearchByContents                              按文件内容搜索
