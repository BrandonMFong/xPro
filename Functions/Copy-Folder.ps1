<#
.Synopsis
    Copies FolderA to FolderB
.Description
    Depracated, can already use Copy-Item but good method
.Notes
    You can also use Copy-Item -recurse 
#>
Param 
(
    [Parameter(Mandatory=$true)][string]$FolderA = $null,
    [Parameter(Mandatory=$true)][string]$FolderB = $null
)

# Get all filepaths
[System.Object[]]$AllFolderPathsFormer = (Get-ChildItem ($FolderA) -Recurse | Where-Object{$_.Attributes -notlike "*Directory*"}|ForEach-Object {$_.FullName});

# Get old full base path
Push-Location $FolderA;
    [string]$OldBasePath = (Get-Location).Path;
Pop-Location;
# Get New full base path
Push-Location $FolderB;
    [string]$NewBasePath = (Get-Location).Path + "\$($FolderA | Split-Path -Leaf)";
Pop-Location;

[System.Object[]]$AllFolderPathsLadder = [system.object[]]::new($AllFolderPathsFormer.Length); # Declare new object
for([int]$i = 0; $i -lt $AllFolderPathsFormer.Length;$i++)
{
    $AllFolderPathsLadder[$i] = $AllFolderPathsFormer[$i].Replace($OldBasePath,$NewBasePath);
    Write-Verbose "REWRITE: $($AllFolderPathsFormer[$i]) => $($AllFolderPathsLadder[$i])";
    Write-Progress -Activity "Replacing old base path to new base path" -status "New Path: $($AllFolderPathsLadder[$i])" -PercentComplete ((($i+1) / $AllFolderPathsFormer.Length)*100);
}
Write-Progress -Activity "Replacing old base path to new base path" -Completed;

for([int]$i = 0; $i -lt $AllFolderPathsLadder.Length;$i++)
{
    New-Item -Force $AllFolderPathsLadder[$i] | Out-Null;
    Copy-Item $AllFolderPathsFormer[$i] $AllFolderPathsLadder[$i] -Recurse -Force;
    Write-Verbose "COPY-ITEM: $($AllFolderPathsFormer[$i]) => $($AllFolderPathsLadder[$i])";
    Write-Progress -Activity "Copy Item" -status "Item: $($AllFolderPathsLadder[$i] | Split-Path -Leaf)" -PercentComplete ((($i+1) / $AllFolderPathsLadder.Length)*100);
}
Write-Progress -Activity "Replacing old base path to new base path" -Completed;

# For large amounts of items, not all items are copied.  Probably have to do with attribute type
Write-Host "`nCopied $([Math]::Round(((Get-ChildItem $($FolderB + "$($FolderA | Split-Path -Leaf)") -Recurse | Measure-Object).Count / (Get-ChildItem $FolderA -Recurse | Measure-Object).Count) * 100, 2))% items!" -ForegroundColor Green;