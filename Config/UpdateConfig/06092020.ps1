<#
.Synopsis
   Adding Enabled to Git settings
#>
$error.Clear()
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\xProUtilities.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
   <# UPDATE START #>

      # Create Git Settings
      [string]$var1 = "False";
      [System.Xml.XmlNodeList]$GitSettings = $xml.SelectNodes("//GitSettings");
      $GitSettings.SetAttribute("Enabled",$var1);

   <# UPDATE END #>
   
   [System.XML.XMLElement]$UpdateStamp = $xml.Machine.UpdateStamp;
   [string[]]$Check = (Get-ChildItem $PSScriptRoot\*.*).Name; # Only update scripts here
   $UpdateStamp.SetAttribute("Value","06092020"); # TODO put date
   $UpdateStamp.SetAttribute("Count",$Check.Count); # TODO get ride of this
   $xml.Save($FilePath);
   return 0;
}
catch{Write-Host "$($_)`n$($stacktrace)`n" -ForegroundColor Red; return 1;}