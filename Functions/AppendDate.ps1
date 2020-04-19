<#
.Synopsis
   Appends a date string to specified files
.Description
   Can either either specify one file to append or apply to all files in the directory
.Parameter FileDate
    TODO needs work
.Parameter FileName
    Pass file through this parameter to appy this function on
.Example
   Append -FileName Name.txt
   Result: Name_MMddyyyHHmmss.txt
.Notes
    Useful for when you have multiple files with the same name in the same directory
#>
Param([Alias('F')][Switch]$FileDate, [String]$FileName="Pass")
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
if($FileDate) # this needs work
{
    Get-ChildItem . | 
        Where-Object {$_.Attributes -eq "Archive"} | 
            ForEach-Object {$_.CreationTime | 
                Sort-Object | 
                    Select-Object -Last 1 | 
                        ForEach-Object {$creationdate = $_;}$newname = $_.BaseName + "_" + $creationdate.month.ToString() + $creationdate.day.ToString() + $creationdate.year.ToString() + $_.extension;Rename-Item $_ $newname;}
    
    Write-Host "Appended file's creation date.";
    break;
}
elseif($FileName -ne "Pass")
{
    $date = Get-Date;

    $append_string = $date.month.ToString() + $date.day.ToString() + $date.year.ToString() + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString();

    Get-ChildItem $FileName| 
        #Where-Object {$_.Attributes -eq "Archive";} |
            ForEach-Object {$newname = $_.BaseName + "_" + $append_string + $_.extension; Rename-Item $_ $newname;}
    
    Write-Host "Appended today's date to $($FileName)";
    break;
}
else
{ 
    $date = Get-Date;

    $append_string = $date.month.ToString() + $date.day.ToString() + $date.year.ToString() + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString();

    Get-ChildItem | 
        Where-Object {$_.Attributes -eq "Archive";} |
            ForEach-Object {$newname = $_.BaseName + "_" + $append_string + $_.extension; Rename-Item $_ $newname;}

    Write-Host "Appended today's date to all file in this directory.";
    break;
}