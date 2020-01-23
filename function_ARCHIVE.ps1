# Used to clear the directory and stores all files in an archive folder


Param([Alias('Z')][Switch]$Zip, [Switch]$IncludeZipFiles, [Switch]$OnlyZipFiles)

if($Zip)
{
    if(!(Test-Path .\archive\))
    {
        throw "Directory .\archive\ does not exist.";
        exit;
    }

    if((Get-ChildItem .\archive\).count -gt 10)
    {
        $filename = "Archive_" + (Get-Date).Month.ToString() + (Get-Date).Day.ToString() + (Get-Date).Year.ToString();
        Set-Location .\archive\;
        mkdir $filename;
        Get-ChildItem | 
            Where-Object{($_.Extension -ne '.zip') -and ($_.Name -ne 'archive')} | 
                ForEach-Object{Move-Item $_ $filename;}
        $ZipName = $filename + '.zip';
        Compress-Archive $filename $ZipName;
        Remove-Item $filename;
        exit;
    }
    else
    {
        throw "Not enough files to compress.";
        exit;
    }
}

else
{
    if(!(Test-Path .\archive\))
    {
        mkdir archive;
    }
    if($IncludeZipFiles)
    {
        Get-ChildItem | ForEach-Object{Move-Item $_ .\archive\;}
        exit;
    }
    elseif($OnlyZipFiles)
    {
        Get-ChildItem |
        Where-Object{($_.Extension -eq '.zip') -and ($_.Name -ne 'archive')} | 
                ForEach-Object{Move-Item $_ .\archive\;}

        exit;
    }
    else 
    {
        Get-ChildItem |
        Where-Object{($_.Extension -ne '.zip') -and ($_.Name -ne 'archive')} | 
                ForEach-Object{Move-Item $_ .\archive\;}
        exit;
    }
}
