<#
.Synopsis
   Adding Enabled to Git settings
#>

Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
[System.Xml.XmlDocument]$xml = _GetXMLContent;

