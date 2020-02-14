# Lists out all the files in the directory and appends date to each 

Param([Alias('F')][Switch]$FileDate, [String]$FileName="Pass")

if($FileDate) # this needs work
{
    Get-ChildItem | 
        Where-Object {$_.Attributes -eq "Archive"} | 
            ForEach-Object {$_.CreationTime | 
                Sort-Object | 
                    Select-Object -Last 1 | 
                        ForEach-Object {$creationdate = $_;}$newname = $_.BaseName + "_" + $creationdate.month.ToString() + $creationdate.day.ToString() + $creationdate.year.ToString() + $_.extension;Rename-Item $_ $newname;}
    
    Write-Host "Appended file's creation date.";
}
elseif($FileName -ne "Pass")
{
    $date = Get-Date;

    $append_string = $date.month.ToString() + $date.day.ToString() + $date.year.ToString() + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString();

    Get-ChildItem $FileName| 
        #Where-Object {$_.Attributes -eq "Archive";} |
            ForEach-Object {$newname = $_.BaseName + "_" + $append_string + $_.extension; Rename-Item $_ $newname;}
    
    Write-Host "Appended today's date to $($FileName)";
}
else
{ 
    $date = Get-Date;

    $append_string = $date.month.ToString() + $date.day.ToString() + $date.year.ToString() + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString();

    Get-ChildItem | 
        Where-Object {$_.Attributes -eq "Archive";} |
            ForEach-Object {$newname = $_.BaseName + "_" + $append_string + $_.extension; Rename-Item $_ $newname;}

    Write-Host "Appended today's date to all file in this directory.";
}