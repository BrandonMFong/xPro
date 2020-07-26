
function Get-Tag
{
    [string]$gitstring = "Version: $(git describe --tags)"
    if($gitstring.Contains("-")){Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;}
    else {Write-Host "`n$($gitstring)`n" -ForegroundColor Gray;}
}

function Push-With-Tag
{
    git push;git push --tags;
}

function Set-Tag
{
    Param([string]$CommitID=$null,[Switch]$Major,[Switch]$Minor,[Switch]$BugPatch, [Switch]$Push)

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
        catch
        {
           Write-Host "`nError in $($PSScriptRoot)\$($MyInvocation.MyCommand.Name) at line: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red;
           Write-Host "`n$($_.Exception)`n" -ForegroundColor Red;
           # TODO add logs
        }
        [int]$MajorString = $tag.Substring(0,$tag.IndexOf("."));
        $tag = $tag.Replace($tag.Substring(0,$tag.IndexOf(".")+1),"");
        [int]$MinorString = $tag.Substring(0,$tag.IndexOf("."));
        $tag = $tag.Replace($tag.Substring(0,$tag.IndexOf(".")+1),"");
        [int]$BugPatchString = $tag; # At this point we are at the end
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
        throw "Please choose type of tag increment you want!";
    }
    
    if($TagString -eq $tag){throw "Tag $($TagString) was already set!";}

    # Tag
    git tag $TagString $CommitID;

    if($Push){Push-With-Tag;}
}

function Set-Commit
{
    Param([String]$Message,[Switch]$NotAll,[Switch]$NoType)

    if(!$NotAll)
    {
        git add -A; # By default, it will stage all changes
    }

    [String]$commitmessage = $null;

    # Run through the commit types if they are configured
    if(![string]::IsNullOrEmpty($XMLReader.Machine.GitSettings.CommitTypes.CommitType) -and !$NoType)
    {
        Write-Host "`nChoose from Commit types:";
        for([int16]$i = 0;$i -lt $XMLReader.Machine.GitSettings.CommitTypes.CommitType.Count;$i++)
        {
            Write-Host "    $($i+1) - $($XMLReader.Machine.GitSettings.CommitTypes.CommitType[$i])";
        }
        [int16]$NoneIndex = $i+2;
        Write-Host "    $($NoneIndex) - None";

        [Int16]$index = Read-Host -Prompt "So?"; # choose
        if(($index -ne 0) -and ($index -ne $NoneIndex)){$commitmessage += "[$($XMLReader.Machine.GitSettings.CommitTypes.CommitType[$index-1])] ";} # Set the type in the string
    }
    
    [string]$msg = Read-Host -Prompt "Commit message";
    $commitmessage += $msg;

    git commit -m $commitmessage; # Set the commit
}

function Set-CommitTag
{
    Param([Switch]$Major,[Switch]$Minor,[Switch]$BugPatch, [Switch]$Push)
    Set-Commit;

    # Default is bugpatch tag
    # Not using the commitid switch because since I am assuming the user is tagging the commit that was set before this
    if($Major)
    {
        Set-Tag -Major -Push:$Push;
    }
    elseif($Minor)
    {
        Set-Tag -Minor -Push:$Push;
    }
    elseif($BugPatch)
    {
        Set-Tag -BugPatch -Push:$Push;
    }
    else
    {
        throw "Please pass in a tag switch"
    }
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
        if($(Read-Host -Prompt "Message: $($squashmessage) | Confirm(y/n)") -ne "y")
        {
            Write-Host "Cancelling merge." -ForegroundColor Gray;break;
        }
    }

    git merge $TargetBranch --squash;

    git commit -m $squashmessage;
}

# Test2