<#
.Synopsis
   Adding type to ssh client path config
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
            if($Connection.Type -eq "SSH")
            {
               [system.xml.XMLElement]$SSHConfig = $Connection.SelectSingleNode("//SSHClientPath");
               $SSHConfig.SetAttribute("Type","Putty"); # From now and before it has always been putty 
            }
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