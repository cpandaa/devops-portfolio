<#
.SYNOPSIS
  Start a Windows service safely.

.DESCRIPTION
  Uses Start-Service to start the given service name and verifies if it is running.

.PARAMETER ServiceName
  The name of the service to start (e.g. "Spooler").

.EXAMPLE
  .\start-service.ps1 -ServiceName "Spooler"
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$ServiceName
)

try {
    # Check if service exists
    $svc = Get-Service -Name $ServiceName -ErrorAction Stop
}
catch {
    Write-Error "Service '$ServiceName' not found."
    exit 1
}

if ($svc.Status -eq "Running") {
    Write-Output "Service '$ServiceName' is already running."
}
else {
    try {
        Start-Service -Name $ServiceName -ErrorAction Stop
        Write-Output "Service '$ServiceName' started successfully."
    }
    catch {
        Write-Error "Failed to start service '$ServiceName'. $_"
        exit 1
    }
}

# Show final status
Get-Service -Name $ServiceName | Format-Table Status, Name, DisplayName -AutoSize
