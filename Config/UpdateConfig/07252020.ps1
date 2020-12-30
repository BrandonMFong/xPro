<#
.Synopsis
   Changing GitSettings to GitDisplay
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\xProUtilities.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
   <# UPDATE START #>
   if(![string]::IsNullOrEmpty($xml.Machine.ShellSettings.GitSettings))
   {
      [System.Xml.XmlElement]$GitDisplay = $xml.CreateElement("GitDisplay");
      [System.Xml.XmlElement]$Unstaged = $xml.CreateElement("Unstaged");
      [System.Xml.XmlElement]$Staged = $xml.CreateElement("Staged");
      [System.Xml.XmlElement]$Commits = $xml.CreateElement("Commits");
      $Unstaged.InnerText = $xml.Machine.ShellSettings.GitSettings.Unstaged;
      $Staged.InnerText = $xml.Machine.ShellSettings.GitSettings.Staged;
      $Commits.InnerText = $xml.Machine.ShellSettings.GitSettings.Commits;
      $GitDisplay.SetAttribute("Enabled",$xml.Machine.ShellSettings.GitSettings.Enabled);
      $xml.Machine.ShellSettings.RemoveChild($xml.Machine.ShellSettings.GitSettings);
      $GitDisplay.AppendChild($Unstaged);
      $GitDisplay.AppendChild($Staged);
      $GitDisplay.AppendChild($Commits);
      $xml.Machine.ShellSettings.InsertBefore($GitDisplay,$xml.Machine.ShellSettings.Security);
   }


   <# UPDATE END #>
   
   [System.XML.XMLElement]$UpdateStamp = $xml.Machine.UpdateStamp;
   $UpdateStamp.SetAttribute("Value",$MyInvocation.MyCommand.Name.Replace('.ps1','')); # TODO put date
   $xml.Save($FilePath);
   $Executed.Value = $true;
}
catch
{
   Write-Host "`nError in $($PSScriptRoot)\$($MyInvocation.MyCommand.Name) at line: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red;
   Write-Host "`n$($_.Exception)`n" -ForegroundColor Red;
   $Executed.Value = $false;
}