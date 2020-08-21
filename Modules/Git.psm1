<#
.Notes
    Assumes you have git as an env path or you have set it in the programs config
#>
Import-Module $PSScriptRoot\FunctionModules.psm1 -Scope Local;

function Get-Tag
{
    [string]$gitstring = "Version: $(git describe --tags)";
    if($gitstring.Contains("-")){Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;}
    else {Write-Host "`n$($gitstring)`n" -ForegroundColor Gray;}
}

# Not using in Set-Tag
# See if this affects config
function GetSettings
{
    Param([string]$FilePath)
    [Boolean]$Found = $false;
    foreach($o in $global:XMLReader.Machine.GitSettings.Repository)
    {
        if($FilePath.Contains($o.FilePath)){$Found = $true;break;}
    }
    if($Found){return $o;}
    else{return $null;}
}
function Set-Tag
{
    Param([string]$CommitID=$null,
        [Parameter(Mandatory=$true)][ValidateSet("Major","Minor","BugPatch")][string]$Tag,
        [Switch]$Major,
        [Switch]$Minor,
        [Switch]$BugPatch, 
        [Switch]$Push
    )

    Write-Host "Tagging for $($Tag)";
    # Make sure this is the right order to do things

    # Will not tag if it is not allowed 
    # But if this node is not arround then it will tag
    if(![string]::IsNullOrEmpty($GitSettings.BranchesAllowedForTagging))
    {
        [string]$CurrentBranch = "$(git rev-parse --abbrev-ref HEAD)";
        [String[]]$AllowedBranches = $(SplitString -originalstring:$GitSettings.BranchesAllowedForTagging.Branches -Delimiter:$("|"));
        [System.Boolean]$IsAllowed = $false;
        for([int16]$i = 0;$i -lt $AllowedBranches.Count;$i++)
        {
            if($AllowedBranches[$i] -eq $CurrentBranch){$IsAllowed = $true;break;}
        }
        if(!$IsAllowed){break;}
    }

    [String]$currenttag = "$(git describe --tags)";
    Write-Host "Current tag for $($currenttag)";
    if([string]::IsNullOrEmpty($currenttag))
    {
        Write-Host "Set first tag" -ForegroundColor Gray;
        [int16]$MajorString = 0;
        [int16]$MinorString = 0;
        [int16]$BugPatchString = 0;
    }
    else 
    {
        try{if($currenttag.Contains("-")){$currenttag = $currenttag.Substring(0,$currenttag.IndexOf("-"));}}
        catch{Write-Host "Something bad happened";}

        try
        {
            Write-Host "tag before MajorString $($currenttag)";
            [int]$MajorString = $currenttag.Substring(0,$currenttag.IndexOf("."));
            Write-Host "MajorString = $($MajorString)";
            DisectTag([ref]$currenttag);
    
            Write-Host "tag before MinorString $($currenttag)";
            [int]$MinorString = $currenttag.Substring(0,$currenttag.IndexOf("."));
            Write-Host "MinorString = $($MinorString)";
            DisectTag([ref]$currenttag);
    
            Write-Host "tag before BugPatchString $($currenttag)";
            [int]$BugPatchString = $currenttag; # At this point we are at the end
            Write-Host "BugPatchString = $($BugPatchString)";
        }
        catch{$Global:LogHandler.WriteError($_);}
    }

    # Tag option
    switch($Tag)
    {
        "Major"{[String]$TagString = "$($MajorString+1).0.0";}
        "Minor"{[String]$TagString = "$($MajorString).$($MinorString+1).0";}
        "BugPatch"{[String]$TagString = "$($MajorString).$($MinorString).$($BugPatchString+1)";}
        default
        {
            # Not writing logs because this will happen on the runner
            "Something bad happened";
        }
    }
    if($TagString -eq $currenttag){Write-Host "Tag $($TagString) was already set!"; break;}

    # Tag
    Write-Host "***Applying tag: $($TagString)***";
    git tag $TagString $CommitID;

    if($Push){GitRebasePush -Tags;}
}


function DisectTag([ref]$tag)
{
    [Regex]$regex = $tag.Value.Substring(0,$tag.Value.IndexOf(".")+1);
    $tag.Value = $regex.Replace($tag.Value,"",1);
}


function Set-Commit
{
    Param([String]$Message,[Switch]$NotAll,
        [Switch]$NoType,[Switch]$Push,
        [ValidateSet("Major","Minor","BugPatch")][String]$Tag=$null
    )

    if(!$NotAll)
    {
        git add -A; # By default, it will stage all changes
    }

    [String]$commitmessage = $null;
    [System.Object[]]$GitSettings = $(GetSettings -FilePath:$(Get-Location).path);

    # Run through the commit types if they are configured
    if(![string]::IsNullOrEmpty($GitSettings.CommitTypes.CommitType) -and !$NoType)
    {
        Write-Host "`nChoose from Commit types:";
        for([int16]$i = 0;$i -lt $GitSettings.CommitTypes.CommitType.Count;$i++)
        {
            Write-Host "    $($i+1) - $($GitSettings.CommitTypes.CommitType[$i])";
        }
        [int16]$NoneIndex = $i+2;
        Write-Host "    $($NoneIndex) - None";

        try{[Int16]$index = Read-Host -Prompt "So?";} # choose
        catch{$Global:LogHandler.Warning("Probably did not put the correct formatted input");break;}
        if(($index -ne 0) -and ($index -ne $NoneIndex)){$commitmessage += "[$($GitSettings.CommitTypes.CommitType[$index-1])] ";} # Set the type in the string
    }
    
    [string]$msg = Read-Host -Prompt "Commit message";
    $commitmessage += $msg;

    git commit -m $commitmessage; # Set the commit

    # Tag option
    switch($Tag)
    {
        "Major"{Set-Tag -Tag "Major";}
        "Minor"{Set-Tag -Tag "Minor";}
        "BugPatch"{Set-Tag -Tag "BugPatch";}
    }

    # Always rebase before you push
    # Tests if a Tag was passed
    if($Push){GitRebasePush -Tags:$([string]::IsNullOrEmpty($Tag));}
}

