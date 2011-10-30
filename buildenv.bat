@echo off

if "%2" == "" (
    echo.buildenv.bat ^<python-path^> ^<compiler^> ^<arch^> ^<folder^>
    echo.
    echo.  ^<python-path^> = path to directory containing python.exe
    echo.  ^<compiler^>    = msvc2008/mingw
    echo.  ^<arch^>        = 32/64
    echo.  ^<folder^>      = start folder, relative to %HOMEPATH%
    goto end
)

rem get the 32-bit program files folder
set ProgramFiles32=%ProgramFiles%
if not "%ProgramFiles(x86)%" == "" set ProgramFiles32=%ProgramFiles(x86)%

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

:msvc2008_32
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

:mingw
if "%3" == "64" goto error
echo.Setting MinGW Environment
set PATH=C:\mingw\bin;%PATH%
goto python_mingw

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

:blender
echo.Setting Blender Environment
for /F "tokens=2* delims=	 " %%A in ('REG QUERY "HKLM\SOFTWARE\BlenderFoundation" /v Install_Dir') do (
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
goto end

:error
echo.Bad command line arguments.
pause
exit

:end
%HOMEDRIVE%
cd %HOMEPATH%\%4
