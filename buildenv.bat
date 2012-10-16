@echo off

rem *************************
rem ** Default Flag Values **
rem *************************

if "%ProgramFiles(x86)%" == "" set arch_type=32
if not "%ProgramFiles(x86)%" == "" set arch_type=64
set ProgramFiles32=%ProgramFiles%
if not "%ProgramFiles(x86)%" == "" set ProgramFiles32=%ProgramFiles(x86)%

set qt_path=C:\QtSDK

set work_folder=%HOMEDRIVE%%HOMEPATH%

rem make sure we find reg.exe on XP
set PATH=%PATH%;%HOMEDRIVE%\Windows\Systems32

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v 9.0 2^> nul') do set _msvc2008=%%B
if not "%_msvc2008%" == "" set compiler_type=msvc2008

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v 10.0 2^> nul') do set _msvc2010=%%B
if exist "%ProgramFiles32%\Microsoft Visual Studio 10.0\VC" set _msvc2010=%ProgramFiles32%\Microsoft Visual Studio 10.0\VC
if not "%_msvc2010%" == "" set compiler_type=msvc2010

FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\2.5\InstallPath" /ve 2^> nul') do set python_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\2.6\InstallPath" /ve 2^> nul') do set python_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\2.7\InstallPath" /ve 2^> nul') do set python_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\3.0\InstallPath" /ve 2^> nul') do set python_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\3.1\InstallPath" /ve 2^> nul') do set python_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\3.2\InstallPath" /ve 2^> nul') do set python_path=%%B

rem programs

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\BlenderFoundation" /v Install_Dir' 2^> nul') do set BLENDERHOME=%%B

rem utilities

FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1" /v InstallLocation 2^> nul') do set git_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1" /v InstallLocation 2^> nul') do set git_path=%%B

FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Kitware\CMake 2.8.9" /ve 2^> nul') do set _cmake=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Wow6432Node\Kitware\CMake 2.8.9" /ve 2^> nul') do set _cmake=%%B

FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\NSIS" /ve 2^> nul') do set nsis_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Wow6432Node\NSIS" /ve 2^> nul') do set nsis_path=%%B

:helpcheck
if "%1" == "-help" goto displayparams
if "%1" == "--help" goto displayparams
if "%1" == "-h" goto displayparams
if "%1" == "/h" goto displayparams
if "%1" == "/?" goto displayparams
if "%1" == "" goto displayparams
goto checkparams

:displayparams
echo.Usage: buildenv.bat ^<settings.ini^>
echo.
echo.Initialize environment for software development.
echo.
echo.You are not meant to run this script directly from the Windows explorer.
echo.See README.rst for installation instructions.
echo.
echo.Options:

echo.  start=FOLDER            start FOLDER, either relative to
echo.                          %HOMEDRIVE%%HOMEPATH%,
echo.                          or absolute
echo.                          [default: %work_folder%]

echo.  arch=BITS               target BITS architecture: 32, or 64 [default: %arch_type%]

rem Lang
echo.  python=FOLDER           the base FOLDER of your Python installation;
echo.                          its architecture must match BITS
echo.                          [default: %python_path%]

rem Progs
echo.  BLENDERHOME=FOLDER      the base FOLDER of your Blender installation;
echo.                          [default: %BLENDERHOME%]

rem Lang
echo.  python=FOLDER           the base FOLDER of your Python installation;
echo.                          its architecture must match BITS
echo.                          [default: %python_path%]

rem Utilities
echo.  git=FOLDER              the base FOLDER of your msysGit installation;
echo.                          use this flag when automatic detection fails
echo.                          [default: %git_path%]

echo.  nsis=FOLDER             the base FOLDER of your NSIS installation;
echo.                          use this flag when automatic detection fails
echo.                          [default: %nsis_path%]

echo.  cmake=FOLDER            the base FOLDER of your CMake installation;
echo.                          [default: %_cmake%]

rem compilers
echo.  compiler=COMPILER       COMPILER to set up: msvc2008, msvc2010, mingw,
echo.                          sdk60, sdk70, or sdk71
echo.                          [default: %compiler_type%]

echo.  msvc2008=FOLDER         the base FOLDER of your MSVC 2008 installation;
echo.                          implies compiler=msvc2008 when set
echo.                          [default: %_msvc2008%]

