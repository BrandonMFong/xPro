<#
.Synopsis
   Adding security type to port config
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
      [int16]$i = 1;
      foreach($Network in $xml.Machine.Networks.Network)
      {
         foreach($Connection in $Network.Connection)
         {
            # if Type is not filled then create it
            if($Connection.Type -eq "SSH" -and [string]::IsNullOrEmpty($Connection.Port.SecType))
            {
               New-Variable -Name "Port$($i)" -Force -Value $Connection.SelectSingleNode("Port");
               $(Get-Variable -Name "Port$($i)").Value.SetAttribute("SecType","public");
               $i++;
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