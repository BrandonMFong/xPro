Import-Module $($PSScriptRoot + "\xProUtilities.psm1");


if($PSVersionTable.PSVersion.Major -lt 7){Add-Type -assembly "Microsoft.Office.Interop.Outlook";}
else{Add-Type -AssemblyName $Global:XMLReader.Machine.Email.AssemblyPath;}

function InboxObject
{
    [System.Xml.XmlElement]$var = $(Get-Variable "XMLReader").Value.Machine.Email;
    $Outlook = New-Object -comobject Outlook.Application;
    $namespace = $Outlook.GetNameSpace("MAPI");
    if(![string]::IsNullOrEmpty($var.EmailAddress))
    {
        foreach($f in $namespace.Folders)
        {
            [String]$FullFolderPath = $f.FullFolderPath;
            if($FullFolderPath.Contains($(Evaluate -value $var.EmailAddress))) # Get Email
            {
                [System.MarshalByRefObject]$EmailFolder = $f;
                foreach($f in $EmailFolder.Folders)# Get the right folder
                {
                    if($f.FullFolderPath -eq "$($(Evaluate -value $var.EmailAddress) + $var.DefaultFolder)")
                    {
                        [System.MarshalByRefObject]$inbox = $f;break;
                    }
                }
                break;
            }
        }
    }
    else{[System.MarshalByRefObject]$inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)}
    return $inbox;
}