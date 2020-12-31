<#
.Synopsis
    Auto Tagging
    This script determines what gets tagged
.Notes
    This script does not care what branch we are on.  That is .yml's job

    What do I do when I merge a bug from master or beta and I want to tag it?
#>
Param(
    [System.Boolean]$Push=$False,
    [switch]$Whatif,
    [string]$PathToVersionConfig=$null, # Must be full path
    [string]$PathToTag=$null
)
Import-Module $($PSScriptRoot + "\..\Modules\Git.psm1") -Scope Local -DisableNameChecking;

# Push-Location $Global:AppPointer.Machine.GitRepoDir;
#     # The .yml handles the trigger
#     # I probably don't need this anymore
#     if([string]::IsNullOrEmpty($PathToVersionConfig))
#     {
#         [System.Object[]]$VersionReader = Get-Content ($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Files.Config.Versioning) | ConvertFrom-Json;
#     }
#     else 
#     {
        # This case considers other repos using the auto tag feature
        # For me, I configured the default location in the app.json file
        [System.Object[]]$VersionReader = Get-Content $PathToVersionConfig | ConvertFrom-Json; # Passed by the user
    # }
    [string]$BranchNameDelimiter = $VersionReader.BranchNameDelimiter; # Doing this because I might change to / 
    [String]$LastCommitMessage = $(git log -1 --pretty=format:"%s"); # get the commit message
    [String]$LatestTag = "$(git describe --tags)";
    if($LatestTag.Contains("-")){$LatestTag = $LatestTag.Substring(0,$LatestTag.IndexOf("-"));} # Remove the redundant string
    # I want to know if the last commit was tagged so this wouldn't tag again
    [String]$CommitsSinceLastTag = "$(git log -1 --pretty=format:"%d")"; # the string that will have the tags

    if(!$CommitsSinceLastTag.Contains("tag:")) # if the last commit wasn't already tagged
    {
        [System.Boolean]$GoingToTag = $false;
        [String]$TagType = $null;
        for([int16]$i=0;$i -lt $VersionReader.Branches.Count;$i++)
        {
            # If the last commit message is following the standard
            # The standard is found when it contains on of the Branch Type
            # The first type that matches will pass
            if($LastCommitMessage.Contains($VersionReader.Branches.Branch[$i].Type + $BranchNameDelimiter))
            {
                $GoingToTag=$true;
                $TagType = $VersionReader.Branches.Branch[$i].Version.ToString();
                break;
            }
        }
        
        # If the standard names are in the commit then 
        # Default is always the last type of tags
        # Can be configured if this is the standard
        if(!$GoingToTag){$TagType = $VersionReader.Versions.Version[$VersionReader.Versions.Version.Length-1];}

        if(![string]::IsNullOrEmpty($PathToTag)){Set-Location $PathToTag;} # if this isn't the repo we are tagging
        
        Write-Host "Going to tag $($VersionReader.Branches.Branch[$i].Version)"; 
        Set-Tag -Tag:$TagType -Push:$Push -Whatif:$Whatif -VersionReader:$VersionReader;
    }
    else{Write-Host "SKIPPING TAG. Last commit was already tagged.";}
# Pop-Location;