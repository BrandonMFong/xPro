<#
.Synopsis
   Adding Enabled to Git settings
#>

Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
[System.Xml.XmlDocument]$xml = _GetXMLContent;

<# Update Code #>
if($(Read-Host -Prompt "Enable git(y/n)?") -eq "y"){[string]$var1 = "True";}
else{[string]$var1 = "False";}
[System.Xml.XmlNode]$GitEnabler = $xml.CreateAttribute("Enabled",$var1);
[System.Xml.XmlNodeList]$GitSettings = $xml.SelectNodes("//GitSettings");
$GitSettings.SetAttributes($GitEnabler);

$xml.Save();