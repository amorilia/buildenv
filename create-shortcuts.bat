@echo off

@for %%a in (ini\*.ini) do shortcut.vbs "%HOMEDRIVE%%HOMEPATH%\Desktop\Buildenv-%%~na.lnk" "%comspec%" "/k  %~dps0buildenv.bat %%~dfsa"
echo.Shortcuts created.
