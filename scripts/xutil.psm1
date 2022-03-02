
function goto {
    param (
        [Parameter (Mandatory = $true)] [String] $key
    )
    $success    = $true;
    $xpPath     = $null;
    $path       = $null;

    # make sure the .xpro path is set
    try {
        $xpPath = (Get-Command xp.exe).Path
    }
    catch {
        $success = $false;
        Write-Warning "xp binary could not be found";
    }

    # Get path for the key
    if ($success) {
        $path       = (& $xpPath dir $key);
        $success    = $?;
    }

    # make sure that path exists
    if ($success) {
        $success = (Test-Path -Path $path);
    }

    # Set location
    if ($success) {
        Set-Location $path;
    }
}