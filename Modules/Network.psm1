
Import-Module $PSScriptRoot\FunctionModules.psm1 -Scope Local;

# connection to a remote shared folder
# Has no implementation of an ssh key yet 
# had no need 
function Load-Drive
{
    # The ID param can have an option for loading all network drives configured  using '*'
    Param([Parameter(Mandatory=$true)][string]$ID,$Global:XMLReader=$Global:XMLReader)
    if(![String]::IsNullOrEmpty($Global:XMLReader.Machine.Networks))
    {
        [System.Xml.XmlElement]$Network = _GetCurrentNetConfig;
        foreach($val in $Network.Connection)
        {
            if($val.Type -eq "NetworkShare")
            {
                # This statement checks to see if the network drive was set
                if(!(Test-Path $val.DriveLetter) -and (($ID -eq $val.ID) -or ($ID -eq "*")))
                {
                    [String]$IpAddress = $(Evaluate -value:$val.IPAddress); # Get configured Ip
                    Write-Host "Connecting to $($IpAddress) on => $($val.DriveLetter)" -ForegroundColor Gray;
    
                    # Problem: What if the address is within the network but the device is not on?
                    # I think it is the IsWithinNetwork function's job to determine if the device is on
                    # If it is off, then it isn't within network
                    if($(IsWithinNetwork -IpAddress:$IpAddress))
                    {
                        try
                        {
                            net use $val.DriveLetter $IpAddress $(Evaluate -value:$val.Password) /user:$(Evaluate -value:$val.Username);
                            $Global:LogHandler.Write("net use on $($IpAddress)");
                        }
                        catch{$Global:LogHandler.WriteError($_);}
                    }
                }
            }
        }
    }
}

# If it is off, then it isn't within network
# Uses the idea of subnets
# Only valid for drives on LAN
<#
    Hmm side note: can't I just use the IsReachable method to check if the IpAddress is also within the network?
    I think I could because I think it also goes through its own process to check if IP is valid
#>
function IsWithinNetwork
{
    Param([String]$IpAddress)
    # Get Subnet and default gateway for the current network
    [String[]]$ip = ipconfig.exe; # Windows' binary ipconfig
    [String[]]$NetInfo = [string[]]::new($null);
    for([int]$i=0;$i -lt $ip.Count;$i++)
    {
        # Assuming it is always Wireless LAN adapter Wi-Fi 
        if($ip[$i].Contains('Wireless LAN adapter Wi-Fi'))
        {
            [int16]$j = 1;
            [byte]$l = 0;

            # Gets the segment in the ipconfig
            while($true)
            {
                $l = $($ip[$i + $j].Length -gt 0).ToByte($null); # If not a blank row
                if(![string]::IsNullOrEmpty($ip[$i + $j].Substring(0,$l)) -and ($ip[$i + $j].Substring(0,$l) -ne ' ')){break;}
                $j++;
            }
            $NetInfo = $ip[$i..($i+$j-1)]; 
            break;
        }
    }
    if([string]::IsNullOrEmpty($NetInfo)){return $false;} # TODO make logs
    
    # Look through the net info
    [String]$DefaultGateway = $null; # Get Gateway IP
    [String]$SubnetMask = $null; # Get subnet ip
    [int16]$IpStartIndex = 39; # I am going to assume that the addresses start in the same place everytime
    [System.Boolean]$IsConnected = $true; # Assuming that we are connected
    for([int]$i=0;$i -lt $NetInfo.Count;$i++)
    {
        # This is for the case when we are not connected to wifi
        if($NetInfo[$i].Contains('Media State') -and $NetInfo[$i].Contains('Media disconnected')){$IsConnected = $false;break;}
        if($NetInfo[$i].Contains('Default Gateway'))
        {
            # checks if IPv6 since it has letters
            if($NetInfo[$i].Substring($IpStartIndex,$NetInfo[$i].Length-$IpStartIndex) -match "[a-zA-Z]+")
            {$DefaultGateway = $NetInfo[$i+1].Substring($IpStartIndex,$NetInfo[$i+1].Length-$IpStartIndex);}
            else{$DefaultGateway = $NetInfo[$i].Substring($IpStartIndex,$NetInfo[$i].Length-$IpStartIndex);}
        }
        if($NetInfo[$i].Contains('Subnet Mask')){$SubnetMask = $NetInfo[$i].Substring($IpStartIndex,$NetInfo[$i].Length-$IpStartIndex);}
    }
    if([String]::IsNullOrEmpty($DefaultGateway) -and [String]::IsNullOrEmpty($SubnetMask)){return $false;} # TODO make logs
    if(!$IsConnected){return $false;} # You are not connected TODO make logs

    [String]$hostnamestring = GetHostName -Path:$IpAddress; # getting the host name just in case it is a shared folder path
    [String]$IpAddr = $(GetBaseIP -SubnetMask:$SubnetMask -IpAddress:$hostnamestring);
    [String]$DefaultGate = $(GetBaseIP -SubnetMask:$SubnetMask -IpAddress:$DefaultGateway);

    # If we made it this far then we have extract the base ip to check if it is within the sub net
    # Only check if device is on if the ip is within the network
    if($IpAddr -eq $DefaultGate){return $(IsReachable -IpAddress:$hostnamestring);} # Passes original IP 
    else{return $false;}
}

