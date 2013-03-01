!define PRODUCT_NAME            "EasyVim"
!define PRODUCT_VERSION         "1.0.0.1"
!define VIM_VERSION             "7.3.766"
!define PRODUCT_PUBLISHER       "Henson(sheng.he.china@gmail.com)"
!define LANGUAGE                "en_US"
!define PRODUCT_DIR_REGKEY      "Software\Microsoft\Windows\CurrentVersion\App Paths\gvim.exe"
!define PRODUCT_UNINST_KEY      "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_SETUP_NAME      "EasyVIM${PRODUCT_VERSION}-VIM${VIM_VERSION}-${LANGUAGE}"


SetCompressor lzma

!include "MUI.nsh"
!include "WordFunc.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\easyvim-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"


!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "SimpChinese"

!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

Name "${PRODUCT_NAME}"
OutFile "..\..\..\..\publish\release\${PRODUCT_SETUP_NAME}.exe"
InstallDir "$PROGRAMFILES\EasyVim"
ShowInstDetails nevershow
ShowUnInstDetails nevershow
RequestExecutionLevel admin
BrandingText "EasyVIM"

Section -EasyVIM
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "..\..\..\..\src\vim7.3\VIM-master\src\gvim.exe"
  File "..\..\..\..\src\vim7.3\VIM-master\src\vim.exe"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\bugreport.vim"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\filetype.vim"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\mswin.vim"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\optwin.vim"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\rgb.txt"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\termcap"

  File /nonfatal /oname=Readme.txt "..\..\..\..\src\easyvim\Readme_${LANGUAGE}.txt"
  File "..\..\..\..\src\easyvim\_vimrc"
  File /nonfatal "..\..\..\..\src\easyvim\menu.vim"

  SetOutPath "$INSTDIR\doc"
  File /r "..\..\..\..\src\docs\${LANGUAGE}\*.*"

  SetOutPath "$INSTDIR\tools"
  File "..\..\..\..\src\vim7.3\VIM-master\src\vimrun.exe"
  File "..\..\..\..\src\vim7.3\VIM-master\src\VisVim\VisVim.dll"
  File "..\..\..\..\src\vim7.3\VIM-master\src\xxd\xxd.exe"
  File "..\..\..\..\src\vim7.3\VIM-master\src\vimtbar.dll"
  File "..\..\..\..\publish\tools\vimtweak\vimtweak.dll"
  File "..\..\..\..\publish\tools\diff\diff.exe"
  File "..\..\..\..\publish\tools\iconv\iconv.dll"
  File "..\..\..\..\publish\tools\iconv\libintl.dll"
  File "..\..\..\..\publish\tools\ctags\ctags.exe"
  File "..\..\..\..\publish\tools\cscope\cscope.exe"
  File "..\..\..\..\publish\tools\JSLint\jsl.default.conf"
  File "..\..\..\..\publish\tools\JSLint\jsl.exe"

  SetOutPath "$INSTDIR\colors"
  File "..\..\..\..\src\easyvim\colors\molokai.vim"
  File /nonfatal "..\..\..\..\src\easyvim\colors\easyvim.vim"

  SetOutPath "$INSTDIR\compiler"
  File "..\..\..\..\src\easyvim\compiler\cpp.vim"
  File "..\..\..\..\src\easyvim\compiler\c.vim"
  File "..\..\..\..\src\easyvim\compiler\cs.vim"
  File /nonfatal "..\..\..\..\src\easyvim\compiler\sln.vim"
  File /nonfatal "..\..\..\..\src\easyvim\compiler\csproj.vim"
  File "..\..\..\..\src\easyvim\compiler\java.vim"
  File "..\..\..\..\src\easyvim\compiler\js.vim"
  File "..\..\..\..\src\easyvim\compiler\php.vim"
  File "..\..\..\..\src\easyvim\compiler\python.vim"
  File "..\..\..\..\src\easyvim\compiler\nsis.vim"

  SetOutPath "$INSTDIR\autoload"
  File /r "..\..\..\..\src\vim7.3\VIM-master\runtime\autoload\*.*"
  File /nonfatal /r "..\..\..\..\src\easyvim\autoload\*.*"

  SetOutPath "$INSTDIR\ftplugin"
  File /r "..\..\..\..\src\vim7.3\VIM-master\runtime\ftplugin\*.*"
  File /nonfatal /r "..\..\..\..\src\easyvim\ftplugin\*.*"

  SetOutPath "$INSTDIR\indent"
  File /r "..\..\..\..\src\vim7.3\VIM-master\runtime\indent\*.*"
  File /nonfatal /r "..\..\..\..\src\easyvim\indent\*.*"

  SetOutPath "$INSTDIR\keymap"
  ${If} ${LANGUAGE} != "zh_CN"
    File /r "..\..\..\..\src\vim7.3\VIM-master\runtime\keymap\*.*"
    File /nonfatal /r "..\..\..\..\src\easyvim\keymap\*.*"
  ${else}
    File "..\..\..\..\src\vim7.3\VIM-master\runtime\keymap\pinyin.vim"
  ${Endif}

  SetOutPath "$INSTDIR\lang"
  File /r "..\..\..\..\src\vim7.3\VIM-master\runtime\lang\*.*"

  SetOutPath "$INSTDIR\plugin"
  File /r "..\..\..\..\src\vim7.3\VIM-master\runtime\plugin\*.*"
  File /nonfatal  /r  "..\..\..\..\src\easyvim\plugin\*.*"

  SetOutPath "$INSTDIR\snippets"
  File /nonfatal /r "..\..\..\..\src\easyvim\snippets\*.*"

  SetOutPath "$INSTDIR\spell"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\spell\en.ascii.spl"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\spell\en.ascii.sug"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\spell\en.latin1.spl"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\spell\en.latin1.sug"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\spell\en.utf-8.spl"
  File "..\..\..\..\src\vim7.3\VIM-master\runtime\spell\en.utf-8.sug"

  SetOutPath "$INSTDIR\syntax"
  File /r "..\..\..\..\src\vim7.3\VIM-master\runtime\syntax\*.*"
  File /nonfatal /r "..\..\..\..\src\easyvim\syntax\*.*"
  SetAutoClose true
