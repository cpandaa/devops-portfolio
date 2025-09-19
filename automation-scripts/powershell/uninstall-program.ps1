<#
.SYNOPSIS
  Uninstall a program by display name (from Programs & Features).
.EXAMPLE
  .\uninstall-program.ps1 -ProgramName "7-Zip"
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$ProgramName
)

$apps = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*$ProgramName*" }

if ($apps) {
    foreach ($app in $apps) {
        try {
            Write-Output "Uninstalling $($app.Name)..."
            $app.Uninstall() | Out-Null
            Write-Output "Successfully uninstalled $($app.Name)."
        }
        catch {
            Write-Error "Failed to uninstall $($app.Name). $_"
        }
    }
}
else {
    Write-Warning "No program found matching '$ProgramName'."
}

