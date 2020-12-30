<#
.Notes
    Assumes you have git as an env path or you have set it in the programs config
#>
Import-Module $PSScriptRoot\xProUtilities.psm1 -Scope Local;

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
        [string]$Tag=$null,# Case sensitive
        [Switch]$Push,
        [Switch]$Whatif,
        [System.Object[]]$VersionReader=[System.Object[]]::new($null)
    )

    # Do I need this?  I would need to reorganize how I call this if I assume the user will always use the repo
    # [string]$VersionFile = "\Config\Versioning\Version.JSON"; # TODO need to decide a general location through repos
    if([string]::IsNullOrEmpty($VersionReader.BranchNameDelimiter))
    {
        # [string]$VersionFile = $Global:AppJson.Files.Config.Versioning;
        [System.Object[]]$VersionReader = Get-Content ($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Files.Config.Versioning) | ConvertFrom-Json;
    }
    [string]$VersionDelimiter = "."; # setting up for future config

    Write-Host "`n"; # start new line 
    
    if(![string]::IsNullOrEmpty($Tag)){Write-Host "Tagging for $($Tag)";}

    [String]$currenttag = "$(git describe --tags)";

    [Hashtable]$TagArray = @{};
    if([string]::IsNullOrEmpty($currenttag))
    {
        for([int]$i = 0;$i -lt $VersionReader.Versions.Version.count;$i++)
        {
            $TagArray.Add($VersionReader.Versions.Version[$i],0);
        }
    }
    else 
    { 
        try{if($currenttag.Contains("-")){$currenttag = $currenttag.Substring(0,$currenttag.IndexOf("-"));}} # get all the left side of - if applicable 
        catch{Write-Host "Something bad happened";}

        try
        {
            Write-Host "Current tag: $($currenttag)";
            for([int]$i = 0;$i -lt $VersionReader.Versions.Version.count;$i++) # go through the config
            {
                if($currenttag.Contains($VersionDelimiter)) # if the currenttag has the delimiter
                { 
                    $TagArray.Add($VersionReader.Versions.Version[$i],$currenttag.Substring(0,$currenttag.IndexOf($VersionDelimiter))); # put the tag in a hash table
                    
                    # disect the tag
                    # +1 to include the '.' so that we can take it out
                    [Regex]$regex = $currenttag.Substring(0,$currenttag.IndexOf($VersionDelimiter)+1); 
                    $currenttag = $regex.Replace($currenttag,"",1);
                }
                else 
                {
                    $TagArray.Add($VersionReader.Versions.Version[$i],$currenttag); # if it doesn't have the delimiter then just use the tag right now
                    $currenttag = "0"; # in case this loop goes on again, need to null tag string
                }  

                Write-Host "$($VersionReader.Versions.Version[$i]) = $($TagArray.Item($VersionReader.Versions.Version[$i]))";
            }
        }
        catch{$Global:LogHandler.WriteError($_);}
    }


    # Applying the new tag
    [string]$dot = "";
    [string]$TagString = "";
    [boolean]$TagTypeIdentified = $false;
    for([int]$i = 0;$i -lt $VersionReader.Versions.Version.count;$i++) # go through the config
    {
        if(!$TagTypeIdentified -and $Tag.Equals($VersionReader.Versions.Version[$i]))
        {
            $TagTypeIdentified = $true;
            $TagString += $dot + "$($TagArray.Item($VersionReader.Versions.Version[$i]).ToInt32($null)+1)";
        }
        elseif($TagTypeIdentified){$TagString += $dot + "0";}
        else{$TagString += $dot + "$($TagArray.Item($VersionReader.Versions.Version[$i]))";}
        $dot = $VersionDelimiter;
    }
    if($TagString -eq $currenttag){Write-Host "Tag $($TagString) was already set!"; break;}

    # Tag
    Write-Host "***Post-Process Tag: $($TagString)***`n";
    if($Whatif)
    {
        Write-Host "`nEnd of whatif" -ForegroundColor Gray;
        return;
    }
    if(![string]::IsNullOrEmpty($tag))
    {
        git tag $TagString $CommitID;

        if($Push) # we check if we are pushing because we tagged
        {
            git fetch;
            git push --tags;
        }
    }

}


function Set-Commit
{
    Param([String]$Message,[Switch]$NotAll,
        [Switch]$NoType,[Switch]$Push,
        [String]$Tag=$null
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
        [string[]]$Types = $GitSettings.CommitTypes.CommitType;
        for([int16]$i = 0;$i -lt $Types.Count;$i++)
        {
            Write-Host "    $($i+1) - $($Types[$i])";
        }
        [int16]$NoneIndex = $i+1;
        Write-Host "    $($NoneIndex) - None";

        try{[Int16]$index = Read-Host -Prompt "So?";} # choose
        catch{$Global:LogHandler.Warning("Probably did not put the correct formatted input");break;}
        if(($index -ne 0) -and ($index -ne $NoneIndex)){$commitmessage += "[$($Types[$index-1])] ";} # Set the type in the string
    }
    
    [string]$msg = Read-Host -Prompt "Commit message";
    $commitmessage += $msg;

    git commit -m $commitmessage; # Set the commit
    Set-Tag -Tag:$Tag -Push:$Push; # push tags
    GitRebasePush; # push changes
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

    # if($Tags){git push --tags;}
}
function Squash-Branch
{
    <#
    .PARAMETER Force
        Bypass confirmation to squash 
    .PARAMETER Push
        Automatically push to remote after process is completed
    .PARAMETER Allow
        Allow other repos that are not following versioning process to use this function
    .PARAMETER Delete
        Delete branch and remote branch 
    #>
    Param([Switch]$Force,[Switch]$Push,[Switch]$Allow,[Alias('D')][Switch]$Delete)
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
    if(!$TargetBranch.Contains($CurrentBranch) -and !$Allow){throw "Target Branch is not ruled to squash in this branch. $($TargetBranch) !=> $($CurrentBranch).  If you want to use this function, use -Allow switch";}

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

    if(($(Read-Host -Prompt "Delete $($TargetBranch)? (y/n)") -eq "y") -or $D){git branch -D $TargetBranch;}
    if(($(Read-Host -Prompt "Delete remote $($TargetBranch)? (y/n)") -eq "y") -or $D){git push origin --delete $TargetBranch;}

    if($Push){GitRebasePush -Tags:$([string]::IsNullOrEmpty($Tag));}
}

function Create-Branch
{
    # [System.Object[]]$VersionReader = Get-Content ($Global:AppPointer.Machine.GitRepoDir + "\Config\Versioning\Version.JSON") | ConvertFrom-Json;
    [System.Object[]]$VersionReader = Get-Content ($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Files.Config.Versioning) | ConvertFrom-Json;

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
    git push --set-upstream origin $BranchName; # push to origin 
}