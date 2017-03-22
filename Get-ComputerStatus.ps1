function Get-MachineStatus {
    
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
        [string[]]$ComputerName,

        [string]$ErrorLog = "C:\Temp\Error.txt",
        
        [Switch]$LogErrors   
    )

    Foreach ($c in $ComputerName) 
    {   
        try 
        {
            
            $isOK = $true
            
            $connection = Test-Connection -ComputerName $c -Count 1 -ErrorAction Stop
            
        } 
        Catch [System.Net.NetworkInformation.PingException] 
        {
       
           $isOK = $false

           if ($LogErrors) 
           {

                    $c + "`t $_.Exception.Message" | Out-File $ErrorLog -Append
           }
        }

        if ($isOK) 
        {
            Try 
            {

                $Service = Get-service -ComputerName $c -Name WinRM -ErrorAction Stop #| ft @{n='Computer';e={$c}},@{n='Status';e={'WinRM:' + $_.Status}}

                $CS = Get-WmiObject -ComputerName $c -Class Win32_ComputerSystem -ErrorAction Stop 

                $OS = Get-WmiObject -ComputerName $c -Class Win32_OperatingSystem -ErrorAction Stop

            }
            Catch 
            {
                $c + "`t $_.Exception.Message" | Out-File $ErrorLog -Append
            }
        
        }
        $props = @{'Computer Name' = $c;}

                    if ($isOK) {
                    
                    $Props.add("WinRM Status",$Service.Status)
                    $Props.add("Ping Status",'online')
                    $Props.add("Logged user",$CS.userName)
                    $Props.add("Operating System",$OS.Caption)
                    $Props.add("Computer Model",$CS.Model)
                    }else{
                    $Props.add("Logged user",'N/A')
                    $Props.add("Ping Status",'Does not respond')
                    $Props.add("WinRM Status","N/A")
                    $Props.add("Operating System","N/A")
                    $Props.add("Computer Model","N/A")}
                       

        $obj = New-Object -TypeName PSObject -property $props
        $obj.PSObject.TypeNames.Insert(0,'Nestle.ComputerStatus')
        Write-Output $obj 
        
    }
}
set-alias gms Get-MachineStatus -scope Global

 