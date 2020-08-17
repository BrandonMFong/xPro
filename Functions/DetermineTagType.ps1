<#
.Synopsis
    Auto Tagging
    This script determines what gets tagged
.Notes
    I am going to need a system
    I am determining tag types on the commit messages
    This is very specific to the squash commits because I put the branches' names that I am squashing 
    *****If the name does not have those squash standard names and they are powershell scripts, they will get bugpatch tagged *****
    Standard squash names <TagType>-<OriginalBranch>-<BranchDescription> or is dev branch (which Tag.yml determines)

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

    [System.Boolean]$GoingToTag = $false;
    [String]$TagType = $null;
    for([int16]$i=0;$i -lt $VersionReader.Branches.Count;$i++)
    {
        if($LastCommitMessage.Contains($VersionReader.Branches.Branch[$i].Type + $BranchNameDelimiter))
        {
            $GoingToTag=$true;
            $TagType = $VersionReader.Branches.Branch[$i].Version.ToString();
            break;
        }
    }
    if($GoingToTag){Write-Host "Going to tag ($VersionReader.Branches.Branch[$i].Version)"; Set-Tag -Tag:$TagType -Push:$Push;}
    # Default is always the last type of tags
    # Can be configured if this is the standard
    else{Write-Host "Going to tag BugPatch"; Set-Tag -Tag:$("BugPatch") -Push:$Push;}
Pop-Location;