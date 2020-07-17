Param([bool]$ForceUpdate=$false)

[boolean]$Updated = $false;

Push-Location $PSScriptRoot
    Get-ChildItem .\Profile.ps1 | ForEach-Object{[String]$ProfPath = $_.FullName;}

    Push-Location $($PROFILE |Split-Path -Parent);
        Get-ChildItem $($PROFILE | Split-Path -Leaf) |
            ForEach-Object {[datetime]$PSProfile = $_.LastWriteTime}   
    Pop-Location;

    Push-Location $x.Machine.GitRepoDir;
        Get-ChildItem .\Profile.ps1|
            foreach-Object {[datetime]$GitProfile = $_.LastWriteTime}   
    Pop-Location;

    if(($GitProfile -gt $PSProfile) -or ($ForceUpdate))
    {
        if(!$ForceUpdate)
        {
            Write-Host  "`nThere is an update to GlobalScripts profile." -ForegroundColor Red
            $update = Read-Host -Prompt "Want to update? (y/n)";
        }
        if(($update -eq "y") -or ($ForceUpdate))
        {
            Push-Location $($PROFILE | Split-Path -Parent);
                Remove-Item $($PROFILE | Split-Path -Leaf) -Verbose; 
                Copy-Item $ProfPath . -Verbose;
                Rename-Item .\Profile.ps1 $($PROFILE|Split-Path -Leaf) -Verbose;
            Pop-Location;
            
            $Updated = $true;
        }
        else{Write-Host "`nNot updating.`n" -ForegroundColor Red -BackgroundColor Yellow; }
    }
    else
    {
        Write-Host "`nNo updates to profile`n" -ForegroundColor Green; 
    }
Pop-Location

if($Updated){return 1;}
else{return 0;}