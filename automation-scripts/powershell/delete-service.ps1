<#
.SYNOPSIS
  Delete a Windows service completely.
.EXAMPLE
  .\delete-service.ps1 -ServiceName "OldService"
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$ServiceName
)

try {
    sc.exe delete $ServiceName | Out-Null
    Write-Output "Service '$ServiceName' deleted successfully."
}
catch {
    Write-Error "Failed to delete service '$ServiceName'. $_"
}

