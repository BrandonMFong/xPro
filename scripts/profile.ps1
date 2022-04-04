<#
.SYNOPSIS
    xPro Microsoft Powershell profile
#>

## VARIABLES START ##

$xproPath   = $env:HOMEDRIVE + $env:HOMEPATH + "\.xpro";
$xproBin    = $xproPath + "\xp.exe";
$success    = $true;

## VARIABLES END ##

## FUNCTIONS START ## 

function loadAliases {
    $result         = $true 
    $aliasCount    = -1;

    if ($result) {
        $aliasCount = $(& $xproBin alias --count);
        $result     = $aliasCount -ne -1;

        if (!$result) {
            Write-Error "Received an illegal count for object"
        }
    }

    if ($result) {
        for ($i = 0; $i -lt $aliasCount; $i++) {
            $name   = $(& $xproBin alias -index $i --name);
            $value  = $(& $xproBin alias -index $i --value);

            New-Alias -Name:$name -Value:$value -Force -Scope Global;
        }
    }

    return $result;
}

function loadObjects {
    $result         = $true 
    $objectCount    = -1;

    if ($result) {
        $objectCount    = $(& $xproBin obj --count);
        $result         = $objectCount -ne -1;

        if (!$result) {
            Write-Error "Received an illegal count for object"
        }
    }

    if ($result) {
        for ($i = 0; $i -lt $objectCount; $i++) {
            $name   = $(& $xproBin obj -index $i --name);
            $value  = $(& $xproBin obj -index $i --value);

            New-Variable -Name:$name -Value:$value -Force -Scope Global;
        }
    }

    return $result;
}

## FUNCTIONS END ## 

## MAIN START ##

Push-Location $xproPath;

# If path exists then add path to path
if ($success) {
    $env:Path = $xproPath + ";" + $env:Path;

} else {
    Write-Warning "Path $xproPath does not exist!";
}

if ($success) {
    Import-Module $xproPath\xutil.psm1 -Scope Global;
    $success = $?;
}

if ($success) {
    $success = loadObjects;
}

if ($success) {
    $success = loadAliases;
}

Pop-Location;

if ($success) {
    Write-Host "Successfully loaded xPro";
} else {
    Write-Warning "Failed to load xPro";
}

## MAIN END ## 
