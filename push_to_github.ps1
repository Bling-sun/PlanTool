param([switch]$Check)
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$nativeGit = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\mingw64\bin\git.exe'
if (Test-Path -LiteralPath $nativeGit) { $gitExe = $nativeGit } else { $gitExe = (Get-Command git -ErrorAction Stop).Source }
function Invoke-PlanGit {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArguments)
    & $gitExe @GitArguments
    if ($LASTEXITCODE -ne 0) { throw "Git failed (exit $LASTEXITCODE)." }
}
try {
    if (!(Test-Path -LiteralPath (Join-Path $PSScriptRoot '.git'))) {
        Invoke-PlanGit init -b main
        Invoke-PlanGit remote add origin https://github.com/Bling-sun/PlanTool.git
    }
    $origin = (& $gitExe remote get-url origin | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or $origin -notin @('https://github.com/Bling-sun/PlanTool.git','https://github.com/Bling-sun/PlanTool','git@github.com:Bling-sun/PlanTool.git')) {
        throw 'Unexpected origin. Expected Bling-sun/PlanTool. Nothing was uploaded.'
    }
    & $gitExe config user.name > $null
    if ($LASTEXITCODE -ne 0) { Invoke-PlanGit config user.name Bling-sun }
    & $gitExe config user.email > $null
    if ($LASTEXITCODE -ne 0) { Invoke-PlanGit config user.email Bling-sun@users.noreply.github.com }
    $codeFiles = @('.gitignore','README.md','USER_GUIDE.txt','PersonalPlan.cs','GlassPlanner.cs','BuildPersonalPlan.ps1','push_to_github.bat','push_to_github.ps1')
    Invoke-PlanGit add -- @codeFiles
    Invoke-PlanGit diff --cached --check
    if ($Check) { Write-Host 'Code file selection and repository checks passed.'; exit 0 }
    & $gitExe diff --cached --quiet -- @codeFiles
    $diffExit = $LASTEXITCODE
    if ($diffExit -eq 1) { Invoke-PlanGit -c maintenance.auto=false commit --only -m 'Update Personal Plan' -- @codeFiles }
    elseif ($diffExit -eq 0) { Write-Host 'No code changes to commit.' }
    else { throw 'Unable to inspect staged changes.' }
    Invoke-PlanGit push -u origin HEAD
    Write-Host 'Uploaded successfully: https://github.com/Bling-sun/PlanTool'
    Write-Host 'Personal data, API keys and backups are excluded.'
    exit 0
} catch {
    Write-Host ('Upload failed: ' + $_.Exception.Message) -ForegroundColor Red
    Write-Host 'Check GitHub sign-in, repository access and network/proxy settings.'
    Write-Host 'No force push or automatic conflict resolution was performed.'
    exit 1
}
