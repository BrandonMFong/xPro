<#
.Synopsis
   Adding Cache Count to Git Display terminal settings
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
   <# UPDATE START #>
   if(![string]::IsNullOrEmpty($xml.Machine.ShellSettings.GitDisplay))
   {
      [System.Xml.XmlElement]$GitDisplay = $xml.Machine.ShellSettings.GitDisplay;
      [System.Xml.XmlElement]$CacheCount = $xml.CreateElement("CacheCount");
      $CacheCount.InnerText = 10; # Default is 10
      $GitDisplay.AppendChild($CacheCount);# New element
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