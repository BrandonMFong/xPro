
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
        $tag = $tag.Substring(0,$tag.IndexOf("-"));
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
    
    # Tag
    git tag $TagString $CommitID;

    if($Push){Push-With-Tag;}
}