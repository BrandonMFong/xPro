# Lists out all the files in the directory and appends date to each 

Param([Alias('F')][Switch]$FileDate, [String]$FileName="Pass", [Switch]$Help)

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

elseif($Help)
{
    Write-Host "`$FileDate [Switch]: " -ForegroundColor Green -NoNewline
    Write-Host "Takes every file in current directory (where Attributes=Archive) and appends their CreationTime to their basename.";
    Write-Host "`$FileName [String]: " -ForegroundColor Green -NoNewline
    Write-Host "Appends today's date to selected file's basename.";
    Write-Host "If no parameters are passed: " -ForegroundColor Green -NoNewline
    Write-Host "Appends today's date to all files in current directory (where Attributes=Archive).";
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