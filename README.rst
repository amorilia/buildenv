buildenv is a simple batch script for setting up a build environment on Windows.

Installation
------------

Download and unzip the source .zip file into any location of your
choice.

Right-click on the ``buildenv.bat`` file,
and select **Send to > Desktop (create shortcut)**.

Now right-click this newly created shortcut,
and change **Target** into::

  %comspec% /k <path>\buildenv.bat C:\Python32 msvc2008 64 Documents

A few notes:

* Change the Python path to whatever version of Python you have
  installed.

* For Python development, your choice of compiler must match the
  compiler used to compile your version of Python.  For Python 2.6,
  2.7, 3.0, 3.1, and 3.2, this is ``msvc2008``. For older versions of
  Python, you can try ``mingw``, although your mileage may vary.

* On 32 bit systems, type ``32`` instead of ``64``.

* The final argument is your working folder, relative to
  ``C:\Users\<username>``. If you use eclipse, you may want to type
  ``workspace`` instead of ``Documents``.

Features
--------

The batch script does the following:

* Update *PATH* for the specified version of Python.
* Update *PATH*, *INCLUDE*, and *LIB* for the specified compiler.
* Update Python's ``distutils.cfg`` to use the specified compiler.
* Set *BLENDERHOME*, *BLENDERVERSION*, and *BLENDERADDONS* according
  to whatever version of Blender is found via the registry.

Supported Compilers
~~~~~~~~~~~~~~~~~~~

* `mingw <http://www.mingw.org/>`_ (32-bit only)
* `Visual C++ 2008 Express <http://go.microsoft.com/?linkid=7729279>`_
  (32-bit and 64-bit)

Supported versions of Blender
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* 2.57, 2.58, and 2.59.

Supported versions of Python
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Any. However, for compiling extension modules, only 2.6 and higher
  are well supported.
