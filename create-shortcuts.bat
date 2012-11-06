@echo off

:checkini
if exist "%1" (
set _ini_location=%1
echo.Reading INI files from [folder=%_shortcut_folder%]
goto checkoutfolder
)

set _ini_location=ini

:checkoutfolder
if exist "%HOMEDRIVE%%HOMEPATH%\Desktop" (
set _shortcut_folder=%HOMEDRIVE%%HOMEPATH%\Desktop
echo.Setting output folder [folder=%_shortcut_folder%]
goto createshortcut
)

if exist "%2" (
set _shortcut_folder=%2
echo.Setting output folder [folder=%_shortcut_folder%]
goto createshortcut
)

goto error

:createshortcut
@for %%a in (%_ini_location%\*.ini) do shortcut.vbs "%_shortcut_folder%\%%~na.lnk" "%comspec%" "/k  %~dps0buildenv.bat %%~dfsa"
echo.Shortcuts created.
echo.INI files read from [folder=%_ini_location%]
echo.Shortcut written to [folder=%_shortcut_folder%]
set _shortcut_folder=
set _ini_location=
goto eof

:error
echo.Unable not locate scripts.
echo.Please pass correct path parameters: createshortcuts.bat [ini source folder] [shortcut destination folder] 
echo.
echo.Attempted to read .INI files from [folder=%_ini_location%]
echo.Attempted to write Shortcuts to [folder=%_shortcut_folder%]
echo.

:eof