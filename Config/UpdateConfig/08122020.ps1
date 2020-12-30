<#
.Synopsis
   Rearranging GitSettings node
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\xProUtilities.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
   <# UPDATE START #>
   if(![string]::IsNullOrEmpty($xml.Machine.GitSettings))
   {
      [System.Xml.XmlElement]$Repository = $xml.CreateElement("Repository");
      $Repository.SetAttribute("FilePath",""); # If empty then this is default for all repos
      $Repository.InnerXml = $xml.Machine.GitSettings.InnerXml;
      $xml.Machine.GitSettings.InnerXml = $null; # Deleting all content in the innerxml
      
      [System.Xml.XmlNodeList]$GitSettings = $xml.SelectNodes("//GitSettings");
      $GitSettings.AppendChild($Repository);
   }
   <# UPDATE END #>
   
   [System.XML.XMLElement]$UpdateStamp = $xml.Machine.UpdateStamp;
   $UpdateStamp.SetAttribute("Value",$MyInvocation.MyCommand.Name.Replace('.ps1','')); # TODO put date
   $xml.Save($FilePath);
   $Executed.Value = $true;
}
catch
{
   # Write-Host "`nError in $($PSScriptRoot)\$($MyInvocation.MyCommand.Name) at line: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red;
   # Write-Host "`n$($_.Exception)`n" -ForegroundColor Red;
   $Global:LogHandler.WriteError($_);
   $Executed.Value = $false;
}