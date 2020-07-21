<#
.Synopsis
   Setting Secure to FALSE
   Must redo the credentials
   Removing Count attribute from updatestamp node
#>
$error.Clear()
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = _GetXMLContent;
   [String]$FilePath = _GetXMLFilePath;
   
   <# UPDATE START #>

   if(![string]::IsNullOrEmpty($xml.Machine.ShellSettings.Security.Secure))
   {
      $xml.Machine.ShellSettings.Security.Secure = "False";
   }

   if(![string]::IsNullOrEmpty($xml.Machine.UpdateStamp.Count))
   {
      $xml.Machine.UpdateStamp.RemoveAttribute($xml.Machine.UpdateStamp.Count);
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