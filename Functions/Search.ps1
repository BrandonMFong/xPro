param([switch]$Google,[switch]$Sharepoint)
Push-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('Web'));

    if($Google)
    {
        $v = read-host -prompt "Google"
        $var.Google($v);break;
    }
    elseif($Sharepoint)
    {
        $v = read-host -prompt "Sharepoint"
        $var.Sharepoint($v);break;
    }
    else{throw "Nothing searched";break;}

Pop-Location