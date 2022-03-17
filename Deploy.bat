@rem - Encoding:utf-8; Mode:Batch; Language:chs,cht,en; LineEndings:CRLF -
:: Video Downloaders (You-Get, Youtube-dl, Lux) One-Click Deployment Batch (Windows)
:: Author: Lussac (https://blog.lussac.net)
:: Version: 1.8.0
:: Last updated: 2022-03-17
:: >>> Get updated from: https://github.com/LussacZheng/video-downloader-deploy <<<
:: >>> EDIT AT YOUR OWN RISK. <<<
:: >>> Attention! NEVER use `::` to comment in `( )` code block, use `REM` instead!!!
@echo off
setlocal EnableDelayedExpansion
set "_Version_=1.8.0"
set "lastUpdated=2022-03-17"
:: Remote resources url of 'sources.txt', 'wget.exe', '7za.exe', 'scripts/CurrentVersion'
set "_RemoteRes_=https://raw.githubusercontent.com/LussacZheng/video-downloader-deploy/master/res"


rem ================= Preparation =================


REM mode con cols=100 lines=40


:: Set the root directory
set "root=%~dp0"
set "root=%root:~0,-1%"
cd "%root%"


:: Import main settings (%_Language_%, %_Region_%, %_SystemType_%) and translation text.
call res\scripts\Getter.bat Main
:: Import the GlobalProxy setting and apply. Then show more info in Option6.
call res\scripts\Getter.bat GlobalProxy
call res\scripts\Getter.bat InfoOpt6
:: If already deployed, show more info in Option3.
call res\scripts\Getter.bat InfoOpt3
call res\scripts\Getter.bat InfoOpt4


:: Start of Deployment
title %str_title%  -- by Lussac
:: py=python, yg=you-get, yd=youtube-dl, lx=lux, ff=ffmpeg, pip=pip
set "pyBin=%root%\usr\python-embed"
set "ygBin=%root%\usr\you-get"
set "ydBin=%root%\usr\youtube-dl"
set "lxBin=%root%\usr"
set "ffBin=%root%\usr\ffmpeg\bin"


rem ================= Menu =================


:MENU
cd "%root%"
cls
:: Uncomment to check the configuration items that imported from "res\deploy.settings"
REM echo %_Language_% & echo %_Region_% & echo %_SystemType_%
REM echo %http_proxy% & echo %https_proxy%
REM echo %DeployMode%
echo ====================================================
echo ====================================================
echo ======%str_titleExpanded%=======
echo ====================================================
echo ===================  by Lussac  ====================
echo ====================================================
echo ==========  version: %_Version_% (%lastUpdated%)  ===========
echo ====================================================
echo ====================================================
echo.
echo. & echo  [1?] %str_opt1%
        echo    ^|
        echo    ^|-- [11] %str_portable%: you-get + youtube-dl + lux
        echo    ^|        ( %str_opt11% )
        echo    ^|
        echo    ^|-- [12] %str_quickstart%: you-get
        echo    ^|        ( %str_opt12% )
        echo    ^|
        echo    ^|-- [13] %str_withpip%: you-get + youtube-dl + lux
        echo             ( %str_opt13% )
echo. & echo  [2] %str_opt2%
echo. & echo  [3] %str_opt3% %opt3_info%
echo. & echo  [4] %str_opt4% %opt4_info%
echo. & echo  [5] %str_opt5%
echo. & echo  [6] %str_opt6% %opt6_info%
echo. & echo  [7] %str_opt7%
echo. & echo.
echo ====================================================
set choice=0
set /p choice= %str_please-choose%
echo. & echo.
if "%choice%"=="1" goto InitDeploy
if "%choice%"=="11" goto InitDeploy-portable
if "%choice%"=="12" goto InitDeploy-quickstart
if "%choice%"=="13" goto InitDeploy-withpip
if "%choice%"=="2" goto InitDeploy-ffmpeg
if "%choice%"=="3" goto Upgrade
if "%choice%"=="4" goto Reset_dl-bat
if "%choice%"=="5" goto Update
if "%choice%"=="6" goto Setting
if "%choice%"=="7" goto Aliases
echo. & echo %str_please-input-valid-num%
pause > NUL
goto MENU


rem ================= OPTION 1 =================


:InitDeploy
echo. & echo %str_please-choose-from%
goto _ReturnToMenu_


rem ================= OPTION 11 =================


:InitDeploy-portable
set "DeployMode=portable"
call :ExitIfInit
cd res && call scripts\Download.bat main
if NOT exist "%pyBin%" call scripts\DoDeploy.bat Setup python
if NOT exist "%ygBin%" call scripts\DoDeploy.bat Setup youget
if NOT exist "%ydBin%" call scripts\DoDeploy.bat Setup youtubedl
if NOT exist "%lxBin%\lux.exe" call scripts\DoDeploy.bat Setup lux
goto InitLog


rem ================= OPTION 12 =================


:InitDeploy-quickstart
set "DeployMode=quickstart"
call :ExitIfInit
cd res && call scripts\Download.bat main
if NOT exist "%pyBin%" call scripts\DoDeploy.bat Setup python
if NOT exist "%ygBin%" call scripts\DoDeploy.bat Setup youget
goto InitLog


rem ================= OPTION 13 =================


:InitDeploy-withpip
set "DeployMode=withpip"
call :ExitIfInit
cd res
if exist scripts\get-pip.py (
    if NOT exist download md download
    xcopy /Y scripts\get-pip.py download\ > NUL
)
call scripts\Download.bat main
if NOT exist "%pyBin%" call scripts\DoDeploy.bat Setup python
if NOT exist "%lxBin%\lux.exe" call scripts\DoDeploy.bat Setup lux

:edit-python_pth
pushd "%pyBin%"
:: Get the full name of "python3*._pth" -> %py_pth%
for /f "delims=" %%i in ('dir /b python*._pth') do ( set "py_pth=%%i" )
copy %py_pth% %py_pth%.bak > NUL
type NUL > %py_pth%
for /f "delims=" %%i in (%py_pth%.bak) do (
    set "py_pth_str=%%i"
    set py_pth_str=!py_pth_str:#import=import!
    echo !py_pth_str!>>%py_pth%
)
del /Q %py_pth%.bak >NUL 2>NUL

:get-pip
xcopy /Y "%root%\res\download\get-pip.py" "%pyBin%" > NUL
set "PATH=%pyBin%;%pyBin%\Scripts;%PATH%"
if "%_Region_%"=="cn" set "pip_option=--index-url=https://pypi.tuna.tsinghua.edu.cn/simple"
python get-pip.py %pip_option%
pip3 install --upgrade you-get %pip_option%
pip3 install --upgrade youtube-dl %pip_option%
echo You-Get %str_already-deploy% & echo Youtube-dl %str_already-deploy%
del /Q get-pip.py >NUL 2>NUL
popd && goto InitLog


rem ================= OPTION 11-13 InitLog =================


:InitLog
call scripts\Log.bat Init %DeployMode%
cd .. && call :Create_Download-bat 1
goto _ReturnToMenu_


rem ================= OPTION 2 =================


:InitDeploy-ffmpeg
:: Check whether FFmpeg already exists
::   where /Q ffmpeg && echo yes || echo no
::   OR where /Q $path:ffmpeg && echo yes || echo no
set "isExternalFfmpeg=unknown"
where /Q $path:ffmpeg && set "isExternalFfmpeg=true"
if exist "%ffBin%\ffmpeg.exe" ( set "isExternalFfmpeg=false")
if NOT "%isExternalFfmpeg%"=="unknown" goto ffmpeg-exists

:ffmpeg-deploy
:: if NOT exist usr\ md usr
call :AskForInit
set "DeployMode=ffmpeg"
cd res && call scripts\Download.bat main
call scripts\DoDeploy.bat Setup ffmpeg
call scripts\Log.bat Init ffmpeg

echo.
echo ====================================================
echo FFmpeg %str_already-deploy%
echo ====================================================
goto _ReturnToMenu_

:ffmpeg-exists
echo. & echo FFmpeg %str_already-exist%
if "%isExternalFfmpeg%"=="false" ( echo "%ffBin%\ffmpeg.exe" )
where /Q $path:ffmpeg && where $path:ffmpeg
echo.
set opt2_choice=0
echo. & echo %str_deploy-although-exist%
set /p opt2_choice= %str_enter-to-cancel%
echo.
:: If we don't delete this directory, DoDeploy.bat will move
::   the `ffmpeg-*-static\` into `usr\ffmpeg\ffmpeg-*-static\` ,
::   instead of renaming it to `usr\ffmpeg\` .
if /i "%opt2_choice%"=="Y" (
    if exist "%root%\usr\ffmpeg" rd /S /Q "%root%\usr\ffmpeg"
    goto ffmpeg-deploy
) else ( echo %str_cancelled% )
goto _ReturnToMenu_


rem ================= OPTION 3 =================


:Upgrade
call :AskForInit
cd res
call scripts\Download.bat preparation
call scripts\Download.bat dependency
call :StopIfDisconnected
call scripts\Getter.bat DeployMode
set "whetherToLog=false"
:: flag %state_isSourcesUpToDate% is used in
::   :Upgrade_youget & :Upgrade_youtubedl of `res\scripts\DoDeploy.bat`
set "state_isSourcesUpToDate=false"
echo %str_checking-update%...
if "%DeployMode%"=="portable" goto Upgrade-portable
if "%DeployMode%"=="quickstart" goto Upgrade-quickstart
if "%DeployMode%"=="withpip" goto Upgrade-withpip

:upgrade_Manually
set opt3_choice=0
set /p opt3_choice= %str_please-set-DeployMode%
if "%opt3_choice%"=="11" ( set "DeployMode=portable" && goto Upgrade-portable )
if "%opt3_choice%"=="12" ( set "DeployMode=quickstart" && goto Upgrade-quickstart )
if "%opt3_choice%"=="13" ( set "DeployMode=withpip" && goto Upgrade-withpip )
goto upgrade_Manually


:Upgrade-portable
:: Get %_isYgLatestVersion% , %_isYdLatestVersion% , %_isLxLatestVersion%
:: from "scripts\CheckUpdate.bat". 0: false; 1: true.
call scripts\CheckUpdate.bat youget
call scripts\CheckUpdate.bat youtubedl
call scripts\CheckUpdate.bat lux
if "%_isYgLatestVersion%"=="1" if "%_isYdLatestVersion%"=="1" if "%_isLxLatestVersion%"=="1" (
    echo you-get %str_is-latestVersion%: v%ygCurrentVersion%
    echo youtube-dl %str_is-latestVersion%: %ydCurrentVersion%
    echo lux %str_is-latestVersion%: v%lxCurrentVersion%
    goto upgrade_done
)
:: When certain repository is unavailable due to DMCA takedown or network error,
::   and others are all of latest version, skip upgrading it and not to log.
if "%ygUpgradeLock%"=="true" if "%ydUpgradeLock%"=="true" if "%lxUpgradeLock%"=="true" (
    goto upgrade_done
)
set "whetherToLog=true"
if "%_isYgLatestVersion%"=="0" if "%ygUpgradeLock%"=="false" call scripts\DoDeploy.bat Upgrade youget
if "%_isYdLatestVersion%"=="0" if "%ydUpgradeLock%"=="false" call scripts\DoDeploy.bat Upgrade youtubedl
if "%_isLxLatestVersion%"=="0" if "%lxUpgradeLock%"=="false" call scripts\DoDeploy.bat Upgrade lux
goto upgrade_done


:Upgrade-quickstart
call scripts\CheckUpdate.bat youget
if "%_isYgLatestVersion%"=="1" (
    echo you-get %str_is-latestVersion%: v%ygCurrentVersion%
) else if "%ygUpgradeLock%"=="false" (
    set "whetherToLog=true"
    call scripts\DoDeploy.bat Upgrade youget
)
goto upgrade_done


:Upgrade-withpip
call scripts\CheckUpdate.bat lux
if "%_isLxLatestVersion%"=="1" (
    echo lux %str_is-latestVersion%: v%lxCurrentVersion%
) else if "%lxUpgradeLock%"=="false" (
    set "whetherToLog=true"
    call scripts\DoDeploy.bat Upgrade lux
)

:: Re-create a pip3.cmd in case of the whole folder had been moved.
pushd "%root%\usr"
set "PATH=%root%\usr\command;%pyBin%;%pyBin%\Scripts;%PATH%"
if NOT exist command\ md command
cd command
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\pip3.exe" %%*> pip3.cmd
:: OR  echo @python ..\python-embed\Scripts\pip3.exe %%*> pip3.cmd
if "%_Region_%"=="cn" set "pip_option=--index-url=https://pypi.tuna.tsinghua.edu.cn/simple"
echo pip3 install --upgrade you-get %pip_option%> upgrade_you-get.bat
echo pip3 install --upgrade youtube-dl %pip_option%> upgrade_youtube-dl.bat
:: Directly use "pip3 install --upgrade you-get" here will crash for some unknown reason.
:: So write the command into a bat and then call it.
call upgrade_you-get.bat && call upgrade_youtube-dl.bat
echo You-Get %str_already-upgrade% & echo Youtube-dl %str_already-upgrade%
popd && goto upgrade_done


:upgrade_done
if "%whetherToLog%"=="true" call scripts\Log.bat Upgrade %DeployMode%
echo. & echo. & echo %str_upgrade-ok%
goto _ReturnToMenu_


rem ================= OPTION 4 =================


:Reset_dl-bat
call :AskForInit
cd res && call scripts\Getter.bat DeployMode
if NOT "%DeployMode%"=="unknown" goto create_dl-bat

:reset_dl-bat_Manually
set opt4_choice=0
set /p opt4_choice= %str_please-set-DeployMode%
if "%opt4_choice%"=="11" ( set "DeployMode=portable" && goto create_dl-bat )
if "%opt4_choice%"=="12" ( set "DeployMode=quickstart" && goto create_dl-bat )
if "%opt4_choice%"=="13" ( set "DeployMode=withpip" && goto create_dl-bat )
goto reset_dl-bat_Manually

:create_dl-bat
cd .. && call :Create_Download-bat 0
goto _ReturnToMenu_


rem ================= OPTION 5 =================


:Update
cd res && call scripts\Download.bat wget
echo %str_checking-update%...
:: Get %_isLatestVersion% from "scripts\CheckUpdate.bat". 0: false; 1: true.
call scripts\CheckUpdate.bat self
if "%_isLatestVersion%"=="1" (
    echo %str_bat-is-latest%
    echo %str_open-webpage1%...
) else (
    echo %str_bat-can-update-to% %latestVersion%
    echo %str_open-webpage2%...
)
pause > NUL
start https://github.com/LussacZheng/video-downloader-deploy
goto _ReturnToMenu_


rem ================= OPTION 6 =================


:Setting
cls
echo ====================================================
echo ===============%str_opt6-Expanded%===============
echo ====================================================
echo.
echo. & echo  [0] %str_opt6_opt0%
echo. & echo  [1] %str_opt6_opt1%
echo. & echo  [2] %str_opt6_opt2%
echo. & echo  [3] %str_opt6_opt3%
echo. & echo  [4] %str_opt6_opt4%
echo. & echo  [5] %str_opt6_opt5%
echo. & echo  [6] %str_opt6_opt6%
echo. & echo  [7] %str_opt6_opt7%
echo. & echo  [8] %str_opt6_opt8%
if NOT "%DeployMode%"=="withpip" ( echo. & echo  [9] %str_opt6_opt9% )
echo. & echo  [99] %str_opt6_opt99%
echo. & echo.
echo ====================================================
set opt6_choice=-1
set /p opt6_choice= %str_please-choose%
echo. & echo.
if "%opt6_choice%"=="0" goto MENU
if "%opt6_choice%"=="99" goto setting_Reset
if "%opt6_choice%"=="1" goto setting_Language
if "%opt6_choice%"=="11" ( call res\scripts\Config.bat Language en && goto _PleaseRerun_ )
if "%opt6_choice%"=="12" ( call res\scripts\Config.bat Language zh && goto _PleaseRerun_ )
if "%opt6_choice%"=="13" ( call res\scripts\Config.bat Language cht && goto _PleaseRerun_ )
if "%opt6_choice%"=="2" goto setting_Region
if "%opt6_choice%"=="21" ( call res\scripts\Config.bat Region origin && goto _PleaseRerun_ )
if "%opt6_choice%"=="22" ( call res\scripts\Config.bat Region cn && goto _PleaseRerun_ )
if "%opt6_choice%"=="3" goto setting_GlobalProxy
if "%opt6_choice%"=="4" goto setting_ProxyHint
if "%opt6_choice%"=="5" goto setting_FFmpeg
if "%opt6_choice%"=="6" goto setting_Wget
if "%opt6_choice%"=="7" goto setting_SystemType
if "%opt6_choice%"=="8" goto setting_NetTest
if "%opt6_choice%"=="9" goto setting_UpgradeOnlyViaGitHub
echo %str_please-input-valid-num%
goto _ReturnToSetting_


:setting_Reset
echo. & echo %str_reset-settings_1% & echo %str_reset-settings_2%
set opt6_opt99_choice=0
echo. & echo %str_reset-settings_3%
set /p opt6_opt99_choice= %str_enter-to-cancel%
echo.
if /i "%opt6_opt99_choice%"=="Y" (
    del /Q res\deploy.settings >NUL 2>NUL
    echo %str_reset-settings-ok%
) else ( echo %str_cancelled% )
goto _ReturnToSetting_

:setting_Language
echo %str_please-select-language%
goto _ReturnToSetting_

:setting_Region
echo %str_current-region% %_Region_%
echo %str_please-select-region%
goto _ReturnToSetting_

:setting_GlobalProxy
call res\scripts\Getter.bat GlobalProxy
if "%state_globalProxy%"=="enable" (
    echo %str_globalProxy-enabled%
) else ( echo %str_globalProxy-disabled% )
echo. & echo.
echo %str_current-globalProxy%
echo     HTTP_PROXY  = %_proxyHost%:%_httpPort%
echo     HTTPS_PROXY = %_proxyHost%:%_httpsPort%
set opt6_opt3_choice=0
echo. & echo %str_please-set-globalProxy_1%
echo %str_please-set-globalProxy_2%
echo %str_please-set-globalProxy_3%
set /p opt6_opt3_choice= %str_enter-to-cancel%
echo.
setlocal EnableDelayedExpansion
if /i "%opt6_opt3_choice%"=="T" (
    call res\scripts\Config.bat GlobalProxy
) else if /i "%opt6_opt3_choice%"=="Y" (
    call res\scripts\Config.bat ProxyHost http://127.0.0.1
    call res\scripts\Config.bat HttpPort 1080
    call res\scripts\Config.bat HttpsPort 1080
    echo %str_reset-globalProxy-ok%
    call res\scripts\Config.bat GlobalProxy enable
) else if /i "%opt6_opt3_choice%"=="N" (
    set /p opt6_opt3_proxyHost= %str_please-set-proxyHost%
    set /p opt6_opt3_httpPort= %str_please-set-httpPort%
    set /p opt6_opt3_httpsPort= %str_please-set-httpsPort%
    if "!opt6_opt3_proxyHost!"=="" ( set "opt6_opt3_proxyHost=http://127.0.0.1" )
    if "!opt6_opt3_httpPort!"=="" ( set "opt6_opt3_httpPort=1080" )
    if "!opt6_opt3_httpsPort!"=="" ( set "opt6_opt3_httpsPort=1080" )
    call res\scripts\Config.bat ProxyHost !opt6_opt3_proxyHost!
    call res\scripts\Config.bat HttpPort !opt6_opt3_httpPort!
    call res\scripts\Config.bat HttpsPort !opt6_opt3_httpsPort!
    echo.
    call res\scripts\Config.bat GlobalProxy enable
    echo %str_set-globalProxy-ok%
    echo %str_please-confirm-changes%
) else (
    echo %str_cancelled%
    goto _ReturnToSetting_
)
endlocal
echo. & echo %str_please-rerun%
echo %str_please-rerun-dlbat%
goto _PleaseRerun_

:setting_ProxyHint
call res\scripts\Config.bat ProxyHint
goto _ReturnToSetting_

:setting_FFmpeg
call res\scripts\Config.bat FFmpeg
goto _ReturnToSetting_

:setting_Wget
echo %str_current-wgetOpt%
set "_WgetOptions_="
cd res && call scripts\Getter.bat WgetOptions
echo. & echo "%_WgetOptions_%"
if NOT exist wget.opt ( call scripts\GenerateWgetOptions.bat )
cd ..
echo. & echo %str_please-edit-wgetOpt_1%
echo %str_please-confirm-changes%
set opt6_opt6_choice=0
echo. & echo %str_please-edit-wgetOpt_2%
set /p opt6_opt6_choice= %str_enter-to-cancel%
echo.
if /i "%opt6_opt6_choice%"=="Y" (
    cd res && call scripts\GenerateWgetOptions.bat
    cd .. && echo %str_reset-wgetOpt-ok%
) else ( echo %str_cancelled% )
goto _ReturnToSetting_

:setting_SystemType
echo %str_current-systemType% %_SystemType_%bit
set opt6_opt7_choice=0
echo. & echo %str_please-set-systemType%
set /p opt6_opt7_choice= %str_enter-to-cancel%
echo.
if /i "%opt6_opt7_choice%"=="T" (
    call res\scripts\Config.bat SystemType
    echo %str_please-rerun%
    goto _PleaseRerun_
) else ( echo %str_cancelled% )
goto _ReturnToSetting_

:setting_NetTest
call res\scripts\Config.bat NetTest
goto _ReturnToSetting_

:setting_UpgradeOnlyViaGitHub
call res\scripts\Config.bat UpgradeOnlyViaGitHub
goto _ReturnToSetting_


rem ================= OPTION 7 =================


:Aliases
call :AskForInit
cls
echo ====================================================
echo ===============%str_opt7-Expanded%===============
echo ====================================================
echo.
echo. & echo  [0] %str_opt7_opt0%
echo. & echo  [1] %str_opt7_opt1%
echo. & echo  [2] %str_opt7_opt2%: "open", "proxy", "yb"
echo. & echo  [3] %str_opt7_opt3%
echo. & echo  [4] %str_opt7_opt4%
echo. & echo  [5] %str_opt7_opt5%
echo. & echo.
echo ====================================================
set opt7_choice=-1
set /p opt7_choice= %str_please-choose%
echo. & echo.
if "%opt7_choice%"=="0" goto MENU
if "%opt7_choice%"=="1" goto aliases_List
if "%opt7_choice%"=="2" goto aliases_Default
if "%opt7_choice%"=="3" goto aliases_Add
if "%opt7_choice%"=="4" goto aliases_Remove
if "%opt7_choice%"=="5" goto aliases_File
echo %str_please-input-valid-num%
goto _ReturnToAliases_


:aliases_List
call res\scripts\Alias.bat list
goto _ReturnToAliases_

:aliases_Default
call res\scripts\Alias.bat addf open="explorer .\"
call res\scripts\Alias.bat generate proxy
call res\scripts\Alias.bat addf yb="youtube-dl -f bestvideo+bestaudio"
goto _ReturnToAliases_

:aliases_Add
set "opt7_opt3_alias="
set "opt7_opt3_command="
set /p opt7_opt3_alias= %str_please-set-alias%
if "%opt7_opt3_alias%"=="" ( echo. & echo %str_cancelled% && goto _ReturnToAliases_ )
set /p opt7_opt3_command= %str_please-set-command%
if "%opt7_opt3_command%"=="" ( echo. & echo %str_cancelled% && goto _ReturnToAliases_ )
echo.
call res\scripts\Alias.bat add %opt7_opt3_alias%="%opt7_opt3_command%"
goto _ReturnToAliases_

:aliases_Remove
call res\scripts\Alias.bat list
set "opt7_opt4_alias="
set /p opt7_opt4_alias= %str_please-set-alias%
if "%opt7_opt4_alias%"=="" ( echo. & echo %str_cancelled% && goto _ReturnToAliases_ )
echo.
call res\scripts\Alias.bat rm %opt7_opt4_alias%
goto _ReturnToAliases_

:aliases_File
call res\scripts\Alias.bat file
goto _ReturnToAliases_


rem ================= FUNCTIONS =================


:_ReturnToMenu_
pause > NUL
goto MENU


:_ReturnToSetting_
pause > NUL
goto Setting


:_ReturnToAliases_
pause > NUL
goto Aliases


:_PleaseRerun_
echo. & echo %str_exit%
pause > NUL
exit


:Create_Download-bat
set isInInitDeploy=%~1
call res\scripts\GenerateDownloadBatch.bat %DeployMode%
echo.
echo ====================================================
if "%isInInitDeploy%"=="1" echo %str_deploy-ok%
echo %str_dl-bat-created%
echo ====================================================
goto :eof


:ExitIfInit
:: Check whether already InitDeploy
if exist usr (
    echo. & echo %str_please-re-init%
    call :_PleaseRerun_
)
goto :eof


:AskForInit
if NOT exist usr (
    echo. & echo %str_please-init%
    pause > NUL
    goto MENU
)
goto :eof


:StopIfDisconnected
if exist deploy.settings (
    for /f "tokens=2 delims= " %%i in ('findstr /i "NetTest" deploy.settings') do ( set "state_netTest=%%i" )
)
if "%state_netTest%"=="disable" goto :eof
echo %str_checking-connection%...
wget -q --no-check-certificate %_RemoteRes_%/scripts/CurrentVersion -O NetTest && set "_isNetConnected=true" || set "_isNetConnected=false"
if exist NetTest del NetTest
if "%_isNetConnected%"=="false" (
    echo %str_please-check-connection%
    pause > NUL
    goto MENU
)
goto :eof


rem ================= End of File =================
