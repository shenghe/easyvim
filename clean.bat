@rem           author : Henson  (sheng.he.china@gmail.com)
@rem         modified : 2013-01-14
@rem          project : EasyVim

@set root=%CD%

@cd /d %root%\src\vim7.3\VIM-master\src

@del /S /F /Q *.rej
@del /S /F /Q *.orig
@del /S /F /Q *.obj

@del /S /F /Q gvim.exe
@del /S /F /Q vim.exe
@del /S /F /Q vimrun.exe
@del /S /F /Q xxd\xxd.exe
@del /S /F /Q install.exe
@del /S /F /Q uninstal.exe
@rd /S /Q ObjGYHi386
@rd /S /Q ObjCYHi386

@cd /d "%root%"
