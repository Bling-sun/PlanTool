$ErrorActionPreference = 'Stop'
$compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
if (!(Test-Path -LiteralPath $compiler)) { $compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319\csc.exe' }
& $compiler /nologo /target:exe /optimize+ /out:"$PSScriptRoot\Tools\IconBuilder.exe" /reference:System.dll /reference:System.Drawing.dll "$PSScriptRoot\Tools\BuildIcon.cs"
if ($LASTEXITCODE -ne 0) { throw 'Icon builder compilation failed' }
& "$PSScriptRoot\Tools\IconBuilder.exe" "$PSScriptRoot\Assets"
if ($LASTEXITCODE -ne 0) { throw 'Icon generation failed' }
