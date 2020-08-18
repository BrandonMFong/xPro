<#
.Synopsis
   TODO describe
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = _GetXMLContent;
   [String]$FilePath = _GetXMLFilePath;
   
   <# UPDATE START #>
   
   foreach($Object in $xml.Machine.Objects.Object)
   {
      if(($Object.Type -eq "PowerShellClass") -and ($Object.Class.ClassName -eq "SQL"))
      {
         $Object.Class.SQL.SQLConvertFlags = $Object.Class.SQL.SQLConvertFlags.Replace("LinkGuid","Link"); # Change flags
         foreach($Table in $Object.Class.SQL.Tables.Table)
         {
            if($Table.Name -eq "TypeContent")
            {
               foreach($Row in $Table.Rows.Row)
               {
                  for([int16]$i = 0;$i -lt $Row.Value.Count;$i++)
                  {
                     if(($Row.Value[$i].ColumnName -eq "ExternalID") -and (($Row.Value[$i].InnerText -eq "LinkedObjectName") -or ($Row.Value[$i].InnerText -eq "LinkedObjectValue")))
                     {
                        $Row.ParentNode.RemoveChild($Row);
                     }
                  }
               }
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