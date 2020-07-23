<#
.Synopsis
    Opens putty from the script
#>
param
(
    [string]$Hostname=$null
)
if([string]::IsNullOrEmpty($Hostname)){$Hostname = $(Read-Host -Prompt "Please provide NetDrive hostname from configuration");}
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
[System.Xml.XmlDocument]$xml = _GetXMLContent;
# [boolean]$Found = $false;
[PSCustomObject]$creds;
foreach($NetDrive in $xml.Machine.NetDrives.NetDrive)
{
    if($NetDrive.HostName -eq $Hostname)
    {
        foreach($Connection in $NetDrive.Connection)
        {
            if($Connection.Type -eq "Putty")
            {
                Set-Alias -Name "Putty" -Value $Connection.PuttyPath
                Putty -ssh "$(Evaluate -value:$Connection.Username)@$(Evaluate -value:$Connection.IPAddress)" $(Evaluate -value:$Connection.Port) -pw $(Evaluate -value:$Connection.Password);
            }
        }
    }
}