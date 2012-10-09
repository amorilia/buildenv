@for %%a in (ini\*.ini) do  cscript shortcut.vbs "%HOMEDRIVE%%HOMEPATH%\Desktop\%%~na.lnk" "%comspec%" "/k %~dp0buildenv.bat %%~dfa"
