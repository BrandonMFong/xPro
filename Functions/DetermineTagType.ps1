<#
.Synopsis
    Auto Tagging
    This script determines what gets tagged
.Notes
    This script does not care what branch we are on.  That is .yml's job

    What do I do when I merge a bug from master or beta and I want to tag it?
#>
Param([System.Boolean]$Push=$False)
Import-Module $($PSScriptRoot + "\..\Modules\Git.psm1") -Scope Local -DisableNameChecking;

Push-Location $Global:AppPointer.Machine.GitRepoDir;
    # The .yml handles the trigger
    [System.Object[]]$VersionReader = Get-Content ($Global:AppPointer.Machine.GitRepoDir + "\Config\Versioning\Version.JSON") | ConvertFrom-Json;
    [string]$BranchNameDelimiter = $VersionReader.BranchNameDelimiter; # Doing this because I might change to / 
    [String]$LastCommitMessage = $(git log -1 --pretty=format:"%s");
    [String]$LatestTag = "$(git describe --tags)";
    if($LatestTag.Contains("-")){$LatestTag = $LatestTag.Substring(0,$LatestTag.IndexOf("-"));}
    # I want to know if the last commit was tagged so this wouldn't tag again
    [String]$CommitsSinceLastTag = "$(git log -1 --pretty=format:"%d")";

    if(!$CommitsSinceLastTag.Contains("tag:"))
    {
        [System.Boolean]$GoingToTag = $false;
        [String]$TagType = $null;
        for([int16]$i=0;$i -lt $VersionReader.Branches.Count;$i++)
        {
            # If the last commit message is following the standard
            if($LastCommitMessage.Contains($VersionReader.Branches.Branch[$i].Type + $BranchNameDelimiter))
            {
                $GoingToTag=$true;
                $TagType = $VersionReader.Branches.Branch[$i].Version.ToString();
                break;
            }
        }
        # If the standard names are in the commit then 
        if($GoingToTag){Write-Host "Going to tag ($VersionReader.Branches.Branch[$i].Version)"; Set-Tag -Tag:$TagType -Push:$Push;}
        # Default is always the last type of tags
        # Can be configured if this is the standard
        else{Write-Host "Going to tag BugPatch"; Set-Tag -Tag:$("BugPatch") -Push:$Push;}
    }
    else{Write-Host "SKIPPING TAG. Last commit was already tagged.";}
Pop-Location;