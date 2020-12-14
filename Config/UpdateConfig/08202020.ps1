<#
.Synopsis
   Restructuring Network config
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
   <# UPDATE START #>
   # To insert after ref 07152020.ps1
   # Netdrives node is the source of this change
   # There is more context to netdrives then just drives 
   if(![string]::IsNullOrEmpty($xml.Machine.NetDrives)) # If netdrives is configured
   {
      [System.Xml.XmlElement]$NEW_Networks = $xml.CreateElement("Networks"); # Create networks node
      foreach($NetDrive in $xml.Machine.Netdrives.NetDrive)
      {
         [System.Xml.XmlElement]$NEW_Network = $xml.CreateElement("Network"); # Create network node
         foreach($Connection in $NetDrive.Connection)
         {
            if($Connection.Type -eq "Putty")
            {
               $Connection.Type = "SSH";
               [System.Xml.XmlElement]$NEW_SSHClientPath = $xml.CreateElement("SSHClientPath"); # Create network node
               $NEW_SSHClientPath.InnerText = $Connection.PuttyPath;
               $Connection.RemoveChild($Connection.SelectSingleNode("//PuttyPath"));
               $Connection.AppendChild($NEW_SSHClientPath);
            }
         }
         $NEW_Network.InnerXml = $NetDrive.InnerXml; # transfer innerxml 
         [System.Xml.XmlElement]$NEW_LANConfig = $xml.CreateElement("LANConfig"); # Create network node
         $NEW_Network.AppendChild($NEW_LANConfig); # Netconfig File path.  For wifi 
         $NEW_Networks.AppendChild($NEW_Network);
      }
      # Placing the node after the UpdateStamp node
      $parent = $xml.SelectSingleNode("//Machine");
      # Replace netdrives with networks
      $parent.InsertAfter($NEW_Networks,$xml.Machine.Netdrives);
      $xml.Machine.RemoveChild($xml.Machine.Netdrives); # removing the netdrives config
   }
   

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