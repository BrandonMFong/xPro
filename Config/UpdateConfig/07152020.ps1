<#
.Synopsis
   Upgrading from 'StartScript' node to 'Start' node
#>
$error.Clear()
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = _GetXMLContent;
   [String]$FilePath = _GetXMLFilePath;
   
   <# UPDATE START #>

   if([string]::IsNullOrEmpty($xml.Machine.Start)) # if the new node was not created
   {
      if(![string]::IsNullOrEmpty($xml.Machine.StartScript))
      {
         # Retrieve the previous settings
         [String]$StartScript = $xml.Machine.StartScript.InnerXml;
         [String]$Enabled = $xml.Machine.StartScript.Enabled;
         [String]$ClearHost = $xml.Machine.StartScript.ClearHost;

         # Delete old settings
         $xml.Machine.RemoveChild($xml.Machine.StartScript);
      }
      else 
      {
         [String]$StartScript = $null;
         [String]$Enabled = "False";
         [String]$ClearHost = "False";
      }
   
      # Transfer or create the settings
      [System.Xml.XmlNode]$NEW_Start = $xml.CreateElement("Start"); # Create the node
      $NEW_Start.SetAttribute("Enabled",$Enabled);
      $NEW_Start.SetAttribute("ClearHost",$ClearHost);
      [System.Xml.XmlNode]$NEW_Script = $xml.CreateElement("Script"); # Create the node
      $NEW_Script.InnerXml = $StartScript;
      $NEW_Start.AppendChild($NEW_Script);

      # Placing the node after the UpdateStamp node
      $parent = $xml.SelectSingleNode("//Machine");
      $parent.InsertAfter($NEW_Start,$xml.Machine.UpdateStamp);
   }

   <# UPDATE END #>
   
   [System.XML.XMLElement]$UpdateStamp = $xml.Machine.UpdateStamp;
   [string[]]$Check = (Get-ChildItem $PSScriptRoot\*.*).Name; # Only update scripts here
   $UpdateStamp.SetAttribute("Value",$MyInvocation.MyCommand.Name.Replace('.ps1','')); # TODO put date
   $UpdateStamp.SetAttribute("Count",$Check.Count); # TODO get ride of this
   $xml.Save($FilePath);
   return [int]0;
}
catch
{
   Write-Host "`nError in $($PSScriptRoot)\$($MyInvocation.MyCommand.Name) at line: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red;
   Write-Host "`n$($_.Exception)`n" -ForegroundColor Red;
   return [int]1;
}