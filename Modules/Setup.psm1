
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

    # <Machine>
    $Node_Machine = $File.CreateElement("Machine");
    $Node_Machine.SetAttribute("MachineName",$env:COMPUTERNAME);
    $Node_Machine.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    $Node_Machine.SetAttribute("xsi:noNamespaceSchemaLocation","..\Schema\Powershell.xsd");
    $File.AppendChild($Node_Machine);#Node

    ### <StartScript> ##
    $Node_StartScript = $File.CreateElement("StartScript");
    $Node_StartScript.SetAttribute("ClearHost","false");
    $File.Machine.AppendChild($Node_StartScript); # Append
    
    ## <Prompt> ##
    $Node_Prompt = $File.CreateElement("Prompt");
    # <DateFormat>
    $Node_DateFormat = $File.CreateElement("DateFormat");
    # <TimeFormat>
    $Node_TimeFormat = $File.CreateElement("TimeFormat");
    # String
    $Node_String = $File.CreateElement("String");
    $Node_String.SetAttribute("Color", "White");
    $Node_String.InnerXml = "Default";
    $Node_Prompt.AppendChild($Node_String);#Node
    $Node_Prompt.AppendChild($Node_TimeFormat);#Node
    $Node_Prompt.AppendChild($Node_DateFormat);#Node
    $File.Machine.AppendChild($Node_Prompt);

    ## Directories ##
    $Node_Directories = $File.CreateElement("Directories");
    # Directory
    $Node_Directory = $File.CreateElement("Directory");
    $Node_Directory.SetAttribute("alias", "GitRepo");
    $Node_Directory.SetAttribute("SecurityType", "public");
    $Node_Directory.InnerXml = $PSScriptRoot; # putting this dir in the xml
    $Node_Directories.AppendChild($Node_Directory);#Node
    $File.Machine.AppendChild($Node_Directories);

    # Objects
    $Node_Objects =  $File.CreateElement("Objects");
    $Node_Objects.SetAttribute("Database", "");
    $Node_Objects.SetAttribute("ServerInstance", "");
    # Object 
    $Node_Object = $File.CreateElement("Object");
    $Node_Object.SetAttribute("Type", "XmlElement");
    # VarName
    $Node_VarName = $File.CreateElement("VarName");
    $Node_VarName.SetAttribute("SecurityType","public");
    $Node_VarName.InnerXml = "User";
    # Values
    $Node_Value = $File.CreateElement("Value");
    # Key
    $Node_Key = $File.CreateElement("Key");
    $Node_Object.AppendChild($Node_Value);
    $Node_Object.AppendChild($Node_Key);
    $Node_Object.AppendChild($Node_VarName);
    $Node_Objects.AppendChild($Node_Object);
    $File.Machine.AppendChild($Node_Objects);

    # Programs
    $Node_Programs = $File.CreateElement("Programs");
    # Program
    $Node_Program = $File.CreateElement("Program");
    $Node_Program.SetAttribute("Alias", "");
    $Node_Program.SetAttribute("Type", "");
    $Node_Programs.AppendChild($Node_Program);
    $File.Machine.AppendChild($Node_Programs);
    
    # Modules
    $Node_Modules = $File.CreateElement("Modules");
    # Module
    $Node_Module = $File.CreateElement("Module");
    $Node_Modules.AppendChild($Node_Module);
    $File.Machine.AppendChild($Node_Modules);

    # Lists
    $Node_Lists = $File.CreateElement("Lists");
    # List
    $Node_List = $File.CreateElement("List");
    $Node_List.SetAttribute("Title", "");
    # Item
    $Node_Item = $File.CreateElement("Item");
    $Node_Item.SetAttribute("rank","");
    $Node_Item.SetAttribute("name","");
    $Node_Item.SetAttribute("Completed","");
    $Node_List.AppendChild($Node_Item);
    $Node_Lists.AppendChild($Node_List);
    $File.Machine.AppendChild($Node_Lists);

    # Calendar
    $Node_Calendar = $File.CreateElement("Calendar");

    # SpecialDays
    $Node_SpecialDays = $File.CreateElement("SpecialDays");

    # SpecialDay
    $Node_SpecialDay = $File.CreateElement("SpecialDay");
    $Node_Item.SetAttribute("name","New Years");
    $Node_SpecialDay.InnerXml = "1/1/2021";
    $Node_SpecialDays.AppendChild($Node_SpecialDay);
    $Node_Calendar.AppendChild($Node_SpecialDays);
    $File.Machine.AppendChild($Node_Calendar);

    [string]$Name = Read-Host "Please name Config file";
    $File.Save($($PSScriptRoot + '\..\Config\' + $Name + '.xml'));
}