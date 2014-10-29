@echo off

goto main

:daemonscriptlogo

echo                   j
echo                iBME            ii
echo               pMM              jMB
echo             tBMMM inZbQbti      dMM
echo            vMQMMMMMMMMMMMMMp    XMMM
echo            tMMMciBBApOBBWBMMBodQBBMMo
echo             MB   iM   WbOQWWBBBBBMMMi
echo             B    QI   BPEWWQBBMMMMMi
echo            vM  OQI  OQBEbWBMMMMMMb
echo           iWMMMBMMCZxzBAEQBMMMMi
echo          cMOQEZbMMiBiBOdbOBBMMb
echo       ZB jMOQpPWBBXABWPEdWBBMMb                Daemonscript v1.0
echo     Fi iZ zMMMQObddbPIUPQBMMMM
echo     YEziE   iEMBdPZEOBBQBMMMo       Apache web server and mysql data base 
echo  YBt  MMMi ii  nBMBBBBBBBMZ         daemons control script for Win-NT. Check
echo   iPbov iMMBMZ   QBBBWOOBM          apache, mysql and php settings in a head
echo          BWBMMPitQEPpZAzdMB         of script before run it. Press enter for
echo          QMMMMMMBEbEWWBOdMMv        help message about some script commands
echo           iPbMMBZUUIZWBBBBMM        examples.
echo               MOpPdEBBBBBMMM
echo               PMBWWBMMMMBMM
echo               BQOBBMMBMMMBMi
echo               bBAUZEOQWBMMMM
echo                zBEddWBWBMMMMW
echo                SBQBMBBMBBMBMMMMj
echo            iiiCQPoOBnIQOpQp oMMMMMBzi
echo     vvii iMMBOUzdQEEOOOQEBMi  iXWMMMMMMMMEc
echo    itviiYQc     iPBQWBBMMMMM          iJBMMMBi
echo        icCiiijdMMMMMMMMMWAYi           i   zMMi
echo              iicjviii               vOMMJpBMMW
echo                                 sMMMMMMMMMMMn
echo.

goto :eof

:main

:: Change your settings here

setlocal enabledelayedexpansion

set serverroot=c:\server

set servernameorip=127.0.0.1

set apacheconfig=httpd.conf

set apachedaemonname=httpdnt

set apacheversionroot=%serverroot%\apache\

set mysqlconfig=my.ini

set mysqldaemonname=mysqldnt

set mysqlversionroot=%serverroot%\mysql\

set phpversioroot=%serverroot%\php\

set mysqllogs=%serverroot%\mysql\log\all.sql

echo.

call :daemonscriptlogo

call :infomessage

echo.

:loop

set choice=null

set called=null

set /p choice=Daemons ^<s^>tart/^<r^>estart/^<c^>lose, enter-all/^<a^>pache/^<m^>ysql:

echo.

if "%choice%" == "s" call :apachestart & call :mysqlstart

if "%choice%" == "sa" call :apachestart

if "%choice%" == "sm" call :mysqlstart

if "%choice%" == "as" call :apachestart

if "%choice%" == "ms" call :mysqlstart

if "%choice%" == "r" call :restartdaemon %apachedaemonname% & call :restartdaemon %mysqldaemonname%

if "%choice%" == "ra" call :restartdaemon %apachedaemonname%

if "%choice%" == "raf" call :restartapachefast

if "%choice%" == "rm" call :restartdaemon %mysqldaemonname%

if "%choice%" == "ar" call :restartdaemon %apachedaemonname%

if "%choice%" == "mr" call :restartdaemon %mysqldaemonname%

if "%choice%" == "c" call :closedaemon %apachedaemonname% & call :closedaemon %mysqldaemonname% & call :cleanlogs

if "%choice%" == "ca" call :closedaemon %apachedaemonname%  & call :cleanlogs

if "%choice%" == "cm" call :closedaemon %mysqldaemonname%  & call :cleanlogs

if "%choice%" == "ac" call :closedaemon %apachedaemonname%  & call :cleanlogs

