function Get-OnlineStatus {
    
    [CmdletBinding()]
    param
    (

        [string[]]$ComputerName,

        [string]$ErrorLog = "C:\Temp\Error.txt",
        
        [Switch]$LogErrors
        
    )

    Foreach ($c in $ComputerName) {
        
        
        
        try 
        {
            $isOK = $true
            $connection = Test-Connection -ComputerName $c -Count 1 -ErrorAction Stop

            $GS = Get-service -ComputerName $c -Name WinRM #| ft @{n='Computer';e={$c}},@{n='Status';e={'WinRM:' + $_.Status}}

        } 
        Catch [System.Net.NetworkInformation.PingException] 
        {
       
           $isOK = $false
           if ($LogErrors) {


                    $c + "`t $_.Exception.Message" | Out-File $ErrorLog -Append

    
                    }
        }


        $props = @{'ComputerName' = $c;}
                    #'Service Status' = 'WinRM: ' + $GS.Status;}

                    if ($isOK) {
                    $Props.add("WinRM Status",$GS.Status)
                    $Props.add("Ping Status",'online')
                    }else{
                    $Props.add("Ping Status",'Does not respond')
                    $Props.add("WinRM Status","N/A")}
                       

        $obj = New-Object -TypeName PSObject -property $props
        Write-Output $obj 

        #}
    }
}
Get-OnlineStatus -ComputerName Localhost,CH11-0QNHJ61,notamachine,CH82-0RPKB5F,CH82-12AN628,CH11-0QNHJ61,notamachine -LogErrors
 