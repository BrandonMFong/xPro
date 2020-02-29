# Sets up config and profile 
Param
(
    [string]$ConfigName=$env:COMPUTERNAME, 
    [bool]$ProfConfigOverride=$false, 
    [bool]$GitConfigOverride=$false, 
    [bool]$ProfileOverride=$false
)

function Make-Config-At-Profile-Dir
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

function Make-Config-At-Git-Dir
{
    
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

        # Config at Profile Dir
        if($ProfConfigOverride)
        {
            Remove-Item .\Profile.xml -Verbose;
            Make-Config-At-Profile-Dir;
            exit;
        }    
        elseif((Test-Path .\Profile.xml) -and !($Override))
        {
            [xml]$xml = Get-Content .\Profile.xml;
            write-host "GitRepoDir: $($xml.Machine.GitRepoDir)";
            write-host "ConfigFile: $($xml.Machine.ConfigFile)";
            $prompt = Read-Host -Prompt ".\Profile.xml already exists.  Do you want to remove[r], change config[c], or nothing[n]?";
            if($prompt -eq "r"){Remove-Item .\Profile.xml -Verbose; Make-Config;}
            elseif($prompt -eq "c"){Invoke-Expression $($x.Machine.GitRepoDir + "\change-config.ps1");}
            elseif($prompt -eq "n"){Write-Warning "`nDoing nothing`n";}
            else{Write-Warning "`nDoing nothing`n";}
        }
        else{Make-Config;}

        # Config at Git Dir
        if($GitConfigOverride)
        {
            # Should be passed from script
            exit;
        }

        # Profile
        if($ProfileOverride)
        {
            Remove-Item .\Microsoft.PowerShell_profile.ps1 -Verbose;
            Make-Profile;
            exit;
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