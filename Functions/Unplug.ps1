
$command = $(Get-ChildItem $($PSScriptRoot + "\DeleteProfileTrace.ps1")).FullName;$(& $command);
$command = $(Get-ChildItem $($PSScriptRoot + "\DismountDrive.ps1")).FullName;$(& $command);