echo.  msvc2010=FOLDER         the base FOLDER of your MSVC 2010 installation;
echo.                          implies compiler=msvc2010 when set
echo.                          [default: %_msvc2010%]


echo.  qt=FOLDER               the base FOLDER of your Qt SDK installation;
echo.                          use this flag when automatic detection fails
echo.                          [default: %qt_path%]

rem libs
echo.  swig=FOLDER             the base FOLDER of your SWIG installation

echo.  boostinc=FOLDER         the boost include FOLDER
echo.  boostlib=FOLDER         the boost library FOLDER;
echo.                          must match compiler and architecture
echo.

rem Likely, the script was run from Windows explorer...
pause
goto end

:checkparams
rem Search the INI file line by line
if not exist "%~f1" (
  echo.File "%~f1" not found.
  goto end
)
for /F "tokens=* delims=" %%a in ('type %1') do call :parseparam "%%a"
goto settings

:parseparam
rem Get switch and value, and remove surrounding quotes.
set _line="%~1"
for /F "tokens=1,2 delims==" %%a in ('echo.%_line%') do set SWITCH=%%a^"&set VALUE=^"%%b
set _line=
set SWITCH=%SWITCH:"=%
set VALUE=%VALUE:"=%
echo.Parsing %SWITCH%=%VALUE%
if "%SWITCH%" == "start" set work_folder=%VALUE%

if "%SWITCH%" == "arch" set arch_type=%VALUE%
if "%SWITCH%" == "compiler" set compiler_type=%VALUE%
if "%SWITCH%" == "msvc2008" set _msvc2008=%VALUE%
if "%SWITCH%" == "msvc2008" set compiler_type=msvc2008
if "%SWITCH%" == "msvc2010" set _msvc2010=%VALUE%
if "%SWITCH%" == "msvc2010" set compiler_type=msvc2010

if "%SWITCH%" == "python" set python_path=%VALUE%

if "%SWITCH%" == "blender" set BLENDERHOME=%VALUE%

if "%SWITCH%" == "git" set git_path=%VALUE%
if "%SWITCH%" == "nsis" set nsis_path=%VALUE%
if "%SWITCH%" == "cmake" set _cmake=%VALUE%

if "%SWITCH%" == "qt" set qt_path=%VALUE%
if "%SWITCH%" == "swig" set _swig=%VALUE%
if "%SWITCH%" == "boostinc" set BOOST_INCLUDEDIR=%VALUE%
rem also add boostlib to path so dlls are found
if "%SWITCH%" == "boostlib" set BOOST_LIBRARYDIR=%VALUE%
if "%SWITCH%" == "boostlib" set PATH=%VALUE%;%PATH%
goto eof

:settings
rem ********************
rem *** Architecture ***
rem ********************

echo.
echo.Script Running:
echo.
echo.Setting Program Files

rem Implementation note: do not embed %ProgramFiles32% into brackets
rem because the brackets will be misinterpreted by the command processor
rem http://marsbox.com/blog/howtos/batch-file-programfiles-x86-parenthesis-anomaly/

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