SectionEnd

Section -Post
  SetShellVarContext all
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName"     "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"  "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher"       "${PRODUCT_PUBLISHER}"

  WriteRegStr HKLM  "Software\Vim\Gvim" "path" "$INSTDIR\gvim.exe"
  WriteRegStr HKCR "*\shell\Edit With EasyVim\command" "" "$INSTDIR\gvim.exe -p --remote-tab-silent %1 %*"

  ExecShell regsvr32.exe "$INSTDIR\tools\VisVim.dll"

  ReadRegStr $0 HKCU "Environment" "PATH"
  StrCpy $1 $INSTDIR
  IfFileExists "$INSTDIR\tools\*.*" Has_TOOLS 0
  Has_TOOLS:
    StrCpy $1 "$1;$INSTDIR;$INSTDIR\tools;"
  ${WordAdd} $0 ";" "+$1" $2
  WriteRegExpandStr HKCU "Environment" "PATH" "$2"

  CreateDirectory "$SMPROGRAMS\EasyVim"
  CreateShortCut  "$SMPROGRAMS\EasyVim\EasyVim.lnk" "$INSTDIR\gvim.exe"
  CreateShortCut  "$SMPROGRAMS\EasyVim\VIM.lnk" "$INSTDIR\vim.exe"
  CreateShortCut  "$SMPROGRAMS\EasyVim\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut  "$DESKTOP\EasyVim.lnk" "$INSTDIR\gvim.exe"
  ExecShell taskbarpin "$DESKTOP\EasyVim.lnk"
  ExecShell startpin   "$DESKTOP\EasyVim.lnk"
SectionEnd


