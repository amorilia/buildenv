Buildenv is batch script used to set up build environments on Windows.

Installation
============

* Download and unzip the source .zip file into any location of your choice.

Usage
=====

* Buildenv is used to setup a console window
  with pre-defined environmental setting.

* These setting are for the console session only,
  to avoid PATH pollution and avoids manually setting on each use.

* The setting are read from a .ini file created by the user in the ./ini folder.

* Running create-shortcut.bat creates separate buildenv shortcuts
  on your desktop.

* Running the shortcut will call buildenv, passing the specific .ini setting,
  with a resulting console window.

INI Settings
============

* Add the relvant options, based on the following,
  to an .ini file placed in the ./ini folder

* The ini file has a number of flags
  which can be set using the format ``flag=value``.

Miscellaneous
-------------

start=FOLDER
  start FOLDER, either relative to %HOMEDRIVE%%HOMEPATH% or absolute 

arch=BITS
  target BITS architecture: 32, or 64

Languages
---------

python=FOLDER
  the base FOLDER of your Python installation; its architecture must match BITS

Applications
------------

blender=FOLDER
  the base FOLDER of your Blender installation;

Utilities
---------

git=FOLDER
  the base FOLDER of your msysGit installation;
  use this flag when automatic detection fails

nsis=FOLDER
  the base FOLDER of your NSIS installation;
  use this flag when automatic detection fails

cmake=FOLDER
  the base FOLDER of your CMake installation;

Compilers
---------

compiler=COMPILER
  COMPILER to set up: msvc2008, msvc2010, mingw, sdk60, sdk70, or sdk71

msvc2008=FOLDER
  the base FOLDER of your MSVC 2008 installation;
  implies compiler=msvc2008 when set

msvc2010=FOLDER
  the base FOLDER of your MSVC 2010 installation;
  implies compiler=msvc2010 when set

Libraries
---------

swig=FOLDER
  the base FOLDER of your SWIG installation

boostinc=FOLDER
  the boost include FOLDER
  
boostlib=FOLDER
  the boost library FOLDER; must match compiler and architecture

qt=FOLDER
  the base FOLDER of your Qt SDK installation;
  use this flag when automatic detection fails


Notes
=====

* Running buildenv.bat from command-line without arguments
  will display the auto-detected values.

* Many of the values have defaults,
  however you should set at least ``arch`` and ``compiler``.
  
* For Python development:

  - You should also set ``python``.

  - For Python development, your choice of compiler
    must match the compiler used to compile your version of Python.
    For Python 2.6, 2.7, 3.0, 3.1, and 3.2, this is ``msvc2008``.
    For older versions of Python, you can try ``mingw``,
    although your mileage may vary.

  - ``arch`` must match the architecture of the Python at ``python``.

* Other applications, such as Qt, msysGit, and NSIS, are automatically detected
  if installed at their default locations.
  Set the corresponding flags, if detection fails, or if detection picks the wrong
  version for you (for instance, if you have multiple versions of Qt installed,
  but you want buildenv.bat to pick a particular one).
  
* Running buildenv.bat without arguments will display all available flags.

* The ``start`` flag is your working folder,
  either relative to ``C:\Users\<username>``, or absolute.
  If you use eclipse, you may want to type ``start=workspace``.

Features
========

The batch script does the following:

* Updates *PATH* for the specified version of Python.
* Updates *PATH*, *INCLUDE*, and *LIB* for the specified compiler.
* Updates Python's ``distutils.cfg`` to use the specified compiler.
* Sets *PYTHONFOLDER* to the folder where the specified version of Python resides.
* Sets *BLENDERHOME*, *BLENDERVERSION*, *BLENDERADDONS*,
  and *APPDATABLENDERADDONS* according
  to whatever version of Blender is found via the registry.
* Sets *QTHOME*, *QTVERSION*, and *QTDIR* according to whatever version
  of the Qt SDK is found, and update *PATH*.
* Sets *NSISHOME* according to whatever version of NSIS is found, and
  update *PATH*.
* Sets *GITHOME* to the msysGit folder, and update *PATH*.
* Sets *CMAKEHOME* to the CMake folder, and update *PATH*.
* Sets *SWIGHOME* to the SWIG folder, and update *PATH*.
* Sets *BOOST_INCLUDEDIR* and *BOOST_LIBRARYDIR* according to their corresponding flags.

Supported Compilers
-------------------

``compiler=mingw``
  `mingw <http://www.mingw.org/>`_ (32-bit only)

``compiler=msvc2008``
  `Visual C++ 2008 Express <http://go.microsoft.com/?linkid=7729279>`_
  (32-bit and 64-bit).
  For the 64-bit compiler, you also need the Windows SDK 7.0.

``compiler=sdk70``
  `Microsoft Windows SDK for Windows 7 and .NET Framework 3.5 SP1
  <http://www.microsoft.com/en-us/download/details.aspx?id=3138>`_
  (32-bit and 64-bit).
  This is SDK is also known as *Windows SDK 7.0*.
  The compilers are identical to the ones that come with Visual C++ 2008.

``compiler=msvc2010``
  `Visual C++ 2010 Express <http://go.microsoft.com/?linkid=9709949>`_
  (32-bit only).
  You may also want to install
  `Microsoft Visual Studio 2010 Service Pack 1
  <http://www.microsoft.com/en-gb/download/details.aspx?id=23691>`_.
  If you also plan on installing the Windows SDK 7.1,
  be sure to follow the recommended installation order, documented below.

  The 64-bit target is not supported,
  essentially due to ``vcvars64.bat`` being missing
  even after installing Windows SDK 7.1.
  If you need to target 64-bit with a Visual C++ 2010 compatible
  compiler, use ``compiler=sdk71``.

``compiler=sdk71``
  `Microsoft Windows SDK for Windows 7 and .NET Framework 4
  <http://www.microsoft.com/en-gb/download/details.aspx?id=8279>`_
  (32-bit and 64-bit).
  This is SDK is also known as *Windows SDK 7.1*.
  The compilers are identical to the ones that come with Visual C++ 2010.
  You may also need
  `Microsoft Visual C++ 2010 Service Pack 1 Compiler Update for the Windows SDK 7.1
  <http://www.microsoft.com/en-us/download/details.aspx?id=4422>`_
  in case you have Visual C++ 2010 SP1.
  Note the recommended installation order according to Microsoft:

  1. Visual Studio 2010
  2. Windows SDK 7.1
  3. Visual Studio 2010 SP1
  4. Visual C++ 2010 SP1 Compiler Update for the Windows SDK 7.1

Supported versions of Blender
-----------------------------

* 2.62, 2.63, 2.64, 2.65, 2.66, 2.67.
* Will detect the addon location, either local blender folder or users appdata folder.


Supported versions of Python
----------------------------

* Any. However, for compiling extension modules, only 2.6 and higher
  are well supported.

Supported versions of Qt SDK
----------------------------

* Only tested with Qt 4.7.4 with mingw
  (Qt SDK 1.1.4).

Supported versions of NSIS
--------------------------

* Any.

Supported versions of Git
-------------------------

* `msysGit <http://code.google.com/p/msysgit/>`_.

Supported versions of CMake
---------------------------

* Only tested with CMake 2.8.9.

Supported versions of SWIG
--------------------------

* Any.
