buildenv is a simple batch script for setting up a build environment on Windows.

Installation
------------

Download and unzip the source .zip file into any location of your
choice.

Right-click on the ``buildenv.bat`` file,
and select **Send to > Desktop (create shortcut)**.

Now right-click this newly created shortcut,
select **Properties**,
and change **Target** into::

  %comspec% /k "<path>\buildenv.bat" -pythonpath@C:\Python32 -workfolder@workspace

A few notes:
* BuildEnv.bat has a number of flags which can be set using the format -flagname@value
* Many of the values have defaults, but setting them manually is advised.
* Running buildenv.bat will display the available flags.
* Running buildenv.bat -help -flag will give more information about that flag

#. Change the Python path to whatever version of Python you have installed.

#. For Python development, your choice of compiler must match the
  compiler used to compile your version of Python.  For Python 2.6,
  2.7, 3.0, 3.1, and 3.2, this is ``msvc2008``. For older versions of
  Python, you can try ``mingw``, although your mileage may vary.

#. On 32 bit systems, type ``32`` instead of ``64``.

#. The -workfolder flag is your working folder, relative to
  ``C:\Users\<username>``. If you use eclipse, you may want to type
  ``workspace``.

Features
--------

The batch script does the following:

* Update *PATH* for the specified version of Python.
* Update *PATH*, *INCLUDE*, and *LIB* for the specified compiler.
* Update Python's ``distutils.cfg`` to use the specified compiler.
* Set *PYTHONFOLDER* to the folder where the specified version of
  Python resides.
* Set *BLENDERHOME*, *BLENDERVERSION*, and *BLENDERADDONS* according
  to whatever version of Blender is found via the registry.
* Set *QTHOME*, *QTVERSION*, and *QTDIR* according to whatever version
  of the Qt SDK is found, and update *PATH*.
* Set *NSISHOME* according to whatever version of NSIS is found, and
  update *PATH*.
* Set *GITHOME* to the msysGit folder, and update *PATH*.

Supported Compilers
~~~~~~~~~~~~~~~~~~~

* `mingw <http://www.mingw.org/>`_ (32-bit only)
* `Visual C++ 2008 Express <http://go.microsoft.com/?linkid=7729279>`_
  (32-bit and 64-bit)

Supported versions of Blender
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* 2.57, 2.58, 2.59, 2.60, 2.61, 2.62.

Supported versions of Python
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Any. However, for compiling extension modules, only 2.6 and higher
  are well supported.

Supported versions of Qt SDK
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Only tested with Qt 4.7.4 with mingw
  (Qt SDK 1.1.4).

Supported versions of NSIS
~~~~~~~~~~~~~~~~~~~~~~~~~~

* Any.

Supported versions of Git
~~~~~~~~~~~~~~~~~~~~~~~~~

* `msysGit <http://code.google.com/p/msysgit/>`_.

