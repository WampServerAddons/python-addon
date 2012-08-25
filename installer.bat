@echo OFF
REM TODO use the call command to set some variables common to both the installer/uninstaller
set PYTHON_VERSION=2.7.2
set PYTHON_SHORT_VERSION=2.7
set PYWIN32_BUILD=216
set APACHE_VERSION=2.2.21
set WAMP_VERSION=2.2a

set ADDON=Python

set BIN=installer\bin
set TMP=installer\temp

set WAMP=c:\wamp
set WAMP_PYTHON=%WAMP%\bin\python
set WAMP_APACHE_MODULES=%WAMP%\bin\apache\apache%APACHE_VERSION%\modules

set PYTHON_FILE=python-%PYTHON_VERSION%.msi
set PYWIN32_FILE=pywin32-%PYWIN32_BUILD%.win32-py%PYTHON_SHORT_VERSION%.exe
set PYTHON_DIR=python%PYTHON_VERSION%
set PYTHON_BIN=%WAMP_PYTHON%\%PYTHON_DIR%

set PYTHON_DOWNLOAD=http://python.org/ftp/python/%PYTHON_VERSION%/%PYTHON_FILE%
set PYWIN32_DOWNLOAD=http://downloads.sourceforge.net/project/pywin32/pywin32/Build%PYWIN32_BUILD%/%PYWIN32_FILE%

set PATH=%PATH%;%BIN%

echo Welcome to the %ADDON% Addon installer for WampServer %WAMP_VERSION%

REM set up the temp directory
IF NOT EXIST %TMP% GOTO MKTMP
echo 	Temp directory found from previous install: DELETING
rd /S /Q %TMP%

:MKTMP
echo 	Setting up the temp directory...
mkdir %TMP%

REM download Python files to temp directory
echo 	Downloading %ADDON% binaries to temp directory...
wget.exe -nd -q -P %TMP% %PYTHON_DOWNLOAD%
wget.exe -nd -q -P %TMP% %PYWIN32_DOWNLOAD%


REM install the binary files in the WampServer install directory
echo 	Installing %ADDON% to the WampServer install directory...
msiexec /i %TMP%\%PYTHON_FILE% /passive TARGETDIR=%PYTHON_BIN%

REM FIXME: a silent install would be great, but not available
REM FIXME: through the pywin32 project releases. Might need to look
REM FIXME: into using a 3rd party distrubution of python or pywin32
echo 	Installing the Windows Extensions for Python...
%TMP%\%PYWIN32_FILE%

REM add the Python bin directory to the PATH so apache can find them
echo 	Setting enviorment variables...
setenv -a PATH %PYTHON_BIN%

REM clean up temp files
echo 	Cleaning up temp files...
rd /S /Q %TMP%

echo %ADDON% is installed successfully. Please restart WampServer.

pause
