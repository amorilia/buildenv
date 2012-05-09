@echo off

if "%1" == "-help" ( 
    if "%2" == "" (
    goto displayparams
    ) 
    goto helpcommands 
)

if "%1" == "" (
goto displayparams
)

goto checkparams

:displayparams
    echo.buildenv.bat 
    echo.   -workfolder -arch 
    echo.   [-compiler] [-gitpath] [-pythonpath]   
    echo.   [-qt] [-nsis]
    echo.    
    goto end

:helpcommands
if "%2" == "-arch" ( 
echo.
echo.   Set the Architecture to either :32 or :64
echo.
goto end
)

if "%2" == "-workfolder" ( 
echo.
echo.   Start folder, relative to %HOMEPATH%
echo.   Which folder to use as the root directory. eg. "C:\Documents and Settings\<user>\workspace\"
echo.
goto end
)
    
if "%2" == "-pythonpath" ( 
echo.
echo.   The path to your python installation.
echo.   Path to directory containing python.exe eg. C:\Python32
echo.
goto end
)
    
if "%2" == "-gitpath" ( 
echo.
echo.   Location of msysGit
echo.   
goto end
)
    
if "%2" == "-compiler" ( 
echo.
echo.   Choose which compiler which to use to compile the various Niftools Repos.
echo.   BuildEnv supports [msvc2008] | [mingw]
echo. 
goto end
)

if "%2" == "-nsis" ( 
echo.
echo.   Location of nsis.exe used to create installers for the various Niftools Repos.
echo.
goto end
)

if "%2" == "-qt" ( 
echo.
echo.   Location of qt.
echo.
goto end
)



:checkparams
rem grab the first variable

set SWITCHPARSE=%1
if "%SWITCHPARSE%" == "" ( goto end)

for /F "tokens=1,2 delims=: " %%a IN ("%SWITCHPARSE%") DO SET SWITCH=%%a&set VALUE=%%b

if "%SWITCH%" == "-arch" ( 
set arch_type=%VALUE%
SHIFT
goto architecture
)

if "%SWITCH%" == "-workfolder" ( 
set work_folder = %VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-pythonpath" ( 
set python_path = %VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-gitpath" ( 
set git_path = %VALUE%
SHIFT
goto git
)

if "%SWITCH%" == "-compiler" ( 
set compiler_type = %VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-qtpath" ( 
set qt_location = %VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-nsispath" ( 
set nsis_location = %VALUE%
SHIFT
goto checkparams
)

if "%1" == "" (
goto end
)

SHIFT
goto checkparams


rem ********************
rem *** Architecture ***
rem ********************

:architecture
echo.Setting Program Files
rem get the 32-bit program files folder
if "%arch_type%" == "32" (
    set ProgramFiles32=%ProgramFiles%
)else (
    set ProgramFiles32=%ProgramFiles(x86)%
)
echo. Program Files Folder: %ProgramFiles32%

goto checkparams
:endarchitecture

rem ***********
rem *** Git ***
rem ***********

:git
echo.Setting Git Environment

if "%git_path%" == "" ( 
if exist "%ProgramFiles32%\Git\bin\git.exe" set GITHOME=%ProgramFiles32%\Git
) else (
GITHOME=%git_path%
)

if "%GITHOME%" == "" (
  echo.Git not found
  goto endgit
)
echo.Git home: %GITHOME%
set PATH=%GITHOME%\bin;%PATH%

goto checkparams
:endgit









rem **********
rem *** Qt ***
rem **********

:qt
echo.Setting Qt Environment
rem registry?
if exist "C:\QtSDK" (
  set QTHOME=C:\QtSDK
)
if "%QTHOME%" == "" (
    echo.Qt not found
    goto endqt
)
echo.Qt home: %QTHOME%
for %%A in (4.7.4,4.7.3,4.7.2,4.7.1) do (
  if exist "%QTHOME%\Desktop\Qt\%%A" set QTVERSION=%%A
)
if "%QTVERSION%" == "" (
  echo.Qt version not found
  goto endqt
)
echo.Qt version: %QTVERSION%
if "%2" == "mingw" (
  if exist "%QTHOME%\Desktop\Qt\%QTVERSION%\mingw" set QTDIR=%QTHOME%\Desktop\Qt\%QTVERSION%\mingw
) else (
  echo.Detection of Qt with non-mingw compilers not yet implemented.
  echo.Qt directory not set.
  goto endqt
)
if "%QTDIR%" == "" (
  echo.Qt directory not found
  goto endqt
)
rem PATH set later; see :mingw
echo.Qt directory: %QTDIR%
:endqt



