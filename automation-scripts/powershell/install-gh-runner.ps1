param(
  [Parameter(Mandatory=$true)][string]$RepoUrl,         # https://github.com/org/repo
  [Parameter(Mandatory=$true)][string]$RunnerToken,     # Registration token
  [string]$RunnerName = $env:COMPUTERNAME,
  [string]$WorkDir = "C:\actions-runner"
)

$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
Set-Location $WorkDir

$ver = "2.319.1"
$pkg = "actions-runner-win-x64-$ver.zip"
Invoke-WebRequest -Uri "https://github.com/actions/runner/releases/download/v$ver/$pkg" -OutFile $pkg
Expand-Archive -Path $pkg -DestinationPath $WorkDir -Force

.\config.cmd --url $RepoUrl --token $RunnerToken --name $RunnerName --work _work --runasservice --unattended
Start-Service actions.runner.*
Write-Host "Runner installed & started."