function GitRebasePush
{
    Param([Switch]$Tags)

    [string[]]$b = git branch -r; # Get all remote branches
    [String]$CurrentBranch = "$(git rev-parse --abbrev-ref HEAD)";
    [system.Boolean]$IsRemoteBranch = $false;
    # checks if branch is on remote
    for([int16]$i=0;$i -lt $b.Length;$i++)
    {
        if([string]$($b[$i].Substring(2,$b[$i].Length-2)) -eq $("origin/"+$CurrentBranch)){$IsRemoteBranch = $true;break;}
    }
    if(!$IsRemoteBranch){git push --set-upstream origin $CurrentBranch;}
    else 
    {
        git pull --rebase;
        git push;
    }

    if($Tags){git push --tags;}
}
function Squash-Branch
{
    Param([Switch]$Force)
    [string[]]$branches = $(git branch);
    if([string]::IsNullOrEmpty($branches)){Write-Host "Not git tree." -ForegroundColor Gray; break;}
    [string]$CurrentBranch = $null;

    # Doing this because I am getting the other branches too
    # Get current branch
    for([int16]$i=0;$i -lt $branches.Count;$i++)
    {
        if($branches[$i].Substring(0,1) -eq "*"){$CurrentBranch = $branches[$i].Substring(2,$branches[$i].Length-2);}
        $branches[$i] = $branches[$i].Substring(2,$branches[$i].Length-2);
    }

    # Get target branch
    Write-Host "`nChoose from Branches to squash to current branch:";
    for([int16]$i=0;$i -lt $branches.Count;$i++)
    {
        Write-Host "    $($i+1) - $($branches[$i])";
    }
    [Int16]$index = Read-Host -Prompt "So?"; # choose
    [String]$TargetBranch = $branches[$index-1]; # Set the type in the string

    # In order for this to be squashed, I have to initially rule it to be
    # This is an intitiative for autotag
    # I need a system to make things automatic
    if(!$TargetBranch.Contains($CurrentBranch)){throw "Target Branch is not ruled to squash in this branch. $($TargetBranch) !=> $($CurrentBranch)";}

    [String]$squashmessage = "[SQUASH] $($TargetBranch) => $($CurrentBranch)`n`n";

    # Confirming with user
    if(!$Force)
    {
        if($(Read-Host -Prompt "Message: $($squashmessage)Confirm? (y/n)") -ne "y")
        {
            Write-Host "Cancelling merge." -ForegroundColor Gray;break;
        }
    }

    # Get commit differences
    [string]$gitfiletemp = "$($Global:AppPointer.Machine.GitRepoDir)\Cache\git\commits\SQUASH_$($CurrentBranch).temp.txt"; # Create temp file
    [string]$gitfile = "$($Global:AppPointer.Machine.GitRepoDir)\Cache\git\commits\SQUASH_$($CurrentBranch).txt"; # Create real file
    New-Item $gitfiletemp -Force | Out-Null; # Create the real file
    New-Item $gitfile -Force | Out-Null; # Create the real file

    # Get all commits from branch you are squashing
    [string]$gitcommand = "git log $($CurrentBranch)..$($TargetBranch)  --graph --pretty=format:`"[%h - %ad] %B`"  > $($gitfiletemp)"; # writing the git command
    Invoke-Expression $gitcommand; # Output commits to file 
    Add-Content $gitfile -Value $squashmessage; # Add squash message ontop of the commits stored in temp file
    Add-Content $gitfile -Value $(Get-Content $gitfiletemp);

    git merge $TargetBranch --squash; # Merge

    git commit -F $($gitfile); # Commit

    if($(Read-Host -Prompt "Delete $($TargetBranch)? (y/n)") -eq "y")
    {
        git branch -D $TargetBranch;
    }
}

function CreateNewBranch
{
    [System.Object[]]$VersionReader = Get-Content ($Global:AppPointer.Machine.GitRepoDir + "\Config\Versioning\Version.JSON") | ConvertFrom-Json;

    [string]$BranchNameDelimiter = $VersionReader.BranchNameDelimiter; # Doing this because I might change to / 
    [String]$CurrentBranch = "$(git rev-parse --abbrev-ref HEAD)";

    Write-Host "Choose Type";
    for([int16]$i = 0;$i -lt $VersionReader.Branches.Count;$i++)
    {
        Write-Host "$($i+1) - $($VersionReader.Branches.Branch.Type[$i]) [$($VersionReader.Branches.Branch.Version[$i])]";
    }
    [String]$BranchName = $VersionReader.Branches.Branch.Type[$(Read-Host -Prompt "Which type?")-1] + $BranchNameDelimiter + $CurrentBranch + $BranchNameDelimiter;

    $BranchName += $(Read-Host -Prompt "Branch Description").Replace(" ", "");

    git checkout -b $BranchName; # Create branch
}