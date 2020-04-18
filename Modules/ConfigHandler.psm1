
function MachineNode([ref]$File)
{
    # <Machine>
    $Node_Machine = $File.Value.CreateElement("Machine");
    $Node_Machine.SetAttribute("MachineName",$env:COMPUTERNAME);
    $Node_Machine.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    $Node_Machine.SetAttribute("xsi:noNamespaceSchemaLocation","..\Schema\Powershell.xsd");
    $File.Value.AppendChild($Node_Machine);#Node
}

function StartScriptNode([ref]$File)
{
    ### <StartScript> ##
    $Node_StartScript = $File.Value.CreateElement("StartScript");
    $Node_StartScript.SetAttribute("ClearHost","false");
    $Node_StartScript.SetAttribute("Enable","false");
    $File.Value.Machine.AppendChild($Node_StartScript); # Append
}

function PromptNode([ref]$File)
{
    ## <Prompt> ##
    $Node_Prompt = $File.Value.CreateElement("Prompt");
    # <DateFormat>
    $Node_DateFormat = $File.Value.CreateElement("DateFormat");
    # <TimeFormat>
    $Node_TimeFormat = $File.Value.CreateElement("TimeFormat");
    # BaterryLifeThreshold
    $Node_BaterryLifeThreshold = $File.Value.CreateElement("BaterryLifeThreshold");
    # String
    $Node_String = $File.Value.CreateElement("String");
    $Node_String.SetAttribute("Color", "White");
    $Node_String.InnerXml = "Default";
    $Node_BaterryLifeThreshold.SetAttribute("Enabled", "true");
    $Node_BaterryLifeThreshold.InnerXml = "35";
    $Node_Prompt.AppendChild($Node_DateFormat);#Node
    $Node_Prompt.AppendChild($Node_TimeFormat);#Node
    $Node_Prompt.AppendChild($Node_String);#Node
    $Node_Prompt.AppendChild($Node_BaterryLifeThreshold);#Node
    $File.Value.Machine.AppendChild($Node_Prompt);
}

function DirectoryNode([ref]$File)
{
    ## Directories ##
    $Node_Directories = $File.Value.CreateElement("Directories");
    # Directory
    $Node_Directory = $File.Value.CreateElement("Directory");
    $Node_Directory.SetAttribute("alias", "GitRepo");
    $Node_Directory.SetAttribute("SecurityType", "public");
    $Node_Directory.InnerXml = $PSScriptRoot; # putting this dir in the xml
    $Node_Directories.AppendChild($Node_Directory);#Node
    $File.Value.Machine.AppendChild($Node_Directories);
}

function ObjectsNode([ref]$File)
{
    # Objects
    $Node_Objects =  $File.Value.CreateElement("Objects");
    $Node_Objects.SetAttribute("Database", "");
    $Node_Objects.SetAttribute("ServerInstance", "");
    # Object 
    $Node_Object = $File.Value.CreateElement("Object");
    $Node_Object.SetAttribute("Type", "XmlElement");
    # VarName
    $Node_VarName = $File.Value.CreateElement("VarName");
    $Node_VarName.SetAttribute("SecurityType","public");
    $Node_VarName.InnerXml = "User";
    # Values
    $Node_Value = $File.Value.CreateElement("Value");
    # Key
    $Node_Key = $File.Value.CreateElement("Key");
    $Node_Object.AppendChild($Node_VarName);
    $Node_Object.AppendChild($Node_Key);
    $Node_Object.AppendChild($Node_Value);
    $Node_Objects.AppendChild($Node_Object);
    $File.Value.Machine.AppendChild($Node_Objects);
}

function ProgramNode([ref]$File)
{
    # Programs
    $Node_Programs = $File.Value.CreateElement("Programs");
    # Program
    $Node_Program = $File.Value.CreateElement("Program");
    $Node_Program.SetAttribute("Alias", "");
    $Node_Program.SetAttribute("Type", "");
    $Node_Programs.AppendChild($Node_Program);
    $File.Value.Machine.AppendChild($Node_Programs);
}

function ModulesNode([ref]$File)
{
    # Modules
    $Node_Modules = $File.Value.CreateElement("Modules");
    # Module
    $Node_Module = $File.Value.CreateElement("Module");
    $Node_Modules.AppendChild($Node_Module);
    $File.Value.Machine.AppendChild($Node_Modules);
}

function ListNode([ref]$File)
{
    # Lists
    $Node_Lists = $File.Value.CreateElement("Lists");
    # List
    $Node_List = $File.Value.CreateElement("List");
    $Node_List.SetAttribute("Title", "");
    # Item
    $Node_Item = $File.Value.CreateElement("Item");
    $Node_Item.SetAttribute("rank","");
    $Node_Item.SetAttribute("name","");
    $Node_Item.SetAttribute("Completed","");
    $Node_Item.SetAttribute("name","New Years");
    $Node_List.AppendChild($Node_Item);
    $Node_Lists.AppendChild($Node_List);
    $File.Value.Machine.AppendChild($Node_Lists);
}

function CalendarNode([ref]$File)
{
    # Calendar
    $Node_Calendar = $File.Value.CreateElement("Calendar");
    # SpecialDays
    $Node_SpecialDays = $File.Value.CreateElement("SpecialDays");
    # SpecialDay
    $Node_SpecialDay = $File.Value.CreateElement("SpecialDay");
    $Node_SpecialDay.InnerXml = "1/1/2021";
    $Node_SpecialDays.AppendChild($Node_SpecialDay);
    $Node_Calendar.AppendChild($Node_SpecialDays);
    $File.Value.Machine.AppendChild($Node_Calendar);
}