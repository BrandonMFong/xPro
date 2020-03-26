
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
    Write-Host("Configuration File : $($x.Machine.GitRepoDir)");
}
function InitPointer
{
    while(($x -ne 'y') -and ($x -ne 'n'))
    {
        $x = Read-Host -Prompt "Do you want to create your own config (y) or use another in the directory(n)?"
    }

    if ($x -eq 'y')
    {
        [XML]$NewXml = MakeXMLFile;
        GetContents($NewXml);
        if($(Read-Host -Prompt "Approve? (y/n)") -eq "y")
        {
            $NewXml.Save($($PRFOILE | Split-Path -Parent).ToString() + "\Profile.xml");
        }
        else {throw "Please restart setup then."} # maybe call this function again
    }
    else 
    {
        [Xml]$NewXml = MakeXMLFile;
        $NewXml.Save($($PRFOILE | Split-Path -Parent).ToString() + "\Profile.xml");
        .\.\update-config.ps1;
    }
}

function InitProfile
{
    if(Test-Path $Profile)
    {
        New-Item –Path $Profile –Type File –Force
    }
}

function InitConfig
{
    [XML]$File = [XML]::new();

    # <Machine>
    $Node_Machine = $File.CreateElement("Machine");
    $Node_Machine.SetAttribute("MachineName",$env:COMPUTERNAME);
    $Node_Machine.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    $Node_Machine.SetAttribute("xsi:noNamespaceSchemaLocation","..\Schema\Powershell.xsd");
    $File.AppendChild($Node_Machine);

    # <StartScript>
    $Node_StartScript = $File.CreateElement("StartScript");
    $Node_StartScript.SetAttribute("ClearHost","false");
    New-Item $($($PSScriptRoot|Split-Path -Parent) + "\StartScripts\" + $env:COMPUTERNAME + "ps1") -Value "Echo Hello World";
    $File.Machine.AppendChild($Node_StartScript);
    $File.Machine.StartScript = $($($PSScriptRoot|Split-Path -Parent) + "\StartScripts\" + $env:COMPUTERNAME + "ps1");

    
}