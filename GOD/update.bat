@echo off
ECHO =============================
ECHO Running Admin Shell
ECHO =============================

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::

FOR /F "usebackq delims=" %%i in (`powershell -Command "& {[Environment]::GetFolderPath('MyDocuments')}"`) DO SET DOCUMENTSDIR=%%i

chcp 65001

@echo 終止程序中...
@echo off
taskkill /f /im GOD.exe

if exist "%DOCUMENTSDIR%\autoGOD\tmp" (

    @echo 更新檔案中...
    @echo off

    if exist "%DOCUMENTSDIR%\autoGOD\tmp\GOD.zip" (
        del "%DOCUMENTSDIR%\autoGOD\tmp\GOD.zip")
    if exist ".\config\config.ini" (
        if exist "%DOCUMENTSDIR%\autoGOD\tmp\config\config.ini" (
            del "%DOCUMENTSDIR%\autoGOD\tmp\config\config.ini"))
    xcopy /s "%DOCUMENTSDIR%\autoGOD\tmp"\* .\ /y

    rmdir /s/q "%DOCUMENTSDIR%\autoGOD\tmp"

    @echo 更新完畢!
    @echo off

) else (
    @echo 發生錯誤，找不到更新檔案!
    @echo off
    pause
)