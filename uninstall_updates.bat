@echo off
REM Uninstall Windows Updates Batch Script
REM Run as Administrator

echo ==========================================
echo Windows Update Removal Tool
echo ==========================================
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Administrator privileges required!
    echo Please run this script as Administrator.
    pause
    exit /b 1
)

echo Showing recently installed updates (sorted by date)...
echo.
wmic qfe get HotFixID,InstalledOn,Description | sort /R
echo.
echo ==========================================
echo.
echo Checking for target updates...
echo.
wmic qfe where "HotFixID='KB5066835' OR HotFixID='KB5065789' OR HotFixID='KB5066131'" get HotFixID,InstalledOn,Description
echo.
echo ==========================================
echo.
echo Verifying updates exist before removal...
echo.

set "found=0"

wmic qfe where "HotFixID='KB5066835'" get HotFixID /format:list | find "KB5066835" >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] KB5066835
    set "found=1"
) else (
    echo [NOT FOUND] KB5066835
)

wmic qfe where "HotFixID='KB5065789'" get HotFixID /format:list | find "KB5065789" >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] KB5065789
    set "found=1"
) else (
    echo [NOT FOUND] KB5065789
)

wmic qfe where "HotFixID='KB5066131'" get HotFixID /format:list | find "KB5066131" >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] KB5066131
    set "found=1"
) else (
    echo [NOT FOUND] KB5066131
)

echo.

if "%found%"=="0" (
    echo ==========================================
    echo WARNING: None of the target updates found!
    echo Nothing to remove.
    echo ==========================================
    pause
    exit /b 0
)

echo ==========================================
echo.
echo This script will open dialog windows for found updates.
echo Click "Yes" on each dialog to uninstall the updates.
echo.
echo Press any key to continue...
pause >nul

echo.
echo ==========================================
echo Starting update removal...
echo ==========================================
echo.

echo [1/3] Checking KB5066835...
wmic qfe where "HotFixID='KB5066835'" get HotFixID /format:list | find "KB5066835" >nul 2>&1
if %errorLevel% equ 0 (
    echo Uninstalling KB5066835... Click YES in the dialog.
    start /wait wusa.exe /uninstall /KB:5066835 /norestart
    echo KB5066835 processed.
) else (
    echo KB5066835 not installed, skipping.
)
echo.

echo [2/3] Checking KB5065789...
wmic qfe where "HotFixID='KB5065789'" get HotFixID /format:list | find "KB5065789" >nul 2>&1
if %errorLevel% equ 0 (
    echo Uninstalling KB5065789... Click YES in the dialog.
    start /wait wusa.exe /uninstall /KB:5065789 /norestart
    echo KB5065789 processed.
) else (
    echo KB5065789 not installed, skipping.
)
echo.

echo [3/3] Checking KB5066131...
wmic qfe where "HotFixID='KB5066131'" get HotFixID /format:list | find "KB5066131" >nul 2>&1
if %errorLevel% equ 0 (
    echo Uninstalling KB5066131... Click YES in the dialog.
    start /wait wusa.exe /uninstall /KB:5066131 /norestart
    echo KB5066131 processed.
) else (
    echo KB5066131 not installed, skipping.
)
echo.

echo ==========================================
echo Update removal process completed!
echo ==========================================
echo.
echo NOTE: A system restart is recommended to complete the removal.
echo.
pause