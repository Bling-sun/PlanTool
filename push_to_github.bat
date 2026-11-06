@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"
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
git remote get-url origin 2>nul | findstr /x /c:"https://github.com/Bling-sun/PlanTool.git" /c:"https://github.com/Bling-sun/PlanTool" /c:"git@github.com:Bling-sun/PlanTool.git" >nul
if errorlevel 1 (
  echo Unexpected origin URL. Expected Bling-sun/PlanTool. No files were uploaded.
  goto failed
)
git config user.name >nul 2>nul
if errorlevel 1 git config user.name Bling-sun
git config user.email >nul 2>nul
if errorlevel 1 git config user.email Bling-sun@users.noreply.github.com
git add -- .gitignore README.md USER_GUIDE.txt PersonalPlan.cs GlassPlanner.cs BuildPersonalPlan.ps1 push_to_github.bat
if errorlevel 1 goto failed
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

