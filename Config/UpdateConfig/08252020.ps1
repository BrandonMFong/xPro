<#
.Synopsis
   ID on ssh connection 
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
   <# UPDATE START #>
   if(![string]::IsNullOrEmpty($xml.Machine.Networks)) 
   {
      foreach($Network in $xml.Machine.Networks.Network)
      {
         foreach($Connection in $Network.Connection)
         {
            if($Connection.Type -eq "SSH")
            {
               [System.Xml.XmlElement]$ID = $xml.CreateElement("ID");
               $Connection.InsertBefore($ID,$Connection.IPAddress);
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