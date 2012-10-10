@echo off

rem auto-detect sys32 folder
if exist %HOMEDRIVE%\Windows\System32\cscript.exe (
set cscript_path=%HOMEDRIVE%\Windows\System32\cscript.exe
echo.Found Cscript.exe
goto run_script
)

rem check params
if exist "%1" ( 
set cscript_path=%1
echo.Found Cscript.exe
goto run_script
)

echo. Could not find Cscript.exe
goto cleanup

:run_script
@for %%a in (ini\*.ini) do %cscript_path% shortcut.vbs "%HOMEDRIVE%%HOMEPATH%\Desktop\%%~na.lnk" "%comspec%" "/k %~dp0buildenv.bat %%~dfa"
echo.Shortcuts created.
goto cleanup

:cleanup
set cscript_path=