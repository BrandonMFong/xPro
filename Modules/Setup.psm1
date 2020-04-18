
function MakeXMLFile
{
    [XML]$File = [XML]::new();
    $Node_Machine = $File.CreateElement("Machine");
    $Node_Machine.SetAttribute("MachineName",$env:COMPUTERNAME);
    $Node_GitRepoDir = $File.CreateElement("GitRepoDir");
    $Node_ConfigFile = $File.CreateElement("ConfigFile");
    $File.AppendChild($Node_Machine);
    $File.Machine.AppendChild($Node_GitRepoDir)
    $File.Machine.AppendChild($Node_ConfigFile)
    $File.Machine.GitRepoDir = $($PSScriptRoot | Split-Path -Parent).ToString();
    $File.Machine.ConfigFile = $($env:COMPUTERNAME.ToString() + ".xml");
    return $File;
}

function GetContents # static
{
    Param([xml]$x)
    Write-Host("Machine Name : $($x.Machine.MachineName)");
    Write-Host("Git Repository Directory : $($x.Machine.GitRepoDir)");
    Write-Host("Configuration File : $($x.Machine.ConfigFile)");
}
function InitConfig
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
        New-Variable -Name "ConfigurationName" -Value $name -Scope Global; # needs to be global for the other function
        $NewXml.Machine.ConfigFile = $($ConfigurationName);
        Write-Host "`nPlease review:" -Foregroundcolor Cyan;
        GetContents($NewXml);
        if($(Read-Host -Prompt "Approve? (y/n)") -eq "y")
        {
            $NewXml.Save($($PROFILE | Split-Path -Parent).ToString() + "\Profile.xml");
        }
        else {throw "Please restart setup then."} # maybe call this function again

        MakeConfig;
    }
    elseif($x -eq 2) 
    {
        $NewXml.Save($($PRFOILE | Split-Path -Parent).ToString() + "\Profile.xml");
        .\.\update-config.ps1;
    }
    else{Throw "Please Specify an option"}
}

function InitProfile
{
    if(!(Test-Path $Profile))
    {
        New-Item -Path $Profile -Type File -Force;
        Write-Host "`nCreated Profile script!`n" -BackgroundColor Black -ForegroundColor Yellow;
    }
    else
    {
        Write-Host "`nProfile already exists!`n" -BackgroundColor Black -ForegroundColor Yellow;
    }
}

function MakeConfig
{
    [XML]$File = [XML]::new();

    Import-Module $($PSScriptRoot + "\ConfigHandler.psm1");
    
    MachineNode([ref]$File);

    StartScriptNode([ref]$File);

    PromptNode([ref]$File);

    DirectoryNode([ref]$File);

    ObjectsNode([ref]$File);

    ProgramNode([ref]$File);

    ModulesNode([ref]$File);

    ListNode([ref]$File);

    CalendarNode([ref]$File);

    $File.Save($($PSScriptRoot + '\..\Config\' + $ConfigurationName + '.xml'));
}