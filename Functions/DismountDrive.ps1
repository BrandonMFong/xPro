param([Parameter(Mandatory=$true)][string]$Drive)

if(!(Test-Path $Drive)){Write-Warning "Drive $($Drive) does not exist.";  break;}
$driveEject = New-Object -comObject Shell.Application;
$driveEject.Namespace(17).ParseName($Drive).InvokeVerb("Eject");