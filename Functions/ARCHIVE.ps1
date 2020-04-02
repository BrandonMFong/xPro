<#
.Synopsis
   Puts specified directory objects into an 'archive' folder
.Description
   Given two integers, adds them together using the
   '+' operator and returns an integer result
.Parameter Zip
    Zips all files in an archive folder in the current directory
.Example
   Archive -Zip
.Notes
    This function is useful when you have have a lot in your directory and you want to get a clean start
#>
Param([Alias('Z')][Switch]$Zip, [Switch]$IncludeZipFiles, [Switch]$OnlyZipFiles, [Switch]$OnlyFiles, [string]$FileName="Pass")
function Test 
{
    if(!(Test-Path .\archive\))
    {
        throw "Directory .\archive\ does not exist."; 
        exit; # Exists because if archive doesn't exist then why zip
    }
}
function DoesFileExist([string]$file)
{
    if(Test-Path $(.\archive\ + $file)){Throw "File Exists in Archive folder"}
}
if($Zip)
{
    Test;
    if((Get-ChildItem .\archive\).count -gt 10)
    {
        $filename = "Archive_" + (Get-Date).Month.ToString() + (Get-Date).Day.ToString() + (Get-Date).Year.ToString();
        Set-Location .\archive\;
        mkdir $filename;
        Get-ChildItem | 
            Where-Object{($_.Extension -ne '.zip') -and ($_.Name -ne 'archive') -and ($_.Name -ne $filename)} | 
                ForEach-Object{Move-Item $_ $filename;}
        $ZipName = $filename + '.zip';
        Compress-Archive $filename $ZipName;
        Remove-Item $filename   ;
        exit;
    }
    else
    {
        throw "Not enough files to compress.";
        exit;
    }
}
elseif($IncludeZipFiles)
{
    Test;
    Get-ChildItem | 
        Where-Object{$_.Name -ne 'archive'} |
            ForEach-Object{Move-Item $_.Fullname .\archive\;}
    exit;
}
elseif($OnlyZipFiles)
{
    Test;
    Get-ChildItem |
    Where-Object{($_.Extension -eq '.zip') -and ($_.Name -ne 'archive')} | 
            ForEach-Object{Move-Item $_.Fullname .\archive\;}

    exit;
}
elseif($OnlyFiles)
{
    Test;
    Get-ChildItem *.*|
    Where-Object{$_.Name -ne 'archive'} | 
            ForEach-Object{Move-Item $_.Fullname .\archive\;}

    exit;
}
else 
{
    Test;
    Get-ChildItem |
    Where-Object{($_.Extension -ne '.zip') -and ($_.Name -ne 'archive')} | 
            ForEach-Object
            {
                DoesFileExist($_.Name);
                Move-Item $_.Fullname .\archive\;
            }
    exit;
}

