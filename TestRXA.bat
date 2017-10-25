@REM *************** Begin Standard Header - Do not add comments here ***************
@REM 
@REM File:     InstallCommon/src/com/ibm/tivoli/ccmdb/install/common/util/debug/TestRXA.bat, ccmdb.install, madt_102
@REM Version:  1.2
@REM Modified: 11/20/08 11:20:09
@REM Build:    1 2
@REM 
@REM Licensed Materials - Property of IBM
@REM 
@REM Restricted Materials of IBM
@REM 
@REM 5724-M19
@REM 
@REM (C) COPYRIGHT IBM CORP. 2006, 2008.  All Rights Reserved.
@REM 
@REM US Government Users Restricted Rights - Use, duplication or
@REM disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
@REM 
@REM **************************** End Standard Header *******************************
@REM ********************************************************************************
@REM 
@REM Defect    Name       Date      Description
@REM -------   ---------  --------  -----------------------------------------------
@REM d223918   wmeranda   09102008  Create.
@REM d228152   wmeranda   11202008  Handle special characters in parameters.
@REM ***************************** End Change History *******************************

@echo off
setlocal

@rem
@rem This script tests RXA connection to specified host.
@rem

if not .%3 equ . goto lookok
echo.
echo This command attempts an RXA connection to a specified host.
echo Here is the command format:
echo.
echo    %0 hostname user password
echo.
echo    Note: Parameters containing special characters (like semicolon or equals) must be enclosed in double quotes.
echo.
exit /b 3
:lookok

echo.

if ".%CTG_CCMDB_HOME%" neq "." call "%CTG_CCMDB_HOME%\bin\setupPSIEnv.bat"
if ".%CTG_CCMDB_HOME%" equ "." call "%~dp0..\bin\setupPSIEnv.bat" 

if exist "%CTG_CCMDB_HOME%\lib\CTGUtils.jar" set CP=%CTG_CCMDB_HOME%\lib\CTGUtils.jar;%CP%

echo.
echo Starting %0 at %DATE% %TIME% ...
echo.
@rem echo "%JAVA_HOME%\bin\java.exe" -cp "%CP%" com.ibm.tivoli.ccmdb.install.common.util.debug.RXADebug connect %1 %2 %3 
"%JAVA_HOME%\bin\java.exe" -cp "%CP%" com.ibm.tivoli.ccmdb.install.common.util.debug.RXADebug connect %~1 %~2 %~3 

goto END

:END
echo Exiting %0 at %DATE% %TIME%
exit /b %ERRORLEVEL%