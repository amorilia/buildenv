@echo off

set cscript_path=%HOMEDRIVE%\Windows\System32\cscript.exe
if exist %csript_path% goto runscript
goto no_script

:run_script
@for %%a in (ini\*.ini) do  shortcut.vbs "%HOMEDRIVE%%HOMEPATH%\Desktop\%%~na.lnk" "%comspec%" "/k %~dp0buildenv.bat %%~dfa"
goto cleanup

:no_script
echo. Could not find Cscript.exe
goto cleanup

:cleanup
set cscript=