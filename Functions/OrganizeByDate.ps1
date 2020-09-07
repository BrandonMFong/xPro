<#
.Synopsis
    Moving files to a desitination and organize them by their last write time property 
.Notes
    This script has a secondary purpose
#>
Param(
    [String]$SourcePath = "B:\PHOTOS\",
    [String]$DestinationDirectory = "K:\PHOTOS\",
    [String]$DirectoryNameFormatter = "yyyy-MM"
)

Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;

[DateTime]$StartTime = Get-Date;
# Set file paths
[String]$DestinationPath = $null;

[int16]$NumberOfFiles = (Get-ChildItem $SourcePath).Length;
if($NumberOfFiles -eq 0){throw "No files!";}

# Get all the unique months
[System.Object]$YoungestFile = Get-ChildItem $SourcePath | Sort-Object -Property LastWriteTime | Select-Object -First 1;

# Init definition
# Defines the interval of the how the files will go into a directory 
[DateTime]$mindate = $YoungestFile.LastWriteTime.ToDateTime($null);
[DateTime]$maxdate= $YoungestFile.LastWriteTime.ToDateTime($null).AddMonths(1);
try 
{
    [bool]$key = $false;
    while(!$key)
    {
        # If there are no more files left in the directory 
        if($(Get-ChildItem $SourcePath).Length -eq 0){break;}
    
        $DestinationPath = $DestinationDirectory + $(Get-Date $mindate -Format $DirectoryNameFormatter); # Change the directory
        if(!(Test-Path $DestinationPath)){mkdir $DestinationPath;} # make the directory if it does not exist
    
        # Move the files
        Get-ChildItem $SourcePath | Where-Object{($_.LastWriteTime -ge $mindate) -and ($_.LastWriteTime -lt $maxdate)}|ForEach-Object{Move-Item $_.FullName $DestinationPath -Verbose -Force}
    
        # increment the interval
        $mindate=$mindate.AddMonths(1);$maxdate=$maxdate.AddMonths(1);

        Write-Host "Next Interval (Press 'Q' to quit): mindate=$($mindate) & maxdate=$($maxdate)";
        Start-Sleep 5; # Giving me time to stop the transfer
        $key = Test-KeyPress -Key Q; # test key
    }
}
catch 
{
    Write-Host "$_";
}

# 10000000 ticks = 1 second
[DateTime]$Endtime = Get-Date;
[int16]$MinutesForThisScript = <#Minutes#>(<#Seconds#>(($EndTime.Ticks - $StartTime.Ticks) / 10000000) / 60);

# Evaluate results
Write-Host "`nTook $($MinutesForThisScript) to move all $($NumberOfFiles) files to destination";