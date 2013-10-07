@echo on
REM This updates Cygwin zip package (NEL updates only) inside continuous integration platform (CI).
REM It relies on installed Cygwin on the machine where it is called.
REM It also relies on password-less (public key) authentication with server for uploading/downloading packages.

REM Directory where this script is located
set WORKING_DIR=%~dp0

REM SSH address
SSH_ADDRESS=package@nelarchiver

REM File server directory
set REMOTE_DIR=nosync/cygwin

REM Set paths to remote and local base backages
set BASE_REMOTE_PACKAGE=%SSH_ADDRESS%:%REMOTE_DIR%/base.cygwin.distrib.zip
set BASE_LOCAL_PACKAGE=base.zip

REM Use fullpath to bash of local Cygwin installation
CYGWINROOTDIR=C:\cygwin64

REM Set Cygwin distributive directory
set CYGWINDISTRIBDIR=%WORKING_DIRcygwin.distrib

REM Download base package
"%CYGWINROOTDIR%\bin\bash.exe" -c "cd \"$^(/usr/bin/cygpath -u \"$WORKING_DIR\"^)\" ; /usr/bin/scp \"$BASE_REMOTE_PACKAGE\" \"$BASE_LOCAL_PACKAGE\""

REM Unpack base package
"%CYGWINROOTDIR%\bin\bash.exe" -c "cd \"$^(/usr/bin/cygpath -u \"$WORKING_DIR\"^)\" ; /usr/bin/unzip \"$BASE_LOCAL_PACKAGE\""

REM Run offline updates inside the package
"%CYGWINDISTRIBDIR%\repo\installer\update_cygwin_distribution_dir_repo_only.cmd"

REM Pack updates and capture the single-line output with archive name
for /f %%i in ("%CYGWINDISTRIBDIR%\repo\installer\zip_package.cmd") do set UPDATED_LOCAL_PACKAGE=%%i

REM Set remote path for updated package
set UPDATED_REMOTE_PACKAGE=%SSH_ADDRESS%:%REMOTE_DIR%/%UPDATED_PACKAGE%

REM Upload base package automatically and set its permissions to be readable
"%CYGWINROOTDIR%\bin\bash.exe" -c "cd \"$^(/usr/bin/cygpath -u \"$WORKING_DIR\"^)\" ; /usr/bin/scp \"$UPDATED_LOCAL_PACKAGE\" \"$UPDATED_REMOTE_PACKAGE\""




