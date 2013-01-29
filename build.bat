@rem           author : Henson  (sheng.he.china@gmail.com)
@rem         modified : 2013-01-28
@rem          project : EasyVim

IF EXIST "C:\Program Files\Microsoft Visual Studio 8.0\Common7\Tools\vsvars32.bat" (
	call "C:\Program Files\Microsoft Visual Studio 8.0\Common7\Tools\vsvars32.bat"
)

IF EXIST "C:\Program Files\Microsoft Visual Studio 9.0\Common7\Tools\vsvars32.bat" (
	call "C:\Program Files\Microsoft Visual Studio 9.0\Common7\Tools\vsvars32.bat"
)

IF EXIST "C:\Program Files\Microsoft Visual Studio 10.0\Common7\Tools\vsvars32.bat" (
	call "C:\Program Files\Microsoft Visual Studio 10.0\Common7\Tools\vsvars32.bat"
)

IF EXIST "C:\Program Files\Microsoft Visual Studio 11.0\Common7\Tools\vsvars32.bat" (
	call "C:\Program Files\Microsoft Visual Studio 11.0\Common7\Tools\vsvars32.bat"
)

IF NOT EXIST "./src/vim7.3/VIM-master" (
	call "./update.bat"
)

@set root=%CD%

cd /d "%root%\src\vim7.3\VIM-master\src"

ren vim.ico vim~.ico
ren tools.bmp tools~.bmp
copy /B /Y "%root%\src\easyvim\vim.ico" vim.ico
copy /B /Y "%root%\src\easyvim\tools.bmp" tools.bmp

nmake -f Make_mvc.mak clean
nmake -f Make_mvc.mak GUI=yes PYTHON=C:\Python27 DYNAMIC_PYTHON=no PYTHON_VER=27 PYTHON3=C:\Python32 DYNAMIC_PYTHON3=yes PYTHON3_VER=32 IME=yes GIME=yes DYNAMIC_IME=yes GDYAMIC_IME=yes MULTI_BYTE=yes MULTI_BYTE_IME=yes USERNAME=sheng.he.china USERDOMAIN=gmail.com DEFINES=-DFEAT_PROPORTIONAL_FONTS FEATURES=HUGE
nmake -f Make_mvc.mak clean
nmake -f Make_mvc.mak PYTHON=C:\Python27 DYNAMIC_PYTHON=no PYTHON_VER=27 PYTHON3=C:\Python32 DYNAMIC_PYTHON3=yes PYTHON3_VER=32 IME=yes GIME=yes DYNAMIC_IME=yes GDYAMIC_IME=yes MULTI_BYTE=yes MULTI_BYTE_IME=yes USERNAME=sheng.he.china USERDOMAIN=gmail.com DEFINES=-DFEAT_PROPORTIONAL_FONTS FEATURES=HUGE

del vim.ico
del tools.bmp
ren vim~.ico vim.ico
ren tools~.bmp tools.bmp

cd /d "%root%\publish\tools\makensis"

IF EXIST "./scripts/EasyVim-win-zh_CN.nsi" (
	makensis "./scripts/EasyVim-win-zh_CN.nsi"
)

IF EXIST "./scripts/EasyVim-win-zh_TW.nsi" (
	makensis "./scripts/EasyVim-win-zh_TW.nsi"
)

IF EXIST "./scripts/EasyVim-win-en_US.nsi" (
	makensis "./scripts/EasyVim-win-en_US.nsi"
)

cd /d %root%

call ./clean.bat

