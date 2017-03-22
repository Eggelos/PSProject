
<#
.SYNOPSIS
Enable-RD allow Remote Desktop Connection on one or more computers 
.DESCRIPTION
Enable-RD allow the current or a given user to take one or more 
computers remotely. The given alias name will be set into the
"Remote Desktop Users" local group and the registry value "fDenyTSConnections"
will be set to 1. This will allow on the given machine name terminal server connections.  
.PARAMETER computername
The computer name, or names, to query. Default: Localhost.
.PARAMETER username
The user name or names that will be granted with Remote desktop access.
Default: CurrentUser
.EXAMPLE
Enable-RD -computername CH82-0RPKB5F -username abona
#>

Param(
$computername = $env:COMPUTERNAME,
$username = $env:username
)
$de = [ADSI]“WinNT://$computername/Remote Desktop Users,group” 
$de.psbase.Invoke(“Add”,([ADSI]“WinNT://Nestle/$username”).path)
#Registry
Invoke-Command $computername {Set-Location HKLM:;
Sl SYSTEM\CurrentControlSet\Control\;
Set-ItemProperty -Name fDenyTSConnections -Value 0 -Path "Terminal Server"}