# If it reachable we will receive a package quickly when pinged
# If it is not reachable then it will take a while for the ping to realize
# but it significantly saves time from us initiating the net use cmd
function IsReachable # If the pinged then the device is on
{
    Param([String]$IpAddress)
    [string[]]$o = (PING.EXE $IpAddress /n 1);
    if([string]::IsNullOrEmpty($o)){$Global:LogHandler.Warning("PING.EXE did not return anything for IP - $($IpAddress)");}

    # As of 8/16/2020, ping will output this "Destination host unreachable."
    if($o[2].Contains("Destination host unreachable.")){return $false;}
    else{return $true;}
}

# Function to get the root host name from a network file path
# mainly used for file share
function GetHostName
{
    Param([String]$Path)
    return $Path -split "\\" | Where-Object {  $_ -ne ""  } | Select-Object -first 1;
}


# Retrieves it from subnet mask
# Ipv4
function GetBaseIP 
{
    Param([string]$SubnetMask,[String]$IpAddress)

    [int16]$maxbytes = 4;

    # Manually split the string 
    # Pretty similar to the List.psm1 module
    [String[]]$SubnetArray = $(SplitString -originalstring:$(GetHostName -Path:$SubnetMask) -Delimiter:$("."));
    [String[]]$IpArray = $(SplitString -originalstring:$(GetHostName -Path:$IpAddress) -Delimiter:$("."));
    
    # populated the array incorrectly, should not be more than 4 bytes
    if(($SubnetArray.Count -gt $maxbytes) -or ($IpArray.Count -gt $maxbytes))
    {
        $Global:LogHandler.Write("Subnet array or Ip array were split more than 4 times. May not be an IP address for ipv4");
        break;
    } 

    # Get the base Ip strings
    [String]$BaseIp = $null;
    [Calculations]$Math = [Calculations]::new();
    for([int16]$i = 0;$i -lt $maxbytes;$i++)
    {
        $BaseIp += $Math.BinaryToInt($Math.And($SubnetArray[$i].ToInt16($null),$IpArray[$i].ToInt16($null))).ToString() + "."; # There is an issue here
    }

    # Returns a string
    return $BaseIp.Substring(0,$BaseIp.Length-1); # -1 removes the . in the end
}


function Get-Wifi
{
    [string[]]$o = $(Netsh WLAN show interfaces); # Get wifi info

    [string]$SSIDRow = $null;
    for([int16]$i = 0;$i -lt $o.Count;$i++){if($o[$i].Contains("  SSID")){$SSIDRow = $o[$i];}} # find the row 
    if([string]::IsNullOrEmpty($SSIDRow)){throw "Something went wrong";}

    [string]$SSIDName = $null;
    for([int16]$i = 0;$i -lt $SSIDRow.Length;$i++)
    {
        if($SSIDRow[$i] -eq ':')
        {
            [string]$idx = $i+2;
            $SSIDName = $SSIDRow.Substring($idx,$SSIDRow.Length-$idx); # Extract the name based on the colon
            break;
        }
    }
    return $SSIDName;
}

