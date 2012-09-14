Buildenv is batch script used to set up a build environment on Windows.

Installation
============

Download and unzip the source .zip file into any location of your choice.

Right-click on the ``buildenv.bat`` file, and select **Send to > Desktop (create shortcut)**.

Now right-click this newly created shortcut, select **Properties**, and change **Target** into
for instance::

  %comspec% /k "<path>\buildenv.bat" -compiler=msvc2008 -arch@32 -pythonpath@C:\Python32 -workfolder@workspace

With the above,
you could for instance compile Python 3.2 extension modules targetted at 32 bit.

Notes
=====

* buildenv.bat has a number of flags which can be set
  using the format ``-flag@value``,
  or ``"-flag@value"`` if the value contains spaces.
* Many of the values have defaults, however,
  you should set at least ``-arch`` and ``-compiler``.
* For Python development:

  - You should also set ``-pythonpath``.
  - For Python development, your choice of compiler
    must match the compiler used to compile your version of Python.
    For Python 2.6, 2.7, 3.0, 3.1, and 3.2, this is ``msvc2008``.
    For older versions of Python, you can try ``mingw``,
    although your mileage may vary.
  - ``-arch`` must match the architecture of the Python at ``-pythonpath``.

* Other applications, such as Qt, msysGit, and NSIS, are automatically detected
  if installed at their default locations.
  Set the corresponding flags, if detection fails, or if detection picks the wrong
  version for you (for instance, if you have multiple versions of Qt installed,
  but you want buildenv.bat to pick a particular one).
* Running buildenv.bat without arguments will display all available flags.
* The ``-workfolder`` flag is your working folder,
  either relative to ``C:\Users\<username>``, or absolute.
  If you use eclipse, you may want to type ``-workfolder@workspace``.

Features
========

The batch script does the following:

* Update *PATH* for the specified version of Python.
* Update *PATH*, *INCLUDE*, and *LIB* for the specified compiler.
* Update Python's ``distutils.cfg`` to use the specified compiler.
* Set *PYTHONFOLDER* to the folder where the specified version of
  Python resides.
* Set *BLENDERHOME*, *BLENDERVERSION*, *BLENDERADDONS*,
  and *APPDATABLENDERADDONS* according
  to whatever version of Blender is found via the registry.
* Set *QTHOME*, *QTVERSION*, and *QTDIR* according to whatever version
  of the Qt SDK is found, and update *PATH*.
* Set *NSISHOME* according to whatever version of NSIS is found, and
  update *PATH*.
* Set *GITHOME* to the msysGit folder, and update *PATH*.
* Set *CMAKEHOME* to the CMake folder, and update *PATH*.

Supported Compilers
-------------------

* `mingw <http://www.mingw.org/>`_ (32-bit only)

* `Visual C++ 2008 Express <http://go.microsoft.com/?linkid=7729279>`_
  (32-bit and 64-bit).
  For the 64-bit compiler, you also need the
  `Microsoft Windows SDK for Windows 7 and .NET Framework 3.5 SP1
  <http://www.microsoft.com/downloads/details.aspx?FamilyID=c17ba869-9671-4330-a63e-1fd44e0e2505>`_

Supported versions of Blender
-----------------------------

* 2.57, 2.58, 2.59, 2.60, 2.61, 2.62.

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
