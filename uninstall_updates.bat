@echo off
REM =========================================================
REM ==         Modern Windows Update Uninstall Script      ==
REM ==                  Run as Administrator               ==
REM =========================================================

echo ==========================================
echo  Windows Update Removal Tool
echo ==========================================
echo.

REM --- Check for Administrator Privileges ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Administrator privileges are required!
    echo Please right-click this script and select "Run as Administrator".
    echo.
    pause
    exit /b 1
)

echo Showing last 15 recently installed updates (newest first)...
echo NOTE: This list excludes all routine Defender and Security platform updates.
echo.
REM --- FINAL VERSION: Uses a better filter to exclude all definition-style updates ---
powershell -NoProfile -Command "$Session = New-Object -ComObject 'Microsoft.Update.Session'; $Searcher = $Session.CreateUpdateSearcher(); $HistoryCount = $Searcher.GetTotalHistoryCount(); $Searcher.QueryHistory(0, $HistoryCount) | Where-Object { $_.Title -notlike '*Security Intelligence*' -and $_.Title -notlike '*Definition Update*' -and $_.Title -notlike '*Security Platform*' -and $_.Operation -eq 1 -and $_.ResultCode -eq 2 } | ForEach-Object { [PSCustomObject]@{ HotFixID = if ($_.Title -match '(KB\d+)') { $matches[0] } else { 'N/A' }; Description = $_.Title; InstalledOn = $_.Date } } | Sort-Object InstalledOn -Descending | Select-Object -First 15 | Format-Table -AutoSize"
echo.
echo ==========================================
echo.
echo Verifying target updates exist before removal...
echo.

set "found=0"
set "KB1=KB5066835"
set "KB2=KB5065789"
set "KB3=KB5066131"

REM --- Use reliable PowerShell checks to find specific updates ---
powershell -NoProfile -Command "$S = New-Object -ComObject 'Microsoft.Update.Session'; $H = $S.CreateUpdateSearcher().GetTotalHistoryCount(); $R = $S.CreateUpdateSearcher().QueryHistory(0, $H) | Where-Object { $_.Title -like '*%KB1%*' -and $_.Operation -eq 1 -and $_.ResultCode -eq 2 }; exit !($R)"
if %errorLevel% equ 0 (
    echo [FOUND] %KB1%
    set "found=1"
) else (
    echo [NOT FOUND] %KB1%
)

powershell -NoProfile -Command "$S = New-Object -ComObject 'Microsoft.Update.Session'; $H = $S.CreateUpdateSearcher().GetTotalHistoryCount(); $R = $S.CreateUpdateSearcher().QueryHistory(0, $H) | Where-Object { $_.Title -like '*%KB2%*' -and $_.Operation -eq 1 -and $_.ResultCode -eq 2 }; exit !($R)"
if %errorLevel% equ 0 (
    echo [FOUND] %KB2%
    set "found=1"
) else (
    echo [NOT FOUND] %KB2%
)

powershell -NoProfile -Command "$S = New-Object -ComObject 'Microsoft.Update.Session'; $H = $S.CreateUpdateSearcher().GetTotalHistoryCount(); $R = $S.CreateUpdateSearcher().QueryHistory(0, $H) | Where-Object { $_.Title -like '*%KB3%*' -and $_.Operation -eq 1 -and $_.ResultCode -eq 2 }; exit !($R)"
if %errorLevel% equ 0 (
    echo [FOUND] %KB3%
    set "found=1"
) else (
    echo [NOT FOUND] %KB3%
)

echo.

if "%found%"=="0" (
    echo ==========================================
    echo  WARNING: None of the target updates were found!
    echo  This is correct as they are not in the installation history.
    echo  Nothing to remove.
    echo ==========================================
    pause
    exit /b 0
)

echo ==========================================
echo.
echo This script will open a dialog window for each found update.
echo Please click "Yes" on each dialog to proceed with the uninstallation.
echo.
echo Press any key to continue...
pause >nul

echo.
echo ==========================================
echo  Starting Update Removal Process...
echo ==========================================
echo.

echo [1/3] Processing %KB1%...
powershell -NoProfile -Command "$S = New-Object -ComObject 'Microsoft.Update.Session'; $H = $S.CreateUpdateSearcher().GetTotalHistoryCount(); $R = $S.CreateUpdateSearcher().QueryHistory(0, $H) | Where-Object { $_.Title -like '*%KB1%*' -and $_.Operation -eq 1 -and $_.ResultCode -eq 2 }; exit !($R)"
if %errorLevel% equ 0 (
    echo Uninstalling %KB1%... Please click YES in the dialog.
    start /wait wusa.exe /uninstall /kb:%KB1:~2% /norestart
    echo %KB1% processed.
) else (
    echo %KB1% not found, skipping.
)
echo.

echo [2/3] Processing %KB2%...
powershell -NoProfile -Command "$S = New-Object -ComObject 'Microsoft.Update.Session'; $H = $S.CreateUpdateSearcher().GetTotalHistoryCount(); $R = $S.CreateUpdateSearcher().QueryHistory(0, $H) | Where-Object { $_.Title -like '*%KB2%*' -and $_.Operation -eq 1 -and $_.ResultCode -eq 2 }; exit !($R)"
if %errorLevel% equ 0 (
    echo Uninstalling %KB2%... Please click YES in the dialog.
    start /wait wusa.exe /uninstall /kb:%KB2:~2% /norestart
    echo %KB2% processed.
) else (
    echo %KB2% not found, skipping.
)
echo.

echo [3/3] Processing %KB3%...
powershell -NoProfile -Command "$S = New-Object -ComObject 'Microsoft.Update.Session'; $H = $S.CreateUpdateSearcher().GetTotalHistoryCount(); $R = $S.CreateUpdateSearcher().QueryHistory(0, $H) | Where-Object { $_.Title -like '*%KB3%*' -and $_.Operation -eq 1 -and $_.ResultCode -eq 2 }; exit !($R)"
if %errorLevel% equ 0 (
    echo Uninstalling %KB3%... Please click YES in the dialog.
    start /wait wusa.exe /uninstall /kb:%KB3:~2% /norestart
    echo %KB3% processed.
) else (
    echo %KB3% not found, skipping.
)
echo.

echo ==========================================
echo  Update removal process completed!
echo ==========================================
echo.
echo NOTE: A system restart is highly recommended to finalize the changes.
echo.
pause