if "%BLENDERHOME%" == "" (
  echo.Blender not found
  goto endblender
)
echo.Blender home: %BLENDERHOME%
for %%A in (2.62,2.63,2.64, 2.65, 2.66,2.67) do (
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
if exist "%nsis_path%\makensis.exe" set NSISHOME=%nsis_path%
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
if exist "%git_path%\bin\git.exe" set GITHOME=%git_path%
if "%GITHOME%" == "" (
  echo.Git not found
  goto endgit
)
echo.Git home: %GITHOME%
set PATH=%GITHOME%\bin;%PATH%
:endgit

rem *************
rem *** CMake ***
rem *************

:cmake
echo.
echo.Setting CMake Environment
if exist "%ProgramFiles32%\CMake 2.8\bin\cmake.exe" set CMAKEHOME=%ProgramFiles32%\CMake 2.8
if exist "%ProgramFiles%\CMake 2.8\cmake.exe" set CMAKEHOME=%ProgramFiles%\CMake 2.8
if exist "%_cmake%\bin\cmake.exe" set CMAKEHOME=%_cmake%
if "%CMAKEHOME%" == "" (
  echo.CMake not found
  goto endcmake
)
echo.CMake home: %CMAKEHOME%
set PATH=%CMAKEHOME%\bin;%PATH%
:endcmake

rem *************
rem *** SWIG ***
rem *************

:swig
echo.
echo.Setting SWIG Environment
if exist "%_swig%\swig.exe" set SWIGHOME=%_swig%
if "%SWIGHOME%" == "" (
  echo.SWIG not found
  goto endswig
)
echo.SWIG home: %SWIGHOME%
set PATH=%SWIGHOME%;%PATH%
:endswig

rem **********
rem *** Qt ***
rem **********


:python
echo.
echo.Setting Python Environment
if exist "%python_path%\python.exe" goto pythonfound
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
rem 1. registry?
rem 2. check for some standard file to ensure qt_path actually contains the Qt SDK?
rem    (similar to NSIS, Git, and Python checks)
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

if "%compiler_type%x%arch_type%" == "msvc2010x32" goto msvc2010x32
if "%compiler_type%x%arch_type%" == "msvc2010x64" goto msvc2010x64
if "%compiler_type%x%arch_type%" == "msvc2008x32" goto msvc2008x32
if "%compiler_type%x%arch_type%" == "msvc2008x64" goto msvc2008x64
if "%compiler_type%x%arch_type%" == "mingwx32" goto mingwx32
if "%compiler_type%x%arch_type%" == "mingwx64" goto mingwx64
if "%compiler_type%x%arch_type%" == "sdk60x32" goto sdk60x32
if "%compiler_type%x%arch_type%" == "sdk60x64" goto sdk60x64
if "%compiler_type%x%arch_type%" == "sdk70x32" goto sdk70x32
if "%compiler_type%x%arch_type%" == "sdk70x64" goto sdk70x64
if "%compiler_type%x%arch_type%" == "sdk71x32" goto sdk71x32
if "%compiler_type%x%arch_type%" == "sdk71x64" goto sdk71x64
goto compilernotfound

:msvc2010x64
if not exist "%_msvc2010%\bin\vcvars64.bat" goto compilernotfound
call "%_msvc2010%\bin\vcvars64.bat"
goto python_msvc

:msvc2010x32
if not exist "%_msvc2010%\bin\vcvars32.bat" goto compilernotfound
call "%_msvc2010%\bin\vcvars32.bat"
goto python_msvc

:msvc2008x64
if not exist "%_msvc2008%\bin\vcvars64.bat" goto compilernotfound
call "%_msvc2008%\bin\vcvars64.bat"
goto python_msvc

:msvc2008x32
if not exist "%_msvc2008%\bin\vcvars32.bat" goto compilernotfound
call "%_msvc2008%\bin\vcvars32.bat"
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
if not exist "C:\Program Files\Microsoft SDKs\Windows\v7.0\bin\SetEnv.cmd" goto compilernotfound
call "C:\Program Files\Microsoft SDKs\Windows\v7.0\bin\SetEnv.cmd" /x86 /release /xp
goto python_msvc

:sdk70x64
if not exist "C:\Program Files\Microsoft SDKs\Windows\v7.0\bin\SetEnv.cmd" goto compilernotfound
call "C:\Program Files\Microsoft SDKs\Windows\v7.0\bin\SetEnv.cmd" /x64 /release /xp
goto python_msvc

:sdk71x32
if not exist "C:\Program Files\Microsoft SDKs\Windows\v7.1\bin\SetEnv.cmd" goto compilernotfound
call "C:\Program Files\Microsoft SDKs\Windows\v7.1\bin\SetEnv.cmd" /x86 /release /xp
goto python_msvc

:sdk71x64
if not exist "C:\Program Files\Microsoft SDKs\Windows\v7.1\bin\SetEnv.cmd" goto compilernotfound
call "C:\Program Files\Microsoft SDKs\Windows\v7.1\bin\SetEnv.cmd" /x64 /release /xp
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

rem **************
rem ** Clean Up **
rem **************

set arch_type=
set compiler_type=
set git_path=
set qt_path=
set python_path=
set nsis_path=
set work_folder=
set _msvc2008=
set _msvc2010=
set _cmake=
set _swig=
set SWITCHPARSE=
set SWITCH=
set VALUE=
set ProgramFiles32=

:eof