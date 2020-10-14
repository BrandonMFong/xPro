Param([bool]$ForceUpdate=$false)

[boolean]$Updated = $false;

Push-Location $PSScriptRoot
    [String]$ProfPath = $(Get-ChildItem .\Profile.ps1).FullName; # Get full file path to profile script in repo

    Push-Location $($PROFILE |Split-Path -Parent);
        [datetime]$PSProfile = $(Get-ChildItem $($PROFILE | Split-Path -Leaf)).LastWriteTime; # Timestamp for msprofile script
    Pop-Location;

    Push-Location $x.Machine.GitRepoDir;
        [datetime]$GitProfile = $(Get-ChildItem .\Profile.ps1).LastWriteTime; # Timestamp for repo profile script
    Pop-Location;

    if(($GitProfile -gt $PSProfile) -or ($ForceUpdate))
    {
        if(!$ForceUpdate)
        {
            Write-Host  "`nThere is an update to $($Global:AppJson.RepoName) profile." -ForegroundColor Red
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

if($Updated)
{
    Write-Warning "Profile was updated";
    return 1;
}
else{return 0;}
