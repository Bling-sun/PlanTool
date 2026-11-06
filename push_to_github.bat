@echo off
setlocal
if /i "%~1"=="--check" goto check
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0push_to_github.ps1"
set "PLAN_PUSH_RESULT=%ERRORLEVEL%"
pause
exit /b %PLAN_PUSH_RESULT%
:check
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0push_to_github.ps1" -Check
exit /b %ERRORLEVEL%
