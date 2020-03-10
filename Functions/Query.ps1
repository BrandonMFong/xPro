
param([alias('is')][switch]$inputstring,[string]$Decode="pass")
Push-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('SQL'));
    if(IsNotPass($Decode)){$var.InputCopy($Decode);}
    elseif($inputstring)
    {
        $x = Read-Host -Prompt "Query";
        $var.query($x);
    }
    else{Write-Host "Nothing passed" -foregroundcolor Red};
Pop-Location;
