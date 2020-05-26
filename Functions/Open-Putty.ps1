<#
.Synopsis
    Opens putty from the script
.Description
    
.Example
    ssh.json sample:
    {
    "Servers": [{
            "Server": {
                "Name": "Server Name",
                "Username": "",
                "Password": "",
                "sshkeyPath": "Path\\to\\file.ppk",
                "IP": "",
                "Port": "22",
                "HostKey": ""
            }
        }
    ]
}

.Notes
    Must have ssh.json configured
#>
param
(
    [Parameter(Mandatory)]
    [ValidateSet('Hostinger','kojami')]
    [string]$Server
)
$JSONReader = Get-Content $PSScriptRoot\..\config\ssh.json|Out-String|ConvertFrom-Json
[boolean]$Found = $false;
[PSCustomObject]$creds;
foreach($j in $JSONReader.Servers.Server)
{
    if($j.Name -eq $Server){$creds = $j;$Found = $true;break;}
}
if(!$Found){throw "Server Not configured!";}
if($creds.name -eq 'Hostinger'){putty -ssh "$($creds.Username)@$($creds.IP)" $creds.Port -i $creds.sshkeyPath -pw $creds.Password;}
if($creds.name -eq 'kojami'){putty -ssh "$($creds.Username)@$($creds.IP)" $creds.Port -pw $creds.Password;}