if "%choice%" == "mc" call :closedaemon %mysqldaemonname%  & call :cleanlogs

if "%choice%" == "l" call :loadeddaemons

if "%choice%" == "le" call :loadedexts

if "%choice%" == "q" goto exit

if "%choice%" == "null" call :helpmessage

if "%called%" == "null" call :contolerrors notid

goto loop

:apachestart

%apacheversionroot%\bin\httpd.exe -f "%apacheversionroot%\conf\%apacheconfig%" -k install -n %apachedaemonname%

net start %apachedaemonname%

if not "%ERRORLEVEL%" == "0" (call :contolerrors apachestart) else (

call :dateandtime Starting time

echo.)

set called=notnull

goto :eof

:mysqlstart

%mysqlversionroot%\bin\mysqld.exe --install %mysqldaemonname% --defaults-file=%mysqlversionroot%\%mysqlconfig%

net start %mysqldaemonname%

if not "%ERRORLEVEL%" == "0" (call :contolerrors mysqlstart) else (

call :dateandtime Starting time

echo.)

set called=notnull

goto :eof

:restartdaemon

net stop %1

if not "%ERRORLEVEL%" == "0" (call :contolerrors restartdaemon %1) else (net start %1)

set called=notnull

goto :eof

:restartapachefast

echo Restarting apache daemon named %apachedaemonname%...

%apacheversionroot%\bin\httpd.exe -k restart -n %apachedaemonname%

echo.

set called=notnull

goto :eof

:closedaemon

net stop %1

if not "%ERRORLEVEL%" == "0" (call :contolerrors closedaemon %1) else (

rem delete daemons from registry HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001(2)(3)\daemons\

sc \\%servernameorip% delete %1

echo.

call :dateandtime Closing time)

set called=notnull

echo.

goto :eof

:loadeddaemons

call :daemonessence %apachedaemonname% null showall

call :daemonessence %apachedaemonname% noheader null

call :daemonessence %mysqldaemonname% noheader null

echo.

set called=notnull

goto :eof

:loadedexts

echo Image name                PID    Modules

echo ========================= ====== =============================================

tasklist /m /nh /fi "IMAGENAME eq httpd.exe"

tasklist /m /nh /fi "IMAGENAME eq mysqld.exe"

echo.

set called=notnull

goto :eof

:helpmessage

echo [Help]
echo.
echo s  - start all daemons   ^| r  - restart all daemons   ^| c  - close all daemons
echo sa - start apache daemon ^| ra - restart apache daemon ^| ca - close apace daemon
echo sm - start mysql daemon  ^| rm - restart mysql daemon  ^| cm - close mysql daemon
echo.
echo enter - this help        ^| raf - restart apache fast  ^| l  - loaded daemons
echo q     - quit from script ^|                            ^| le - loaded extensions
echo.

set called=notnull

goto :eof

:infomessage

echo [Info]

echo.

if not "%OS%"=="Windows_NT" call :contolerrors notwinnt & goto :eof

if not exist %apacheversionroot%\bin\httpd.exe (call :contolerrors filenotfound httpd.exe) else (

%apacheversionroot%\bin\httpd.exe -v 

echo.)

if not exist %mysqlversionroot%\bin\mysqld.exe (call :contolerrors filenotfound mysqld.exe) else (

echo MySql daemon-nt version:

%serverroot:~0,1%%serverroot:~1,1%

cd %mysqlversionroot%\bin\

mysqld.exe -V

echo.)

if not exist %phpversioroot%\php.exe (call :contolerrors filenotfound php.exe) else (

%phpversioroot%\php.exe -v)

goto :eof

:dateandtime

for /f %%T in ('time/t') do set TM=%%T

set datetime=%DATE% %TM%

echo %1 %2 %datetime%

goto :eof

:finddaemonnamepid

for /f "tokens=1-3" %%A in ('tasklist /SVC ^| findstr /i "%1"') do (set daemonpid=%%B)

if "%daemonpid%"=="" set daemonpid=n/a

