# Sets up config and profile 
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
    if (!(Test-Path $($PROFILE | Split-Path -Parent)))
    {
        mkdir $($PROFILE | Split-Path -Parent) -Force -Verbose;
    }
    Copy-Item $ProfPath . -Verbose;
    Rename-Item .\Profile.ps1 $($PROFILE|Split-Path -Leaf) -Verbose;
}

Push-Location $PSScriptRoot
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
            [xml]$xml = Get-Content .\Profile.xml;
            write-host "GitRepoDir: $($xml.Machine.GitRepoDir)";
            write-host "ConfigFile: $($xml.Machine.ConfigFile)";
            $prompt = Read-Host -Prompt ".\Profile.xml already exists.  Do you want to remove[r] or change config[c]?";
            if($prompt -eq "r"){Remove-Item .\Profile.xml -Verbose; Make-Config;}
            elseif($prompt -eq "c"){Invoke-Expression $($x.Machine.GitRepoDir + "\change-config.ps1");}
            else{Write-Warning "`nDoing nothing`n";}
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
            else{Write-Warning "`nDoing nothing`n";}
        }
        else{Make-Profile;}
    Pop-Location
Pop-Location