Section Uninstall
  SetShellVarContext all

  ExecShell taskbarunpin "$DESKTOP\EasyVim.lnk"
  ExecShell startunpin   "$DESKTOP\EasyVim.lnk"
  Delete "$SMPROGRAMS\EasyVim\EasyVim.lnk"
  Delete "$SMPROGRAMS\EasyVim\Uninstall.lnk"
  Delete "$DESKTOP\EasyVim.lnk"
  RMDir /r /REBOOTOK "$SMPROGRAMS\EasyVim\"

  ReadRegStr $4 HKCU "Environment" "PATH"
  ${WordAdd} $4 ";" "-$INSTDIR;$INSTDIR\tools" $5
  WriteRegExpandStr HKCU "Environment" "PATH" "$5"

  DeleteRegKey HKCR "*\shell\Edit With EasyVim"
  DeleteRegKey HKLM  "Software\Vim\Gvim"

  ExecShell regsvr32.exe -unregister "$INSTDIR\tools\VisVim.dll"

  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\_vimrc"
  Delete "$INSTDIR\gvim.exe"
  Delete "$INSTDIR\vim.exe"
  Delete "$INSTDIR\menu.vim"
  Delete "$INSTDIR\bugreport.vim"
  Delete "$INSTDIR\filetype.vim"
  Delete "$INSTDIR\mswin.vim"
  Delete "$INSTDIR\optwin.vim"
  Delete "$INSTDIR\rgb.txt"
  Delete "$INSTDIR\termcap"

  RMDir /r /REBOOTOK  "$INSTDIR\autoload"
  RMDir /r /REBOOTOK  "$INSTDIR\colors"
  RMDir /r /REBOOTOK  "$INSTDIR\compiler"
  RMDir /r /REBOOTOK  "$INSTDIR\doc"
  RMDir /r /REBOOTOK  "$INSTDIR\ftplugin"
  RMDir /r /REBOOTOK  "$INSTDIR\indent"
  RMDir /r /REBOOTOK  "$INSTDIR\keymap"
  RMDir /r /REBOOTOK  "$INSTDIR\lang"
  RMDir /r /REBOOTOK  "$INSTDIR\plugin"
  RMDir /r /REBOOTOK  "$INSTDIR\snippets"
  RMDir /r /REBOOTOK  "$INSTDIR\spell"
  RMDir /r /REBOOTOK  "$INSTDIR\syntax"
  RMDir /r /REBOOTOK  "$INSTDIR\tools"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

Function un.onInit
  Call un.CreateMutex
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure to completely remove the $(^NAME), and all components?" IDYES +2
  Abort
FunctionEnd

Function .onInit
  ReadRegStr $R0 HKLM "${PRODUCT_UNINST_KEY}" "DisplayVersion"
	StrCmp $R0 ${PRODUCT_VERSION} 0 +3
	MessageBox MB_YESNO "The Software has Installed, Are you sure to uninstall£¿" IDyes yes IDNO no
no:
	Abort "Cancled the installation!"
yes:
  ClearErrors
  ReadRegStr $R1 HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
	${If} $R1 != ""
    Execwait '$R1 _?=$INSTDIR' $R2
    ${If} $R2 == 2
      Abort
    ${Endif}
	${Endif}
  Call CreateMutex
FunctionEnd

Function CreateMutex
  ReCheck:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME}") i .R1 ?e'
  Pop $R0
  System::Call 'kernel32::CloseHandle(i R1) i.s'
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME}") i .R3 ?e'
  Pop $R2
  System::Call 'kernel32::CloseHandle(i R3) i.s'
  ${If} $R0 != 0
    MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "The software is running!" IdRetry ReCheck
    Quit
  ${ElseIf} $R2 != 0
    MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "The software is running!" IdRetry ReCheck
    Quit
  ${Else}
    System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME}") i .R1 ?e'
    Pop $R0
    StrCmp $R0 0 +2
    Quit
  ${EndIf}
FunctionEnd

Function un.CreateMutex
  ReCheck:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME}") i .R1 ?e'
  Pop $R0
  System::Call 'kernel32::CloseHandle(i R1) i.s'
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME}") i .R3 ?e'
  Pop $R2
  System::Call 'kernel32::CloseHandle(i R3) i.s'
  ${If} $R0 != 0
    MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "The software is running£¡" IdRetry ReCheck
    Quit
  ${ElseIf} $R2 != 0
    MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "The software is running£¡" IdRetry ReCheck
    Quit
  ${Else}
    System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME}") i .R1 ?e'
    Pop $R0
    StrCmp $R0 0 +2
    Quit
  ${EndIf}
FunctionEnd
