
Function Resolve-HostIPAddress {

[cmdletbinding()]
Param (
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter the name of a host. An FQDN is preferred.")]
[ValidateNotNullorEmpty()]
[string]$Hostname
)

Write-Verbose "Starting Resolve-HostIPAddress"
Write-Verbose "Resolving $hostname to IP Address"

Try {
    $data=[system.net.dns]::GetHostEntry($hostname)
    #the host might have multiple IP addresses
    Write-Verbose "Found $(($data.addresslist | measure-object).Count) address list entries"
    $data.AddressList | Select -ExpandProperty IPAddressToString
}
Catch {
    Write-Warning "Failed to resolve host $hostname to an IP address"
}

Write-Verbose "Ending Resolve-HostIPAddress"
} #end function

Resolve-HostIPAddress CH82-12avc3d -verbose