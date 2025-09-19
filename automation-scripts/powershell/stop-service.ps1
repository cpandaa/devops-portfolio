<#
.SYNOPSIS
  Stop a Windows service safely.
.EXAMPLE
  .\stop-service.ps1 -ServiceName "Spooler"
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$ServiceName
)

try {
    Stop-Service -Name $ServiceName -Force -ErrorAction Stop
    Write-Output "Service '$ServiceName' stopped successfully."
}
catch {
    Write-Error "Failed to stop service '$ServiceName'. $_"
}

