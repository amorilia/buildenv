@for %%a in (ini\*.ini) do %HOMEDRIVE%\Windows\System32\cscript.exe shortcut.vbs "%HOMEDRIVE%%HOMEPATH%\Desktop\%%~na.lnk" "%comspec%" "/k %~dp0buildenv.bat %%~dfa"
