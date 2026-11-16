# Puts the app into the yaytsa-cloud site as prompter/ (https://yaytsacloud.art/prompter/).
#   .\deploy.ps1                 -> ..\yaytsa-cloud\prompter
#   .\deploy.ps1 -Out some\dir   -> anywhere else
param([string]$Out = (Join-Path $PSScriptRoot '..\yaytsa-cloud\prompter'))
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$version = (Get-Content version.txt -Raw).Trim()
$utf8 = New-Object System.Text.UTF8Encoding($false)
New-Item -ItemType Directory -Force $Out | Out-Null
$Out = (Resolve-Path $Out).Path
Get-ChildItem $Out -File | Remove-Item -Force
foreach ($f in Get-ChildItem web -File) {
  if ($f.Extension -in '.js', '.html', '.css', '.webmanifest') {
    $s = [IO.File]::ReadAllText($f.FullName, $utf8).Replace('__VERSION__', $version)
    [IO.File]::WriteAllText((Join-Path $Out $f.Name), $s, $utf8)
  } else { Copy-Item $f.FullName (Join-Path $Out $f.Name) -Force }
}
Get-ChildItem $Out | Select-Object Name, Length | Format-Table -AutoSize | Out-Host
"prompter $version -> $Out"
