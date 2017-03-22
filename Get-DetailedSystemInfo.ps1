function Get-DetailedSystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string[]]$computerName
    )
    PROCESS {
        foreach ($computer in $computerName) {
            $params = @{computerName=$computer;       
                        class='Win32_OperatingSystem'}       
            $os = Get-WmiObject @params                

            $params = @{computerName=$computer;   
                        class='Win32_LogicalDisk';        
                        filter='drivetype=3'}     
            $disks = Get-WmiObject @params        
            

            $diskobjs = @()               
            foreach ($disk in $disks) {
                $diskprops = @{Drive=$disk.DeviceID;    
                               Size=$disk.size;        
                               Free=$disk.freespace}   
                $diskobj = new-object -Type PSObject -Property $diskprops
                $diskobjs += $diskobj                   
            }

            $mainprops = @{ComputerName=$computer; 
                           Disks=$diskobjs;
                           OSVersion=$os.version;
                           SPVersion=$os.servicepackmajorversion}
            #$mainobject = 
            
            New-Object -Type PSObject -Property $mainprops

           
            #Write "  $($Computer) Physical Disk(s):"
                #foreach ($obj in $diskobjs) {
                
                #Write "`t $($obj)"
                #Write $obj
                #}

            #Write-Output $mainobject
        }
    }
}
#$services = Get-Service
#foreach ($main_service in $services) {
#    Write "  $($main_service.name) depends on:"
#    foreach ($sub_service in $main_service.requiredservices) {
       
 #       Write "`t $($sub_service.name)"


#Get-DetailedSystemInfo -computerName localhost,CH82-0RPKB5F | select -ExpandProperty Disks
Get-DetailedSystemInfo -computerName localhost,CH82-0RPKB5F | format-custom