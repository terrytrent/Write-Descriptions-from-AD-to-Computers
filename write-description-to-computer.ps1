$allServers=get-adcomputer -Properties * -Filter * | where {$_.DistinguishedName -like "*,OU=Servers,DC=domain,DC=com"}

foreach($server in $allServers){
    
    $psVersion=$null
    $serverName=$server.CN
    $description=$server.description

    write-host "The Description for $serverName is $description"

    $psVersion=(invoke-command -ComputerName $serverName -ScriptBlock {$PSVersionTable.PSVersion.Major} -ErrorAction SilentlyContinue)

    if($psVersion -eq $null){

        C:\pstools\psexec.exe -u domain\user -p Password \\$serverName net config server /srvcomment:"$description"

    }
    else{

        $fullProperties=get-wmiobject -class Win32_OperatingSystem -computername "$serverName"
        $fullProperties.Description = "$description"
        $fullProperties.Put()
    
    }
    
}

