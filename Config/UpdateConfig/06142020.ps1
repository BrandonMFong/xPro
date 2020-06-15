<#
.Synopsis
   Adding Enabled to Git settings
#>
$error.Clear()
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = _GetXMLContent;
   [String]$FilePath = _GetXMLFilePath;
   
   <# UPDATE START #>
   
      if(![string]::IsNullOrEmpty($xml.Machine.Email))
      {
         [System.Xml.XmlNodeList]$AssemblyPath = $xml.SelectNodes("//Email");
         $AssemblyPath.SetAttribute("AssemblyPath","");
      }

   <# UPDATE END #>
   
   [System.XML.XMLElement]$UpdateStamp = $xml.Machine.UpdateStamp;
   [string[]]$Check = (Get-ChildItem $PSScriptRoot\*.*).Name; # Only update scripts here
   $UpdateStamp.SetAttribute("Value",$MyInvocation.MyCommand.Name.Replace('.ps1','')); # TODO put date
   $UpdateStamp.SetAttribute("Count",$Check.Count); # TODO get ride of this
   $xml.Save($FilePath);
   return [int]0;
}
catch{Write-Host "$($_)`n$($stacktrace)`n" -ForegroundColor Red; return [int]1;}