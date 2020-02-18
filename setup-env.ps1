# This should be the file to write into an xml on the dir where the profile is
Param
(
    [string]$ConfigName=$env:COMPUTERNAME, 
    [bool]$XmlOverride=$false, 
    [bool]$ProfileOverride=$false
)

function Make-Config
{
    $XmlContent = 
        "<?xml version=`"1.0`" encoding=`"ISO-8859-1`"?>`n"+
        "   <Machine MachineName=`"$($env:COMPUTERNAME)`">`n"+
        "       <GitRepoDir>$($GitRepoDir)</GitRepoDir>`n"+
        "       <ConfigFile>$($ConfigName).xml</ConfigFile>`n"+
        "   </Machine>";
        New-Item Profile.xml -Value $XmlContent -Verbose;

        # TODO figure out how to add content view xml methods
}

function Make-Profile
{
    Copy-Item $ProfPath . -Verbose;
    Rename-Item .\Profile.ps1 $($PROFILE|Split-Path -Leaf) -Verbose;
}

Push-Location $PSScriptRoot
    Write-Host "Setting GitRepoDir Node to " (Get-Location).Path;
    $GitRepoDir = (Get-Location).Path;
    Get-ChildItem .\Profile.ps1 | ForEach-Object{[String]$ProfPath = $_.FullName;}
    Push-Location $($PROFILE |Split-Path -Parent);

        # Config
        if($XmlOverride)
        {
            Remove-Item .\Profile.xml -Verbose;
            Make-Config;
        }    
        elseif((Test-Path .\Profile.xml) -and !($Override))
        {
            Write-Host "This is what is currently in the .\Profile.xml"
            Get-Content .\Profile.xml;
            $prompt = Read-Host -Prompt ".\Profile.xml already exists.  Do you want to remove? (y/n)";
            if($prompt -eq "y"){Remove-Item .\Profile.xml -Verbose; Make-Config;}
        }
        else{Make-Config;}

        # Profile
        if($ProfileOverride)
        {
            Remove-Item .\Microsoft.PowerShell_profile.ps1 -Verbose;
            Make-Profile;
        }
        elseif(Test-Path .\Microsoft.PowerShell_profile.ps1)
        {
            $prompt = Read-Host -Prompt ".\Microsoft.PowerShell_profile.ps1 already exists.  Do you want to remove? (y/n)";
            if($prompt -eq "y"){Remove-Item .\Microsoft.PowerShell_profile.ps1 -Verbose; Make-Profile;} 
        }
        else{Make-Profile;}
    Pop-Location
Pop-Location