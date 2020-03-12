param([switch]$Google,[switch]$Sharepoint,[switch]$Dictionary,[switch]$Youtube)
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
    elseif($Dictionary)
    {
        $v = read-host -prompt "Dictionary"
        $var.Dictionary($v);break;
    }
    elseif($Youtube)
    {
        $v = read-host -prompt "Youtube"
        $var.Youtube($v);break;
    }
    else{throw "Nothing searched";break;}

Pop-Location