param([string]$x)
Push-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('Web'));

    switch($x)
    {
        "Google"
        {
            $v = read-host -prompt "Google"
            $var.Google($v);break;
        }
        default{throw "Nothing searched";break;}
    }
Pop-Location