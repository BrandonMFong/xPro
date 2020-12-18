# This class basically figures out the default gateway ip address and the subnet mask of the network you are currently on 
class Net
{
    [String]$DefaultGateway = $null; # Get Gateway IP
    [String]$SubnetMask = $null; # Get subnet ip
    [System.Boolean]$IsConnected = $false;

    Net()
    {
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
        # if netinfo was null, then we didn't find connection info
        if([string]::IsNullOrEmpty($NetInfo))
        {
            $this.IsConnected = $false; # just to assure
        } 
        else
        {
            # Look through the net info
            # [String]$DefaultGateway = $null; # Get Gateway IP
            # [String]$SubnetMask = $null; # Get subnet ip
            [int16]$IpStartIndex = 39; # I am going to assume that the addresses start in the same place everytime
            # [System.Boolean]$IsConnected = $true; # Assuming that we are connected
            for([int]$i=0;$i -lt $NetInfo.Count;$i++)
            {
                # This is for the case when we are not connected to wifi
                if($NetInfo[$i].Contains('Media State') -and $NetInfo[$i].Contains('Media disconnected')){$this.IsConnected = $false;break;}
                if($NetInfo[$i].Contains('Default Gateway'))
                {
                    # checks if IPv6 since it has letters
                    # if this is an ipv6 address, then use the next index of the string array
                    if($NetInfo[$i].Substring($IpStartIndex,$NetInfo[$i].Length-$IpStartIndex) -match "[a-zA-Z]+")
                    {$this.DefaultGateway = $NetInfo[$i+1].Substring($IpStartIndex,$NetInfo[$i+1].Length-$IpStartIndex);}
                    else{$this.DefaultGateway = $NetInfo[$i].Substring($IpStartIndex,$NetInfo[$i].Length-$IpStartIndex);}
                }
                if($NetInfo[$i].Contains('Subnet Mask')){$this.SubnetMask = $NetInfo[$i].Substring($IpStartIndex,$NetInfo[$i].Length-$IpStartIndex);}
            }
            # this is the only place where isconnected turns true
            if(![String]::IsNullOrEmpty($this.DefaultGateway) -and ![String]::IsNullOrEmpty($this.SubnetMask)){$this.IsConnected = $true;} 
            # if(!$this.IsConnected){return $false;} # You are not connected TODO make logs
        }

    }
}