# This should be the file to write into an xml on the dir where the profile is
Write-Host " Setting GitRepoDir Node to " (pwd).Path;
$GitRepoDir = (pwd).Path;
Push-Location $($PROFILE |Split-Path -Parent);
    $XmlContent = 
    "<?xml version=`"1.0`" encoding=`"ISO-8859-1`"?> 
<Machine MachineName=`"$($env:COMPUTERNAME)`">
    <GitRepoDir>$($GitRepoDir)</GitRepoDir>
    <ConfigFile>$($env:COMPUTERNAME).xml</ConfigFile>
</Machine>
    ";
    New-Item Profile.xml -Value $XmlContent;

    # TODO figure out how to add content view xml methods
    # New-Item Profile.xml -Value "<?xml version=`"1.0`" encoding=`"ISO-8859-1`"?> `n<Machine MachineName=`"$($env:COMPUTERNAME)`">`n</Machine>" | 
    #     Where-Object{$Filename = $_.Name;}   
    # [System.XML.XmlDocument]$x = Get-Content $Filename;
    # # $NewElementName = $x.CreateElement("GitRepDir");
    # $NewElement = $x.Machine.AppendChild($x.CreateElement("GitRepDir"))
    # $NewTextNode = $NewElement.AppendChild($x.CreateTextNode($GiRepoDir))
    # $x.Save($Filename);
Pop-Location