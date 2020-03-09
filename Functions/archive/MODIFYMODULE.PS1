# This script is a way for me to reimport classes I modify without restarting powershell

$Modules = @{};
$i = 1;
Get-Module|
    ForEach-Object{$_.Name;}|
        ForEach-Object{$Modules.Add($i, $_);$i++;}
$Modules; #show module names
[int]$ModuleToReimport = Read-Host -Prompt "Select Module to Reimport by number (hit ctrl+c to cancel or enter 0)";
if($ModuleToReimport -ne 0)
{
    Write-Warning "Reimporting $($Modules.$ModuleToReimport)`n";
    Remove-Module $Modules.$ModuleToReimport;
    Go-To SC -p
        Get-ChildItem | 
            Where-Object {$_.Name -like "*$($Modules.$ModuleToReimport)*"} |
                Measure-Object | ForEach-Object{$count = $_.Count;}
        if($count -gt 1){throw "Exitting program, more than one module with the same name"; exit;}
        else 
        {
            Get-ChildItem | 
                Where-Object {$_.Name -like "*$($Modules.$ModuleToReimport)*"} |
                    ForEach-Object{Import-Module -Global $_.FullName;} # I think I am not doing this in the global scope of things
            Write-Warning "Reloading Microsoft Powershell Profile.";
            .$profile;
        }
    Pop-Location
}
else {Write-Host "Entered 0. Exiting script."; Exit;}