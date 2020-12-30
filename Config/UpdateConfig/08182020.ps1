<#
.Synopsis
   Removing LinkedObjectName & LinkedObjectValue from typecontent config
   Adding Phone Number to Typecontent config
#>
Param([ref]$Executed)
$error.Clear();
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\xProUtilities.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
   [String]$FilePath = $(_GetUserConfig -Path);
   
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
               # Delete type content
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

               # Adding Phone Number
               [System.Xml.XmlElement]$NewRow = $xml.CreateElement("Row");
               [System.Xml.XmlElement]$ValueDescription = $xml.CreateElement("Value");
               $ValueDescription.SetAttribute("ColumnName","Description");
               $ValueDescription.InnerText = "Phone Number";
               [System.Xml.XmlElement]$ValueExternalID = $xml.CreateElement("Value");
               $ValueExternalID.SetAttribute("ColumnName","ExternalID");
               $ValueExternalID.InnerText = "PhoneNumber";
               $NewRow.AppendChild($ValueDescription);
               $NewRow.AppendChild($ValueExternalID);
               $Table.Rows.AppendChild($NewRow); # Adding new row to config
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