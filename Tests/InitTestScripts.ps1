<#
.Notes
    Must realize that we are running tests inside the repo
    Anything in the Scripts directory will be run
#>
if($Global:AppPointer.Machine.ConfigFile -ne "\TestsConfig.xml"){Write-Warning "Not using Test Config.  Please update config to point to => TestsConfig.xml";break;}
Push-Location $PSScriptRoot;
    Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;

    [String[]]$TestScripts = $(Get-ChildItem $($PSScriptRoot + "\Scripts\") -Recurse|Where-Object{$_.Extension -eq ".ps1"}).FullName;
    [Byte]$ReturnValue = 0;
    for([int16]$i = 0;$i -lt $TestScripts.Length;$i++)
    {
        Write-Host "----------------------------------------------------------------------------";
        Write-Host "Executing: $($TestScripts[$i])`n" -ForegroundColor Green;
        GetSynopsisText -script:$TestScripts[$i];

        # Return 1 is an error
        if($(& $TestScripts[$i]))
        {
            Write-Host "`nResults => [FAILED]" -ForegroundColor Red;
            $ReturnValue = 1; # will be one if one test script was errored
        }
        else{Write-Host "`nResults => [PASSED]" -ForegroundColor Green;}
    }

    Write-Host "----------------------------------------------------------------------------";
Pop-Location;
if($ReturnValue){exit(1);}
else{exit(0);}