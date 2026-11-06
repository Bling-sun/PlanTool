@echo off
setlocal
set "PLAN_PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\powershell\pwsh.exe" set "PLAN_PS=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\powershell\pwsh.exe"
if /i "%~1"=="--check" goto check
"%PLAN_PS%" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0push_to_github.ps1"
set "PLAN_PUSH_RESULT=%ERRORLEVEL%"
pause
exit /b %PLAN_PUSH_RESULT%
:check
"%PLAN_PS%" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0push_to_github.ps1" -Check
exit /b %ERRORLEVEL%
