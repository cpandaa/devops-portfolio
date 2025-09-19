<#
.SYNOPSIS
  List all services with running status.
.EXAMPLE
  .\list-services.ps1
#>

Get-Service | Sort-Object Status, DisplayName | Format-Table -AutoSize

