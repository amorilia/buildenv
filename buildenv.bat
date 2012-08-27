@echo off

rem *************************
rem ** Default Flag Values **
rem *************************

if "%ProgramFiles(x86)%" == "" set arch_type=32
if not "%ProgramFiles(x86)%" == "" set arch_type=64
set qt_path=C:\QtSDK
set python_path=C:\Python32
set compiler_type=msvc2008

if "%1" == "-help" goto displayparams
if "%1" == "--help" goto displayparams
if "%1" == "-h" goto displayparams
if "%1" == "/h" goto displayparams
if "%1" == "/?" goto displayparams
if "%1" == "" goto displayparams 
goto checkparams

:displayparams
echo.Usage: buildenv.bat [options]
echo.
echo.Initialize environment for software development.
echo.
echo.Options:
echo.  -arch@BITS              compiler BITS architecture: 32, or 64 [default: %arch_type%]
echo.  -compiler@COMPILER      COMPILER to set up: msvc2008, or mingw
echo.                          [default: %compiler_type%]
echo.  -pythonpath@FOLDER      the base FOLDER of your Python installation;
echo.                          its architecture must match BITS
echo.                          [default: %python_path%]
echo.  -workfolder@FOLDER      start FOLDER, either relative to %HOMEDRIVE%%HOMEPATH%,
echo.                          or absolute
echo.                          [default: %HOMEDRIVE%%HOMEPATH%]
echo.  -gitpath@FOLDER         the base FOLDER of your Git installation;
echo.                          use this flag when automatic detection fails
echo.  -qtpath@FOLDER          the base FOLDER of your Qt SDK installation;
echo.                          use this flag when automatic detection fails
echo.  -nsispath@FOLDER        the base FOLDER of your NSIS installation;
echo.                          use this flag when automatic detection fails
echo.
goto end

:checkparams
rem grab the first variable

set SWITCHPARSE=%1
if "%SWITCHPARSE%" == "" goto settings

rem implementation note:
rem can't use = as delimiter because anything after = is not passed to buildenv.bat
rem can't use : as delimiter because that's a common symbol in absolute paths
rem so we use @
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

rem Implementation note: do not embed %ProgramFiles32% into brackets
rem because the brackets will be misinterpreted by the command processor
rem http://marsbox.com/blog/howtos/batch-file-programfiles-x86-parenthesis-anomaly/
set ProgramFiles32=%ProgramFiles%
if not "%ProgramFiles(x86)%" == "" set ProgramFiles32=%ProgramFiles(x86)%

echo.Program Folder:
echo.  32-bit: %ProgramFiles32%
echo.  native: %ProgramFiles%

echo.
echo.Setting Architecture

echo.Architecture: %arch_type% bit

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
set APPDATABLENDERADDONS=%APPDATA%\Blender Foundation\Blender\%BLENDERVERSION%\scripts\addons
echo.Global Blender addons: %BLENDERADDONS%
echo.Local Blender addons: %APPDATABLENDERADDONS%
:endblender


rem ************
rem *** NSIS ***
rem ************

:nsis
echo.
echo.Setting NSIS Environment
if exist "%ProgramFiles32%\NSIS\makensis.exe" set NSISHOME=%ProgramFiles32%\NSIS
if exist "%ProgramFiles%\NSIS\makensis.exe" set NSISHOME=%ProgramFiles%\NSIS
if exist "%nsis_path%" set NSISHOME=%nsis_path%
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
if exist "%ProgramFiles32%\Git\bin\git.exe" set GITHOME=%ProgramFiles32%\Git
if exist "%ProgramFiles%\Git\bin\git.exe" set GITHOME=%ProgramFiles%\Git
if exist "%LOCALAPPDATA%\GitHub" (
  for /f "tokens=*" %%A in ('dir %LOCALAPPDATA%\GitHub\PortableGit_* /b') do set GITHOME=%LOCALAPPDATA%\GitHub\%%A
)
if exist "%git_path%" set GITHOME=%git_path%
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
if exist "%python_path%" goto pythonfound
goto pythonnotfound

