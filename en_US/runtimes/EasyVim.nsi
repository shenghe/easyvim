; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "EasyVim"
!define EasyVimPath "."
!define EasyVimVersion "1.0beta"
!define VER_MAJOR 7
!define VER_MINOR 3
!define PRODUCT_VERSION "${EasyVimVersion}(Gvim${VER_MAJOR}.${VER_MINOR})"
!define PRODUCT_PUBLISHER "HeSheng(sheng.he.china@gmail.com)"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma


!include "MUI.nsh"
!include "WordFunc.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "${EasyVimPath}/install.ico"
!define MUI_UNICON "${EasyVimPath}/uninstall.ico"


!insertmacro MUI_PAGE_WELCOME

;!insertmacro MUI_PAGE_COMPONENTS

!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_PAGE_FINISH


!insertmacro MUI_UNPAGE_INSTFILES


!insertmacro MUI_LANGUAGE "English"


!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS


Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}_Win_English.exe"
InstallDir "$PROGRAMFILES\EasyVim"
ShowInstDetails nevershow
ShowUnInstDetails nevershow
BrandingText " "

Section -Gvim
  SetOutPath "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}"
  SetOverwrite ifnewer
  File /r "${EasyVimPath}\vim${VER_MAJOR}${VER_MINOR}\*.*"
SectionEnd

Section -easyvim
    SetOutPath "$INSTDIR\easyvim"
    SetOverwrite ifnewer
    File /r "${EasyVimPath}\easyvim\*.*"
    SetOutPath "$INSTDIR"
    File /r "${EasyVimPath}\_vimrc"
SectionEnd

Section -AdditionalIcons
  CreateDirectory "$SMPROGRAMS\EasyVim"
  CreateShortCut "$SMPROGRAMS\EasyVim\EasyVim.lnk" "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}\gvim.exe"
  CreateShortCut "$SMPROGRAMS\EasyVim\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$DESKTOP\EasyVim.lnk" "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}\gvim.exe"
  ;CreateShortCut "$QUICKLAUNCH\User Pinned\TaskBar\EasyVim.lnk" "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}\gvim.exe"
  ;ExecShell taskbarpin "$DESKTOP\EasyVim.lnk"
  ExecShell startpin "$DESKTOP\EasyVim.lnk"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  ;WriteRegStr HKCR  "CLSID\{51EEE242-AD87-11d3-9C1E-0090278BBD99}" "" "Vim Shell Extension"
  ;WriteRegStr HKCR  "CLSID\{51EEE242-AD87-11d3-9C1E-0090278BBD99}\InProcServer32" "" "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}\gvimext.dll"
  ;WriteRegStr HKCR  "CLSID\{51EEE242-AD87-11d3-9C1E-0090278BBD99}\InProcServer32" "ThreadingModel" "Apartment"
  ;WriteRegStr HKCR  "*\shellex\ContextMenuHandlers\gvim" "" "{51EEE242-AD87-11d3-9C1E-0090278BBD99}"
  ;WriteRegStr HKLM  "Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved" "{51EEE242-AD87-11d3-9C1E-0090278BBD99}" "Vim Shell Extension"
  WriteRegStr HKLM  "Software\Vim\Gvim" "path" "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}\gvim.exe"
  WriteRegStr HKCR "*\shell\Edit With EasyVim\command" "" "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}\gvim.exe -p --remote-tab-silent %1 %*"
  ReadRegStr $0 HKCU "Environment" "PATH"
  StrCpy $1 "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}"
  IfFileExists "$INSTDIR\easyvim\tools\*.*" Has_EasyVim 0
  Has_EasyVim:
    StrCpy $1 "$1;$INSTDIR\easyvim\tools"

  IfFileExists "C:\Program Files\NSISzh\*.*" Has_NSISzh 0
  Has_NSISzh:
    StrCpy $1 "$1;C:\Program Files\NSISzh"

  IfFileExists "C:\Program Files\NSIS\*.*" Has_NSIS 0
  Has_NSIS:
    StrCpy $1 "$1;C:\Program Files\NSIS"

  IfFileExists "C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\*.*" Has_Vs010 0
  Has_Vs010:
    StrCpy $1 "$1;C:\Program Files\Microsoft Visual Studio 10.0\VC\bin"

  IfFileExists "C:\Program Files\Microsoft Visual Studio\VC98\Bin\*.*" Has_VC98 0
  Has_VC98:
    StrCpy $1 "$1;C:\Program Files\Microsoft Visual Studio\VC98\Bin"


  IfFileExists "C:\MinGW\bin\*.*" Has_MinGW 0
  Has_MinGW:
    StrCpy $1 "$1;C:\MinGW\bin"
    

  ${WordAdd} $0 ";" "+$1" $2
  WriteRegExpandStr HKCU "Environment" "PATH" "$2"
SectionEnd


Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$SMPROGRAMS\EasyVim\EasyVim.lnk"
  Delete "$SMPROGRAMS\EasyVim\Uninstall.lnk"
  RMDir /r /REBOOTOK "$SMPROGRAMS\EasyVim\"
  Delete "$INSTDIR\_vimrc"
  RMDir /r /REBOOTOK  "$INSTDIR\vim${VER_MAJOR}${VER_MINOR}"
  RMDir /r /REBOOTOK "$INSTDIR\easyvim"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  ;DeleteRegKey HKCR "CLSID\{51EEE242-AD87-11d3-9C1E-0090278BBD99}"
  ;DeleteRegKey HKCR  "*\shellex\ContextMenuHandlers\gvim"
  DeleteRegKey HKCR "*\shell\Edit With EasyVim"
  DeleteRegKey HKLM  "Software\Vim\Gvim"
  DeleteRegKey HKLM  "Software\Microsoft\Windows\CurrentVersion\Uninstall\EasyVim"
  DeleteRegValue HKLM  "Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved" "{51EEE242-AD87-11d3-9C1E-0090278BBD99}"
  IfFileExists "$DESKTOP\EasyVim.lnk" Has_Desktop 0
  Has_Desktop:
    Delete "$DESKTOP\EasyVim.lnk"
    
  IfFileExists "$QUICKLAUNCH\User Pinned\TaskBar\EasyVim.lnk" Has_TaskBar 0
  Has_TaskBar:
    Delete "$QUICKLAUNCH\User Pinned\TaskBar\EasyVim.lnk"

  IfFileExists "$QUICKLAUNCH\User Pinned\StartMenu\EasyVim.lnk" Has_StartMenu 0
  Has_StartMenu:
    Delete "$QUICKLAUNCH\User Pinned\StartMenu\EasyVim.lnk"
    
  ReadRegStr $4 HKCU "Environment" "PATH"
  ${WordAdd} $4 ";" "-$INSTDIR\vim${VER_MAJOR}${VER_MINOR};$INSTDIR\easyvim\tools;C:\Program Files\NSISzh;C:\Program Files\NSIS" $5
  WriteRegExpandStr HKCU "Environment" "PATH" "$5"

	SetAutoClose true
SectionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Would you like to delete  $(^Name) and the runtime files？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "Completely!"
FunctionEnd
