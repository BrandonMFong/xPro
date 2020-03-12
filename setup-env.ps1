# Sets up config and profile 

function Make-Config-At-Profile-Dir([String]$GitRepoDir,[String]$ConfigName)
{
    Push-Location $($PROFILE |Split-Path -Parent);
        $XmlContent = 
            "<?xml version=`"1.0`" encoding=`"ISO-8859-1`"?>`n"+
            "   <Machine MachineName=`"$($env:COMPUTERNAME)`">`n"+
            "       <GitRepoDir>$($GitRepoDir)</GitRepoDir>`n"+
            "       <ConfigFile>$($ConfigName).xml</ConfigFile>`n"+
            "   </Machine>";
            New-Item Profile.xml -Value $XmlContent -Verbose;
    Pop-Location
}

function Make-Config-At-Git-Dir([String]$GitRepoDir,[String]$ConfigName)
{
    Push-Location $GitRepoDir
        Copy-Item .\Config\Template.xml .\Config\$($ConfigName).xml -Verbos;
    Pop-Location
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
    [String]$GitRepoDir = (Get-Location).Path;
    Get-ChildItem .\Profile.ps1 | ForEach-Object{[String]$ProfPath = $_.FullName;}
    [String]$ConfigName = $env:COMPUTERNAME;

        # Config at Profile Dir
        Make-Config-At-Profile-Dir($GitRepoDir,$ConfigName);

        # Config at Git Dir
        Make-Config-At-Git-Dir

        # Profile
        Make-Profile;
        
    Pop-Location
Pop-Location
