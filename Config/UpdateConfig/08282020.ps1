<#
.Synopsis
   Adding type to ssh client path config
   Changing PathToEventImport to EventsFile
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = _GetXMLContent;
   [String]$FilePath = _GetXMLFilePath;
   
   <# UPDATE START #>

   if(![string]::IsNullOrEmpty($xml.Machine.Networks)) 
   {
      foreach($Network in $xml.Machine.Networks.Network)
      {
         foreach($Connection in $Network.Connection)
         {
            # if Type is not filled then create it
            if($Connection.Type -eq "SSH" -and [string]::IsNullOrEmpty($Connection.SSHClientPath.Type))
            {
               [system.xml.XMLElement]$SSHConfig = $Connection.SelectSingleNode("//SSHClientPath");
               $SSHConfig.SetAttribute("Type","Putty"); # From now and before it has always been putty 
            }
         }
      }
   }

   foreach($Object in $xml.Machine.Objects.Object)
   {
      if(($Object.Type -eq "PowerShellClass") -and ($Object.Class.ClassName -eq "Calendar"))
      {
         [System.Xml.XmlElement]$Cal = $Object.SelectSingleNode("//Calendar");
         [System.Xml.XmlElement]$EventsFile = $xml.CreateElement("EventsFile");
         if(![string]::IsNullOrEmpty($Cal.PathToEventImport))
         {
            $EventsFile.InnerText = $($Cal.PathToEventImport| Split-Path -Leaf);
            $Cal.AppendChild($EventsFile); # Add to the end 
            $Cal.RemoveChild($Cal.SelectSingleNode("//PathToEventImport")); # Remove
         }
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
   $Global:LogHandler.WriteError($_);
   $Executed.Value = $false;
}