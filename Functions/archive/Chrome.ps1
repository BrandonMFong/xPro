
Param([string]$URL,[string]$Decode=' ', [switch]$NewWindow)
Set-Alias c 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe';

Push-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('SQL'));
    try
    {
        if(IsNotSpace($Decode))
        {
            if($NewWindow){c $var.InputReturn($Decode) --new-window}
            else{c $var.InputReturn($Decode)};
        }
        else
        {
            if($NewWindow){c $URL --new-window}
            else{c $URL};
        }
    }
    catch 
    {
        Write-Warning $_;
    }
Pop-location
