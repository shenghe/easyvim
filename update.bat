@rem           author : Henson  (sheng.he.china@gmail.com)
@rem         modified : 2013-01-14
@rem          project : EasyVim

@set path=%path%;.\publish\tools\wget;.\publish\tools\patch;.\publish\tools\7zip;

@set src_url=https://github.com/shenghe/VIM/archive/master.zip
@set src_dir=.\src\vim7.3\

IF NOT EXIST "%src_dir%\master" (
	wget --no-check-certificate %src_url% -P %src_dir%
)

IF EXIST "%src_dir%\master" (
	@rd /S /R "src_dir%\VIM-master"
	7z x -y "%src_dir%\master" -o"%src_dir%"
	@rem del %src_dir%\master
)