<#
.Synopsis
   Removing ID from sql flag config
   Adding TypeContentID, Link and PersonalInfoID
   Using delimiter = '|'
   Creating new column on PersonalInfo Table, 'ExternalID'
#>
$error.Clear()
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
         $Object.Class.SQL.SQLConvertFlags = $Object.Class.SQL.SQLConvertFlags.Replace("ID ",$null);
         if(!$Object.Class.SQL.SQLConvertFlags.Contains("TypeContentID")){$Object.Class.SQL.SQLConvertFlags += " TypeContentID";}
         $Object.Class.SQL.SQLConvertFlags = $Object.Class.SQL.SQLConvertFlags.Replace(" ", "|");
         if(!$Object.Class.SQL.SQLConvertFlags.Contains("PersonalInfoID")){$Object.Class.SQL.SQLConvertFlags += "|PersonalInfoID";}
         if(!$Object.Class.SQL.SQLConvertFlags.Contains("Link")){$Object.Class.SQL.SQLConvertFlags += "|Link";}

         # Add new column
         foreach($Table in $Object.Class.SQL.Tables.Table)
         {
            if($Table.Name -eq 'PersonalInfo')
            {
               [boolean]$HasColumn = $false;
               foreach($Column in $Table.Column)
               {
                  if($Column.Name -eq 'ExternalID'){$HasColumn = $true; break}
               }

               # Only do this if there is not a column
               if(!$HasColumn)
               {
                  [System.Xml.XmlNode]$NewColumn_ExternalID = $xml.CreateElement("Column"); # Create the node
                  $NewColumn_ExternalID.SetAttribute("Name","ExternalID");
                  $NewColumn_ExternalID.SetAttribute("Type","varchar(50)");
                  $NewColumn_ExternalID.SetAttribute("IsPrimaryKey","false");
                  $NewColumn_ExternalID.SetAttribute("IsForeignKey","false");
                  $NewColumn_ExternalID.SetAttribute("IsNull","true");
   
                  # Place node
                  # $parent = $Table.SelectSingleNode("//Rows");
                  $Table.InsertBefore($NewColumn_ExternalID,$Table.Rows);
               }
            }
         }
         break;
      }
   }
   <# UPDATE END #>
   
   [System.XML.XMLElement]$UpdateStamp = $xml.Machine.UpdateStamp;
   [string[]]$Check = (Get-ChildItem $PSScriptRoot\*.*).Name; # Only update scripts here
   $UpdateStamp.SetAttribute("Value",$MyInvocation.MyCommand.Name.Replace('.ps1','')); # TODO put date
   $UpdateStamp.SetAttribute("Count",$Check.Count); # TODO get ride of this
   $xml.Save($FilePath);
   return [int]0;
}
catch
{
   Write-Host "`nError in $($PSScriptRoot)\$($MyInvocation.MyCommand.Name) at line: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red;
   Write-Host "`n$($_.Exception)`n" -ForegroundColor Red;
   return [int]1;
}