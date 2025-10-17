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

echo This script will open 3 dialog windows.
echo Click "Yes" on each dialog to uninstall the updates.
echo.
pause

echo.
echo ==========================================
echo Starting update removal...
echo ==========================================
echo.

echo [1/3] Uninstalling KB5066835...
echo Click YES in the dialog window that appears.
start /wait wusa.exe /uninstall /KB:5066835 /norestart
echo.

echo [2/3] Uninstalling KB5065789...
echo Click YES in the dialog window that appears.
start /wait wusa.exe /uninstall /KB:5065789 /norestart
echo.

echo [3/3] Uninstalling KB5066131...
echo Click YES in the dialog window that appears.
start /wait wusa.exe /uninstall /KB:5066131 /norestart
echo.

echo ==========================================
echo Update removal process completed!
echo ==========================================
echo.
echo NOTE: A system restart is recommended to complete the removal.
echo.
pause