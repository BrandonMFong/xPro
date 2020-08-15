Import-Module $PSScriptRoot\FunctionModules.psm1 -Scope Local;

function Get-Tag
{
    [string]$gitstring = "Version: $(git describe --tags)";
    if($gitstring.Contains("-")){Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;}
    else {Write-Host "`n$($gitstring)`n" -ForegroundColor Gray;}
}

# function Push-With-Tag
# {
#     git push;git push --tags;
# }

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

# TODO how to make this configurable
function Set-Tag
{
    Param([string]$CommitID=$null,[Switch]$Major,[Switch]$Minor,[Switch]$BugPatch, [Switch]$Push)

    # Make sure this is the right order to do things
    [System.Object[]]$GitSettings = $(GetSettings -FilePath:$(Get-Location).path);

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

    [String]$tag = "$(git describe --tags)";
    if([string]::IsNullOrEmpty($tag))
    {
        Write-Host "Set first tag" -ForegroundColor Gray;
        [int16]$MajorString = 0;
        [int16]$MinorString = 0;
        [int16]$BugPatchString = 0;
    }
    else 
    {
        try{$tag = $tag.Substring(0,$tag.IndexOf("-"));}
        catch{$Global:LogHandler.WriteError($_);}

        try
        {
            $Global:LogHandler.Write("tag before MajorString $($tag)");
            [int]$MajorString = $tag.Substring(0,$tag.IndexOf("."));
            $Global:LogHandler.Write("MajorString = $($MajorString)");
            DisectTag([ref]$tag);
    
            $Global:LogHandler.Write("tag before MinorString $($tag)");
            [int]$MinorString = $tag.Substring(0,$tag.IndexOf("."));
            $Global:LogHandler.Write("MinorString = $($MinorString)");
            DisectTag([ref]$tag);
    
            $Global:LogHandler.Write("tag before BugPatchString $($tag)");
            [int]$BugPatchString = $tag; # At this point we are at the end
            $Global:LogHandler.Write("BugPatchString = $($BugPatchString)");
        }
        catch{$Global:LogHandler.WriteError($_);}
    }

    if($Major)
    {
        [String]$TagString = "$($MajorString+1).0.0";
    }
    elseif($Minor)
    {
        [String]$TagString = "$($MajorString).$($MinorString+1).0";
    }
    elseif($BugPatch)
    {
        [String]$TagString = "$($MajorString).$($MinorString).$($BugPatchString+1)";
    }
    else
    {
        $Global:LogHandler.Write("Switch was not passed");
        break;
    }
    
    if($TagString -eq $tag){$Global:LogHandler.Write("Tag $($TagString) was already set!"); break;}

    # Tag
    $Global:LogHandler.Write("Applying tag: $($TagString)");
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

        [Int16]$index = Read-Host -Prompt "So?"; # choose
        if(($index -ne 0) -and ($index -ne $NoneIndex)){$commitmessage += "[$($GitSettings.CommitTypes.CommitType[$index-1])] ";} # Set the type in the string
    }
    
    [string]$msg = Read-Host -Prompt "Commit message";
    $commitmessage += $msg;

    git commit -m $commitmessage; # Set the commit

    # Tag option
    switch($Tag)
    {
        "Major"{Set-Tag -Major;}
        "Minor"{Set-Tag -Minor;}
        "BugPatch"{Set-Tag -BugPatch;}
    }

    # Always rebase before you push
    if($Push){GitRebasePush}
}

function GitRebasePush
{
    Param([Switch]$Tags)
    # git push --set-upstream origin update-dev-DeleteLocalBranchAfterSquash

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

    [String]$squashmessage = "[SQUASH] $($TargetBranch) => $($CurrentBranch)";

    # Confirming with user
    if(!$Force)
    {
        if($(Read-Host -Prompt "Message: $($squashmessage) | Confirm (y/n)") -ne "y")
        {
            Write-Host "Cancelling merge." -ForegroundColor Gray;break;
        }
    }

    git merge $TargetBranch --squash; # Merge

    git commit -m $squashmessage; # Commit

    if($(Read-Host -Prompt "Delete $($TargetBranch)? (y/n)") -eq "y")
    {
        git branch -D $TargetBranch;
    }
}

# Test2