rem ************
rem *** MSVC ***
rem ************

:msvc2008_32
if exist 
call "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat"
goto python_msvc

:msvc2008_64
call "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars64.bat"
goto python_msvc

:sdk60_32
set PATH="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\lib";%LIB%
goto python_msvc

:sdk60_64
set PATH="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin\x64";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\lib\x64";%LIB%
goto python_msvc

:sdk70_32
set PATH="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\lib";%LIB%
goto python_msvc

:sdk70_64
set PATH="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin\x64";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\lib\x64";%LIB%
goto python_msvc

rem *************
rem *** MinGW ***
rem *************

:mingw
if "%3" == "64" goto error
echo.Setting MinGW Environment
if "%QTDIR%" == "" goto mingw_standalone
if not "%QTDIR%" == "" goto mingw_qt
goto error

:mingw_standalone
if exist "C:\mingw\bin" (
  echo.Using standalone MinGW
  set PATH=C:\mingw\bin;%PATH%
) else (
  echo.MinGW not found
)
goto python_mingw

:mingw_qt
echo.Using MinGW bundled with Qt
set PATH=%QTDIR%\bin;%QTHOME%\mingw\bin;%PATH%
goto python_mingw

rem **************
rem *** Python ***
rem **************

:python_msvc
echo.[build]> "%1\Lib\distutils\distutils.cfg"
echo.compiler=msvc>> "%1\Lib\distutils\distutils.cfg"
goto python

:python_mingw
echo.[build]> "%1\Lib\distutils\distutils.cfg"
echo.compiler=mingw32>> "%1\Lib\distutils\distutils.cfg"
goto python

:python
echo.Setting Python Environment
"%1\python.exe" -c "import sys; print(sys.version)"
set PATH=%1;%1\Scripts;%PATH%
rem PYTHONPATH has another purpose
set PYTHONFOLDER=%1
goto blender

rem ***************
rem *** Blender ***
rem ***************

:blender
echo.Setting Blender Environment
for /F "tokens=2* delims=   " %%A in ('REG QUERY "HKLM\SOFTWARE\BlenderFoundation" /v Install_Dir') do (
  set BLENDERHOME=%%B
)
if "%BLENDERHOME%" == "" (
  echo.Blender not found
  goto endblender
)
echo.Blender home: %BLENDERHOME%
for %%A in (2.57,2.58,2.59,2.60,2.61,2.62,2.63,2.64) do (
  if exist "%BLENDERHOME%\%%A" set BLENDERVERSION=%%A
)
if "%BLENDERVERSION%" == "" (
  echo.Blender version not found
  goto endblender
)
echo.Blender version: %BLENDERVERSION%
if exist "%BLENDERHOME%\%BLENDERVERSION%\scripts\addons" set BLENDERADDONS=%BLENDERHOME%\%BLENDERVERSION%\scripts\addons
if "%BLENDERADDONS%" == "" (
  echo.Blender addons not found
  goto endblender
)
echo.Blender addons: %BLENDERADDONS%
:endblender

rem ************
rem *** NSIS ***
rem ************

:nsis
echo.Setting NSIS Environment
if exist "%ProgramFiles%\NSIS\makensis.exe" set NSISHOME=%ProgramFiles%\NSIS
if exist "%ProgramFiles32%\NSIS\makensis.exe" set NSISHOME=%ProgramFiles32%\NSIS
if "%NSISHOME%" == "" (
  echo.NSIS not found
  goto endnsis
)
echo.NSIS home: %NSISHOME%
set PATH=%NSISHOME%;%PATH%
:endnsis



goto end

:error
echo.Bad command line arguments.
pause
exit




if "%2" == "msvc2008" goto msvc2008
if "%2" == "mingw" goto mingw
rem sdk60 and sdk70 are no longer documented but could still be useful
if "%2" == "sdk60" goto sdk60
if "%2" == "sdk70" goto sdk70
goto error

:msvc2008
if "%3" == "32" goto msvc2008_32
if "%3" == "64" goto msvc2008_64
goto error

:sdk60
if "%3" == "32" goto sdk60_32
if "%3" == "64" goto sdk60_64
goto error

:sdk70
if "%3" == "32" goto sdk70_32
if "%3" == "64" goto sdk70_64
goto error


:end
pause