function _GetCurrentNetConfig
{
    [string]$SSIDName = Get-Wifi;
    foreach($Network in $Global:XMLReader.Machine.Networks.Network)
    {
        [System.Xml.XmlDocument]$LanConfigReader = Get-Content $(Get-ChildItem $PSScriptRoot\..\Config\Wifi\$($Network.LANConfig).xml);
        if($LanConfigReader.WLANProfile.SSIDConfig.SSID.name -eq $SSIDName){return $Network;}
    }    
}

function List-Wifi
{
    
    [string[]]$o = $(Get-ChildItem $PSScriptRoot\..\Config\Wifi\*.xml); # Get all wifi config files

    for([int16]$i=0;$i -lt $o.Count;$i++)
    {
        [System.Xml.XmlDocument]$d = Get-Content $o[$i]; # Get config content
        Write-Host "$($d.WLANProfile.SSIDConfig.SSID.name)";
    }
}

# This reads the directory
# Regardless of what is configed, whatever is in the wifi config dir you can set the wifi to that 
function Set-Wifi
{
    param([string]$NetworkConfig=$null)

    if([string]::IsNullOrEmpty($NetworkConfig))
    {
        [string[]]$o = $(Get-ChildItem $PSScriptRoot\..\Config\Wifi\*.xml); # Get all wifi config files
        [string[]]$SSIDNames = [string[]]::new($null);
    
        for([int16]$i=0;$i -lt $o.Count;$i++)
        {
            [System.Xml.XmlDocument]$d = Get-Content $o[$i]; # Get config content
            Write-Host " $($i+1) - $($d.WLANProfile.SSIDConfig.SSID.name)";
            $SSIDNames += "$($d.WLANProfile.SSIDConfig.SSID.name)";
        }
        try{[int16]$i = Read-Host -Prompt "So? ";}
        catch{$Global:LogHandler.Warning("Probably did not put the correct formatted input");break;}
        [string]$FilePath = $($o[$i-1]);
        [string]$SSIDName = $($SSIDNames[$i-1]);
    }
    else
    {
        [string]$FilePath = $(GetFullFilePath($NetworkConfig));
        [System.Xml.XmlDocument]$d = Get-Content $FilePath; # Get config content
        [string]$SSIDName = "$($d.WLANProfile.SSIDConfig.SSID.name)";
    }

    netsh wlan disconnect; # Disconnect 
    netsh wlan add profile filename=$FilePath; # Add profie
    netsh wlan connect name=$($SSIDName); # Connect 
}

function Open-Ssh
{
    param
    (
        [string]$ID=$null
    )
    if([string]::IsNullOrEmpty($ID)){$ID = $(Read-Host -Prompt "Please provide Network Connection ID for this connection");}
    [System.Xml.XmlElement]$Network = _GetCurrentNetConfig;
    [System.Boolean]$est = $false;
    foreach($Connection in $Network.Connection)
    {
        if(($Connection.Type -eq "SSH") -and ($ID -eq $Connection.ID))
        {
            $est = $true;
            if($Connection.SSHClientPath.Type -eq "Putty")
            {
                Set-Alias -Name "Putty" -Value $Connection.SSHClientPath.InnerText;
                Putty -ssh "$(Evaluate -value:$Connection.Username)@$(Evaluate -value:$Connection.IPAddress)" $(Evaluate -value:$Connection.Port) -pw $(Evaluate -value:$Connection.Password) -i $(Evaluate -value:$Connection.SSHKey);
            }
            elseif($Connection.SSHClientPath.Type -eq "Powershell")
            {
                ssh "$(Evaluate -value:$Connection.Username)@$(Evaluate -value:$Connection.IPAddress)" -p $(Evaluate -value:$Connection.Port) -i $(Evaluate -value:$Connection.SSHKey);
            }
        }
    }
    if(!$est){$Global:LogHandler.Warning("Connection not found for ID: $($ID)");}
}