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
      foreach($Object in $xml.Machine.Objects.Object)
      {
         if(($Object.Type -eq "PowerShellClass") -and ($Object.Class.ClassName -eq "Web"))
         {
            $Object.ParentNode.RemoveChild($Object); # Removing element
            break;
         }
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