:pythonfound
set PATH=%python_path%;%python_path%\Scripts;%PATH%
rem PYTHONPATH has another purpose, so use PYTHONFOLDER
rem http://docs.python.org/using/cmdline.html#envvar-PYTHONPATH
set PYTHONFOLDER=%python_path%
python -c "import sys; print(sys.version)"
goto qt
:endpythonfound

:pythonnotfound
echo.Python not found
:endpythonnotfound


:qt
echo.
echo.Setting Qt Environment
rem registry?
if exist "%qt_path%" set QTHOME=%qt_path%
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
echo.
echo.Setting Compiler Environment (%compiler_type%, %arch_type% bit)

if "%compiler_type%x%arch_type%" == "msvc2008x32" goto msvc2008x32
if "%compiler_type%x%arch_type%" == "msvc2008x64" goto msvc2008x64
if "%compiler_type%x%arch_type%" == "mingwx32" goto mingwx32
if "%compiler_type%x%arch_type%" == "mingwx64" goto mingwx64
if "%compiler_type%x%arch_type%" == "sdk60x32" goto sdk60x32
if "%compiler_type%x%arch_type%" == "sdk60x64" goto sdk60x64
if "%compiler_type%x%arch_type%" == "sdk70x32" goto sdk70x32
if "%compiler_type%x%arch_type%" == "sdk70x64" goto sdk70x64

:msvc2008x64
if not exist "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars64.bat" goto compilernotfound
call "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars64.bat"
goto python_msvc

:msvc2008x32
if not exist "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat" goto compilernotfound
call "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat" 
goto python_msvc

:sdk60x32
if not exist "C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin" goto compilernotfound
set PATH="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin";%PATH% 
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\lib";%LIB% 
goto python_msvc

:sdk60x64
if not exist "C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin\x64" goto compilernotfound
set PATH="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\bin\x64";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v6.0\vc\lib\x64";%LIB% 
goto python_msvc

:sdk70x32
if not exist "C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin" goto compilernotfound
set PATH="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\lib";%LIB%
goto python_msvc

:sdk70x64
if not exist "C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin\x64" goto compilernotfound
set PATH="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\bin\x64";%PATH%
set INCLUDE="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\include";%INCLUDE%
set LIB="C:\Program Files\Microsoft SDKs\Windows\v7.0\vc\lib\x64";%LIB%
goto python_msvc

:mingwx32
if "%QTDIR%" == "" goto mingw_standalone
if not "%QTDIR%" == "" goto mingw_qt

:mingwx64
echo.Compiler not supported by buildenv.
goto endcompiler

:mingw_standalone
if exist "C:\mingw\bin" (
  echo.Using standalone MinGW
  set PATH=C:\mingw\bin;%PATH%
  goto python_mingw
) else (
  echo.MinGW not found
  goto endcompiler
)

:mingw_qt
echo.Using MinGW bundled with Qt
set PATH=%QTDIR%\bin;%QTHOME%\mingw\bin;%PATH%
goto python_mingw

:python_msvc
if exist %PYTHONFOLDER% (
echo.Setting python compiler for msvc.
echo.[build]> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
echo.compiler=msvc>> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
)
goto endcompiler


:python_mingw
if exist %PYTHONFOLDER% (
echo.Setting python compiler for mingw32.
echo.[build]> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
echo.compiler=mingw32>> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
)
goto endcompiler

:compilernotfound
echo.Compiler not found

:endcompiler

:workfolder
if "%work_folder%" == "empty" goto endworkfolder
if exist "%HOMEDRIVE%%HOMEPATH%\%work_folder%" set work_folder=%HOMEDRIVE%%HOMEPATH%\%work_folder%
echo.
echo.Changing to directory: %work_folder%
if not exist "%work_folder%" goto workfoldernotfound
cd /d "%work_folder%"
goto endworkfolder

:workfoldernotfound
echo.Directory not found.

:endworkfolder

:end

pause
