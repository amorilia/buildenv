@echo off

if "%1" == "-help" (   
    goto helpcommands 
)

if "%1" == "" (
goto displayparams 
) else ( 
rem ********************
rem ** Optional Flags **
rem ********************

set arch_type=empty
set git_path=empty
set python_path=empty
set qt_path=empty
set nsis_path=empty
echo. 
goto checkparams
)

:displayparams
    echo.buildenv.bat 
    echo.   Flags: -workfolder 
    echo.   Optional: -compiler -gitpath -pythonpath -qt -nsis
    echo.   Types -help [parameter] for additional help.
    echo.
    goto end

:helpcommands

if "%2" == "-arch" (
echo.
echo.   Sets the architecture of your computer. Either 32 or 64.
echo.   Used to configure which compilers to use
echo.
)

if "%2" == "-workfolder" ( 
echo.
echo.   Start folder, relative to %HOMEPATH%
echo.   Which folder to use as the root directory. e.g workspace
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
echo.   BuildEnv supports msvc2008, mingw-32
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

if "%2" == "" (
echo. 
echo.   Type a flag eg. -workfolder
echo.
goto end   
)

:checkparams
rem grab the first variable

set SWITCHPARSE=%1
if "%SWITCHPARSE%" == "" ( goto settings)

for /F "tokens=1,2 delims=@ " %%a IN ("%SWITCHPARSE%") DO SET SWITCH=%%a&set VALUE=%%b

if "%SWITCH%" == "-arch" ( 
set arch_type=%VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-workfolder" ( 
set work_folder=%VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-pythonpath" ( 
set python_path=%VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-gitpath" ( 
set git_path=%VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-compiler" ( 
set compiler_type=%VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-qtpath" ( 
set qt_path=%VALUE%
SHIFT
goto checkparams
)

if "%SWITCH%" == "-nsispath" ( 
set nsis_path=%VALUE%
SHIFT
goto checkparams
)

:settings
rem ********************
rem *** Architecture ***
rem ********************

echo.Script Running:
echo.
echo.Setting Program Files

rem get the 32-bit program files folder
set ProgramFiles32=%ProgramFiles(x86)%
if "%ProgramFiles32%" == "" (
    if "%arch_type%" == "empty" set arch_type=32
    set ProgramFiles32=%ProgramFiles%
) else (
if "%arch_type%" == "empty" set arch_type=64
)
echo.Program Folder: %ProgramFiles32%
:endsettings

rem ***************
rem *** Blender ***
rem ***************

:blender
echo.
echo.Setting Blender Environment
FOR /F "tokens=2*" %%A IN ('REG.EXE QUERY "HKLM\SOFTWARE\BlenderFoundation" /v Install_Dir') do (
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
echo.
echo.Setting NSIS Environment
if "%nsis_path%" == "empty" (
if exist "%ProgramFiles32%\NSIS\makensis.exe" set NSISHOME=%ProgramFiles32%\NSIS
)else (
set NSISHOME=%nsis_path%
)

if "%NSISHOME%" == "" (
  echo.NSIS not found
  goto endnsis
)
echo.NSIS home: %NSISHOME%
set PATH=%NSISHOME%;%PATH%
:endnsis

rem ***********
rem *** Git ***
rem ***********

:git
echo.
echo.Setting Git Environment
if exist "%ProgramFiles%\Git\bin\git.exe" set GITHOME=%ProgramFiles%\Git
if exist "%ProgramFiles32%\Git\bin\git.exe" set GITHOME=%ProgramFiles32%\Git
if "%GITHOME%" == "" (
  echo.Git not found
  goto endgit
)
echo.Git home: %GITHOME%
set PATH=%GITHOME%\bin;%PATH%
:endgit

rem **********
rem *** Qt ***
rem **********


:python
echo.
echo.Setting Python Environment
if "%python_path%" == "empty" ( 
set python_path=C:\Python32
)
"%python_path%\python.exe" -c "import sys; print(sys.version)"
set PATH=%python_path%;%python_path%\Scripts;%PATH%
rem PYTHONPATH has another purpose
set PYTHONFOLDER=%python_path%

:qt
echo.
echo.Setting Qt Environment
rem registry?
if "%qt_path%" == "empty" (
if exist "C:\QtSDK" (
set QTHOME=C:\QtSDK
)
) else (
set QTHOME=%qt_path%
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
if exist "%QTHOME%\Desktop\Qt\%QTVERSION%\mingw" (
set QTDIR=%QTHOME%\Desktop\Qt\%QTVERSION%\mingw
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

rem ***************
rem ** Compilers **
rem ***************


:compilers
if "arch_type" == "empty" set arch_type=32
if "%2" == "msvc2008" goto msvc2008
if "%2" == "mingw" goto mingw
if "%2" == "sdk60" goto sdk60
if "%2" == "sdk70" goto sdk70

:msvc2008
echo.
echo.Setting MSVC:2008
rem bat-file will auto-set the path stuff for us. 

if "%arch_type%" == "64" (
if exist "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars64.bat" (
call "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars64.bat" 
goto python_msvc )
)

if "%arch_type%" == "32" (
if exist "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat" (
call "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat" 
goto python_msvc ) 
)

echo.MSVC:2008 not found
:endmsvc

:sdk60
echo.
echo.Setting Microsoft SDK:60 

if "%arch_type%" == "32" (
if exist "C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin" (
set PATH="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin";%PATH% 
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\lib";%LIB% 
goto python_msvc )
)

if "%arch_type%" == "64" (
if exist "C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin\x64" (
set PATH="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin\x64";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\lib\x64";%LIB% 
goto python_msvc )
)

echo.Microsoft SDK:60 not found
:endsdk60

:sdk70
echo.
echo.Setting Microsoft SDK:70
if "%arch_type%" == "32" ( 
if exist "C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin" (
set PATH="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\lib";%LIB%
goto python_msvc )
) 

if "%arch_type%" == "64" (
if exist "C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin\x64" ( 
set PATH="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin\x64";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\lib\x64";%LIB%
goto python_msvc )
)
:endsdk70

:mingw
echo.
echo.Setting MinGW Environment
if "%QTDIR%" == "" goto mingw_standalone
if not "%QTDIR%" == "" goto mingw_qt

:mingw_standalone
if exist "C:\mingw\bin" (
  echo.Using standalone MinGW
  set PATH=C:\mingw\bin;%PATH%
  goto python_mingw
) else (
  echo.MinGW not found
  goto end
)

:mingw_qt
echo.Using MinGW bundled with Qt
set PATH=%QTDIR%\bin;%QTHOME%\mingw\bin;%PATH%
goto python_mingw

:python_msvc
echo.
echo.Setting python compiler.
echo.[build]> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
echo.compiler=msvc>> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
goto end

:python_mingw
echo.
echo.Setting python compiler.
echo.[build]> "%python_path%\Lib\distutils\distutils.cfg"
echo.compiler=mingw32>> "%python_path%\Lib\distutils\distutils.cfg"
goto end

:end
echo.Changing directory: %work_folder%
echo.
if not "%work_folder" == "empty" (
%HOMEDRIVE%
cd %HOMEPATH%\%work_folder%
)
pause