goto :eof

:daemonessence

set daemonimagename=n/a

set daemonpid=n/a

set daemonport=n/a

set daemonportstatus=n/a

set daemonmem=n/a

call :finddaemonnamepid %1

for /f "tokens=1-9" %%A in ('tasklist ^| findstr /i "%daemonpid%"') do (

set daemonimagename=%%A

set daemonmem=%%E %%F %%G %%H)

for /f "tokens=1-5" %%A in ('netstat -a -o ^| findstr /i "%daemonpid%"') do (

set daemonport=%%B

set daemonportstatus=%%D)

if not "%2" == "noheader" (

echo Daemon name     Image name      PID   Daemon port     Port status   Memory

echo =============== =============== ===== =============== ============= =========

echo. )

if "%3" == "showall" (call :showalldaemons)

set printstring_buffer=

call :printstring 16 %1

call :printstring 16 %daemonimagename%

call :printstring 6 %daemonpid%

call :printstring 16 %daemonport%

call :printstring 14 %daemonportstatus%

call :printstring 9 %daemonmem%

echo %printstring_buffer%

goto :eof

:showalldaemons

set /a countsearch=0

:nextsearch

for /f "tokens=1-9" %%A in ('tasklist ^| findstr /i "%daemonimagename%"') do (set daemonpidtest=%%B)

if "%daemonpidtest%"=="" set daemonpidtest=n/a

if not "daemonpidtest" == "daemonpid" (

set daemonpid=%daemonpidtest%

set daemonport=n/a

set daemonportstatus=n/a

for /f "tokens=1-9" %%A in ('tasklist ^| findstr /i "%daemonpidtest%"') do (set daemonmem=%%E %%F %%G %%H)) 

if not "%countsearch%" == "1" (set /a countsearch += 1 & goto nextsearch)

goto :eof

:printstring

set printstring_string=%2%3%4%5

set printstring_spaces=                                spaces_32

set /a printstring_symbols=1

for /l %%a in (0,1,32) do (if "!printstring_string:~%%a,1!"=="" set /a printstring_symbols=%%a & goto printstring_out)

:printstring_out

set /a printstring_spacesnum=%1-%printstring_symbols%

set printstring_buffer=%printstring_buffer%%printstring_string%!printstring_spaces:~0,%printstring_spacesnum%!

goto :eof

:cleanlogs

echo Clean logs :

call :cleanmysqllogs

goto :eof

:cleanmysqllogs

echo Logs MYSQL deleting ...

del /F /Q %mysqllogs%

goto :eof

:contolerrors

echo [Error]

echo.

if "%1" == "apachestart" call :error_startdaemon %apachedaemonname%

if "%1" == "mysqlstart" call :error_startdaemon %mysqldaemonname%

if "%1" == "restartdaemon" (

@if "%2" == "%apachedaemonname%" call :error_restartdaemon %apachedaemonname%

@if "%2" == "%mysqldaemonname%" call :error_restartdaemon %mysqldaemonname%)

if "%1" == "closedaemon" (

@if "%2" == "%apachedaemonname%" call :error_closedaemon %apachedaemonname%

@if "%2" == "%mysqldaemonname%" call :error_closedaemon %mysqldaemonname%)

if "%1" == "notwinnt" call :error_notwinnt

if "%1" == "filenotfound" call :error_filenotfound %2

if "%1" == "notid" call :error_notid

echo.

goto :eof

:error_startdaemon

echo %1 daemon not started. Set correct script settings before starting daemon.

goto :eof

:error_restartdaemon

echo %1 daemon is not restarted. Start %1 daemon before restarting.

goto :eof

:error_closedaemon

echo %1 daemon is not closed. Start %1 daemon before closing.

goto :eof

:error_notwinnt

echo This is not a Win-NT system.

goto :eof

:error_filenotfound

echo The file %1 is not founded. Check script settings or not use it. 

goto :eof

:error_notid

echo Symbol or combination is not supported. Press enter for help message.

goto :eof

:exit