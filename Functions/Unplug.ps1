
$command = $(Get-ChildItem $($PSScriptRoot + "\DeleteGlobalScripts.ps1")).FullName;$(& $command);
$command = $(Get-ChildItem $($PSScriptRoot + "\DismountDrive.ps1")).FullName;$(& $command);