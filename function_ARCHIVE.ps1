# Used to clear the directory and stores all files in an archive folder


Param([Alias('Z')][Switch]$Zip, [Switch]$IncludeZipFiles, [Switch]$OnlyZipFiles, [string]$FileName="Pass")

if($Zip)
{
    if(!(Test-Path .\archive\))
    {
        throw "Directory .\archive\ does not exist."; 
        exit; # Exists because if archive doesn't exist then why zip
    }

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
elseif($FileName -ne "Pass") # could've simply just used mv but eh
{
    if(!(Test-Path .\archive\))
    {
        Write-Warning "Directory .\archive\ does not exist.  Creating the directory";
        mkdir archive;
    }
    Move-Item $FileName .\archive\;
}
else
{
    if(!(Test-Path .\archive\))
    {
        Write-Warning "Directory .\archive\ does not exist.  Creating the directory";
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
