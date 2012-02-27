@echo off
@if exist "../verbose" DEL /Q /F "../verbose"
@if exist "../dict" DEL /Q /F "../dict"
@if exist "../swap" DEL /Q /F "../swap"
@if exist  "../backup" DEL /Q /F "../backup"
@if exist "../verbose" RD /Q /S "../verbose"
@if exist "../dict" RD /Q /S "../dict"
@if exist "../swap" RD /Q /S "../swap"
@if exist  "../backup" RD /Q /S "../backup"
@if exist  %HOME%/_viminfo DEL /Q /F %HOME%/_viminfo