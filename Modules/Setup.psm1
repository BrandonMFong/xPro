
function _GetContents # static
{
    Param([xml]$x)
    Write-Host("Machine Name : $($x.Machine.MachineName)");
    Write-Host("Git Repository Directory : $($x.Machine.GitRepoDir)");
    Write-Host("Configuration File : $($x.Machine.ConfigFile)");
}

function _GetFullContent
{
    Param([string]$FileName)
    [String]$content = Get-Content $FileName;
    [String]$FirstLine = "<?xml version=`"1.0`" encoding=`"ISO-8859-1`"?>`n";
    [String]$FullContent = $FirstLine + $content;
    return $FullContent;
}
function _InitConfig
{
    [XML]$NewXml = [XML]::new();
    $Node_Machine = $NewXml.CreateElement("Machine");
    $Node_Machine.SetAttribute("MachineName",$env:COMPUTERNAME);
    $Node_GitRepoDir = $NewXml.CreateElement("GitRepoDir");
    $Node_ConfigFile = $NewXml.CreateElement("ConfigFile");
    $NewXml.AppendChild($Node_Machine);
    $NewXml.Machine.AppendChild($Node_GitRepoDir)
    $NewXml.Machine.AppendChild($Node_ConfigFile)
    $NewXml.Machine.GitRepoDir = $($PSScriptRoot | Split-Path -Parent).ToString();

    $x = Read-Host -Prompt "What do you want to do?`nCreate New Config[1]`nUse Existing Confg[2]`nSo"

    if ($x -eq 1)
    {
        [string]$name = Read-Host "Name the configuration file";
        New-Variable -Name "ConfigurationName" -Value $name -Scope Global -Force; # needs to be global for the other function
        $NewXml.Machine.ConfigFile = $($ConfigurationName + ".xml");
        Write-Host "`nPlease review:" -Foregroundcolor Cyan;
        _GetContents($NewXml);
        if($(Read-Host -Prompt "Approve? (y/n)") -eq "y")
        {
            [String]$FileName = $($PROFILE | Split-Path -Parent).ToString() + "\Profile.xml";
            $NewXml.Save($FileName);
            [String] $FullContent = _GetFullContent($FileName);
            $FullContent | Out-File $FileName;
        }
        else {throw "Please restart setup then."} # maybe call this function again

        _MakeConfig;
    }
    elseif($x -eq 2) 
    {
        [String]$FileName = $($PROFILE | Split-Path -Parent).ToString() + "\Profile.xml";
        $NewXml.Save($FileName);
        [String] $FullContent = _GetFullContent($FileName);
        $FullContent | Out-File $FileName;
        .\.\update-config.ps1;
    }
    else{Throw "Please Specify an option"}
}

function _InitProfile
{
    if(!(Test-Path $Profile))
    {
        New-Item -Path $Profile -Type File -Force;
        .\.\update-profile.ps1 -ForceUpdate $true;
        Write-Host "`nCreated Profile script!`n" -BackgroundColor Black -ForegroundColor Yellow;
    }
    else
    {
        .\.\update-profile.ps1 -ForceUpdate $true;
        Write-Host "`nProfile already exists!`n" -BackgroundColor Black -ForegroundColor Yellow;
    }
}

function _MakeConfig
{
    [XML]$File = [XML]::new();

    Import-Module $($PSScriptRoot + "\ConfigHandler.psm1");
    
    _MachineNode([ref]$File);

    _StartScriptNode([ref]$File);

    _ShellSettingsNode([ref]$File);
    
    _DirectoryNode([ref]$File);

    _ObjectsNode([ref]$File);

    _ProgramNode([ref]$File);

    _ModulesNode([ref]$File);

    _CalendarNode([ref]$File);

    $File.Save($($PSScriptRoot + '\..\Config\' + $ConfigurationName + '.xml'));
}