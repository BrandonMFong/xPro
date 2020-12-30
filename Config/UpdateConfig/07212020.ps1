<#
.Synopsis
   Delete count attribute
   Rearranging Netdrives node
      Adding Connection node
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\xProUtilities.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
   <# UPDATE START #>
   
   # Delete count node
   if(![string]::IsNullOrEmpty($xml.Machine.UpdateStamp.Count))
   {
      [System.Xml.XmlNodeList]$u = $xml.SelectNodes("//UpdateStamp");
      $u.RemoveAttribute("Count"); # This is not working
   }

   # New node
   if(![string]::IsNullOrEmpty($xml.Machine.NetDrives))
   {
      if([string]::IsNullOrEmpty($xml.Machine.NetDrives.NetDrive.Connection))
      {
         [System.Xml.XmlElement]$NewNetDrive = $xml.CreateElement("NetDrive");
         foreach($NetDrive in $xml.Machine.NetDrives.NetDrive)
         {
            # Transfer nodes
            [System.Xml.XmlElement]$Connection = $xml.CreateElement("Connection");
            $Connection.SetAttribute("Type","NetworkShare"); # Netdrive node was always for Networkshare
            $Connection.InnerXml = $NetDrive.InnerXml;
            
            [System.Xml.XmlElement]$NewNetDrive = $xml.CreateElement("NetDrive");
            $NewNetDrive.SetAttribute("HostName","");
            $NewNetDrive.AppendChild($Connection);
            $xml.Machine.NetDrives.RemoveChild($NetDrive);
         }
         [System.Xml.XmlNodeList]$NetDrives = $xml.SelectNodes("//NetDrives");
         $NetDrives.AppendChild($NewNetDrive);
      }
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