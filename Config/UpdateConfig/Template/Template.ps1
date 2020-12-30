<#
.Synopsis
   TODO describe
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\xProUtilities.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
   <# UPDATE START #>


   <# UPDATE END #>
   
   [System.XML.XMLElement]$UpdateStamp = $xml.Machine.UpdateStamp;
   $UpdateStamp.SetAttribute("Value",$MyInvocation.MyCommand.Name.Replace('.ps1','')); # TODO put date
   $xml.Save($FilePath);
   $Executed.Value = $true;
}
catch
{
   $Global:LogHandler.WriteError($_);
   $Executed.Value = $false;
}