@echo off
@set PATH=C:\Program Files\wamp\bin\php\php5.3.0;C:\MinGW\bin;C:\MinGW\msys\1.0\bin;C:\cygwin\bin;C:\Python27;C:\Python32;C:\Program Files\NSISzh;C:\Program Files\NSIS;%PATH%
if exist "C:\Program Files\Microsoft Visual Studio\VC98\Bin\VCVARS32.BAT" (goto label_VC98)  else goto label_VS2010

@:label_VC98
@call VCVARS32.BAT
@goto end

@:label_VS2010
@if exist "C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\vcvars32.bat" (call "C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\vcvars32.bat")
@goto end

:end
cmd /C %1