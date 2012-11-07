@echo off

rem Three scenarios, user pass 0, 1 or 2 params
rem create-shortcuts.bat [ini source] [shortcut folder dest]

:checkiniparam
if exist "%1" (
set _ini_location=%1 
) else ( 
set _ini_location=ini
)
echo.Setting input folder [folder: %_ini_location%]

:checkshortcutparam
if exist "%2" (
set _shortcut_folder=%2
) else (
goto checkoutfolder
)
echo.Setting output folder [folder: %_shortcut_folder%]
goto createshortcut

:checkoutfolder
if exist "%HOMEDRIVE%%HOMEPATH%\Desktop" ( 
set _shortcut_folder=%HOMEDRIVE%%HOMEPATH%\Desktop
) else (
echo. Could not find default Desktop location
goto error
) 

echo.Setting output folder [folder: %_shortcut_folder%]
goto createshortcut

:createshortcut
@for %%a in (%_ini_location%\*.ini) do shortcut.vbs "%_shortcut_folder%\%%~na.lnk" "%comspec%" "/k  %~dps0buildenv.bat %%~dfsa"
echo.Shortcuts created.
echo.Ini files read from [folder: %_ini_location%]
echo.Shortcut written to [folder: %_shortcut_folder%]

goto eof

:error
echo.Unable to locate scripts.
echo.Please pass correct path additional parameters: 
echo.create-shortcuts.bat [ini source folder] [shortcut destination folder] 
echo.
echo.Attempted to read .ini files from [folder: %_ini_location%]
echo.Attempted to write Shortcuts to [folder: %_shortcut_folder%]
echo.

:eof
set _shortcut_folder=
set _ini_location=