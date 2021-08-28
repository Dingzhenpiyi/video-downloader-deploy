@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Update & :Upgrade-portable & :Upgrade-quickstart & :Upgrade-withpip
:: Please make sure that: only call this batch when %cd% is "res\";
::     call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call scripts\CheckUpdate.bat self
:: call scripts\CheckUpdate.bat youget

@echo off
call :CheckUpdate_%~1
goto :eof


rem ================= FUNCTIONS =================


:CheckUpdate_self
set /p localVersion=<scripts\CurrentVersion
del /Q scripts\RemoteVersion >NUL 2>NUL
wget %_WgetOptions_% %_RemoteRes_%/scripts/CurrentVersion -O scripts\RemoteVersion
set /p latestVersion=<scripts\RemoteVersion
if "%localVersion%"=="%latestVersion%" ( set "_isLatestVersion=1" ) else ( set "_isLatestVersion=0" )
goto :eof


:CheckUpdate_youget
for /f "tokens=2 delims='" %%a in ('type "%ygBin%\src\you_get\version.py" ^| find "version"') do ( set "ygCurrentVersion=%%a" )
wget %_WgetOptions_% -np https://github.com/soimort/you-get/releases/latest -O ygLatestRelease.txt && (
        set "ygUpgradeLock=false"
    ) || (
        set "ygUpgradeLock=true"
        echo you-get: %str_upgrade-info-unavailable%
    )
:: The output of 'findstr /n /i "<title>" ygLatestRelease.txt' should be like:
::     31:  <title>Release 0.4.1328 · soimort/you-get · GitHub</title>
for /f "tokens=3 delims= " %%i in ('findstr /n /i "<title>" ygLatestRelease.txt') do ( set "ygLatestVersion=%%i" )
del /Q ygLatestRelease.txt >NUL 2>NUL
if "%ygLatestVersion%"=="" ( set "ygUpgradeLock=true" & set "ygLatestVersion=_UNKNOWN_" )
if "%ygCurrentVersion%"=="%ygLatestVersion%" (
    set "_isYgLatestVersion=1" & set "ygUpgradeLock=true"
) else ( set "_isYgLatestVersion=0" )
goto :eof

:: (python -V) > test.txt              ---> OK
:: (you-get -V) > test.txt             ---> NO output
:: (youtube-dl --version) > test.txt   ---> OK
:: (annie -v) > test.txt               ---> OK

:: When there is even no ygBin, return 0. So that it will directly download the latest version.
:: if NOT exist "%ygBin%\src\you_get\version.py" set "_isYgLatestVersion=0"


:CheckUpdate_youtubedl
for /f "tokens=2 delims='" %%a in ('type "%ydBin%\youtube_dl\version.py" ^| find "version"') do ( set "ydCurrentVersion=%%a" )
wget %_WgetOptions_% -np https://github.com/ytdl-org/youtube-dl/releases/latest -O ydLatestRelease.txt && (
        set "ydUpgradeLock=false"
    ) || (
        set "ydUpgradeLock=true"
        echo youtube-dl: %str_upgrade-info-unavailable%
    )
:: The output of 'findstr /n /i "<title>" ydLatestRelease.txt' should be like:
::     31:  <title>Release youtube-dl 2019.08.02 · ytdl-org/youtube-dl · GitHub</title>
for /f "tokens=4 delims= " %%i in ('findstr /n /i "<title>" ydLatestRelease.txt') do ( set "ydLatestVersion=%%i" )
del /Q ydLatestRelease.txt >NUL 2>NUL
if "%ydLatestVersion%"=="" ( set "ydUpgradeLock=true" & set "ydLatestVersion=_UNKNOWN_" )
if "%ydCurrentVersion%"=="%ydLatestVersion%" (
    set "_isYdLatestVersion=1" & set "ydUpgradeLock=true"
) else ( set "_isYdLatestVersion=0" )
goto :eof


:CheckUpdate_annie
for /f "usebackq tokens=3 delims=, " %%a in (`"%anBin%\annie.exe" -v`) do ( set "anCurrentVersion=%%a" )
set "anCurrentVersion=%anCurrentVersion:v=%"
wget %_WgetOptions_% -np https://github.com/iawia002/annie/releases/latest -O anLatestRelease.txt && (
        set "anUpgradeLock=false"
    ) || (
        set "anUpgradeLock=true"
        echo annie: %str_upgrade-info-unavailable%
    )
:: The output of 'findstr /n /i "<title>" anLatestRelease.txt' should be like:
::     31:  <title>Release 0.9.4 · iawia002/annie · GitHub</title>
::  or 78:  <title>Release v0.11.0 · iawia002/annie</title>
for /f "tokens=3 delims= " %%i in ('findstr /n /i "<title>" anLatestRelease.txt') do ( set "anLatestVersion=%%i" )
set "anLatestVersion_Tag=%anLatestVersion%"
set "anLatestVersion=%anLatestVersion:v=%"
del /Q anLatestRelease.txt >NUL 2>NUL
if "%anLatestVersion%"=="" ( set "anUpgradeLock=true" & set "anLatestVersion=_UNKNOWN_" )
if "%anCurrentVersion%"=="%anLatestVersion%" (
    set "_isAnLatestVersion=1" & set "anUpgradeLock=true"
) else ( set "_isAnLatestVersion=0" )
goto :eof


rem ================= End of File =================
