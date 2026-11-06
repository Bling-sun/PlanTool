@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
cd /d "%~dp0"
if exist "%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\mingw64\bin\git.exe" set "PATH=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\mingw64\bin;%PATH%"
where git >nul 2>nul
if errorlevel 1 if exist "%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd\git.exe" set "PATH=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd;%PATH%"
where git >nul 2>nul
if errorlevel 1 (
  echo Git was not found. Install Git for Windows, then retry.
  goto failed
)
git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  git init -b main
  if errorlevel 1 goto failed
  git remote add origin https://github.com/Bling-sun/PlanTool.git
)
set "PLAN_REMOTE="
for /f "delims=" %%R in ('git remote get-url origin 2^>nul') do set "PLAN_REMOTE=%%R"
if /i "!PLAN_REMOTE!"=="https://github.com/Bling-sun/PlanTool.git" goto origin_ok
if /i "!PLAN_REMOTE!"=="https://github.com/Bling-sun/PlanTool" goto origin_ok
if /i "!PLAN_REMOTE!"=="git@github.com:Bling-sun/PlanTool.git" goto origin_ok
echo Unexpected origin URL. Expected Bling-sun/PlanTool. No files were uploaded.
goto failed
:origin_ok
git config user.name >nul 2>nul
if errorlevel 1 git config user.name Bling-sun
git config user.email >nul 2>nul
if errorlevel 1 git config user.email Bling-sun@users.noreply.github.com
git add -- .gitignore README.md USER_GUIDE.txt PersonalPlan.cs GlassPlanner.cs BuildPersonalPlan.ps1 push_to_github.bat
if errorlevel 1 goto failed
if /i "%~1"=="--check" (
  git diff --cached --check
  if errorlevel 1 exit /b 1
  echo Code file selection and repository checks passed.
  exit /b 0
)
git diff --cached --quiet -- .gitignore README.md USER_GUIDE.txt PersonalPlan.cs GlassPlanner.cs BuildPersonalPlan.ps1 push_to_github.bat
if errorlevel 1 (
  git commit --only -m "Update Personal Plan" -- .gitignore README.md USER_GUIDE.txt PersonalPlan.cs GlassPlanner.cs BuildPersonalPlan.ps1 push_to_github.bat
  if errorlevel 1 goto failed
) else (
  echo No code changes to commit.
)
git push -u origin HEAD
if errorlevel 1 goto failed
echo.
echo Uploaded successfully: https://github.com/Bling-sun/PlanTool
echo Personal data, API keys and backups are excluded.
pause
exit /b 0
:failed
echo.
echo Upload failed. Check GitHub sign-in, repository access and network/proxy settings.
echo No force push or automatic conflict resolution was performed.
pause
exit /b 1
