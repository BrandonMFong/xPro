<#
.Synopsis
   Including PersonalInfoID in SQLConvertFlags and adding new table
#>
$error.Clear()
try 
{
   Import-Module $($PSScriptRoot + "\..\..\Modules\FunctionModules.psm1") -Scope Local;
   [System.Xml.XmlDocument]$xml = _GetXMLContent;
   [String]$FilePath = _GetXMLFilePath;
   
   <# UPDATE START #>
      [String]$XmlString = 
      "
         <Table Name=`"LinkInfo`">
            <Column Name=`"ID`" Type=`"int`" IsPrimaryKey=`"true`" IsForeignKey=`"false`" IsNull=`"false`" />
            <Column Name=`"ExternalID`" Type=`"varchar(200)`" IsPrimaryKey=`"false`" IsForeignKey=`"false`" IsNull=`"true`" />
            <Column Name=`"LinkGuid`" Type=`"uniqueidentifier`" IsPrimaryKey=`"false`" IsForeignKey=`"false`" IsNull=`"false`" />
            <Column Name=`"StartDate`" Type=`"datetime`" IsPrimaryKey=`"false`" IsForeignKey=`"false`" IsNull=`"true`" />
            <Column Name=`"LastAccessDate`" Type=`"datetime`" IsPrimaryKey=`"false`" IsForeignKey=`"false`" IsNull=`"true`" />
            <Column Name=`"Hash`" Type=`"varchar(200)`" IsPrimaryKey=`"false`" IsForeignKey=`"false`" IsNull=`"true`" />
            <Column Name=`"PersonalInfoID`" Type=`"int`" IsPrimaryKey=`"false`" IsForeignKey=`"true`" IsNull=`"false`">
               <ForeignKeyRef>
               <![CDATA[
                  {
                     `"ForeignTable`": `"PersonalInfo`",
                     `"ForeignColumn`": `"ID`"
                  }
               ]]>
               </ForeignKeyRef>
            </Column>
         </Table>
      ";
      [System.Xml.XmlNode]$NewTable = [XML]$XmlString;

      foreach($Object in $xml.Machine.Objects.Object)
      {
         if(($Object.Type -eq "PowerShellClass") -and ($Object.Class.ClassName -eq "SQL"))
         {
            Write-Host "Adding LinkInfo table and including PersonalInfoID and LinkGuid in SQLConvertFlags`n" -ForegroundColor Gray;
            $Object.Class.SQL.SQLConvertFlags += " PersonalInfoID LinkGuid";
            $Tables = $Object.SelectNodes("//Tables"); # I do not know the specific type this object is
            [System.Xml.XmlLinkedNode]$import = $xml.ImportNode($NewTable.DocumentElement,$true)
            $Tables.AppendChild($import);
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
catch{Write-Host "$($_)`n$($stacktrace)`n" -ForegroundColor Red; return [int]1;}