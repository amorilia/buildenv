@echo off

@for %%a in (ini\*.ini) do shortcut.vbs "%HOMEDRIVE%%HOMEPATH%\Desktop\%%~na.lnk" "%comspec%" "/k %~dp0buildenv.bat %%~dfa"
echo.Shortcuts created.