using module .\..\Classes\Tag.psm1;

function prompt
{
    [Tag]$tag = [Tag]::new();
    [Xml]$x = (Get-Content($PSScriptRoot + '\..\Config\' + (Get-Variable 'AppPointer').Value.Machine.ConfigFile));
    $prompt = $x.Machine.Prompt;

    # @ tag replacements
    $username = ((Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty username) -split '\\' )[1]
    $DateString = Get-Date -Format $prompt.DateFormat;
    $CurrentDir = $((Get-Location).Path | Split-Path -Leaf); 
    $FullDir = $((Get-Location).Path);

    if(($prompt.String.InnerXml -eq "Default") -or ($prompt.String.InnerXml -eq ""))
    {"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";}
    else 
    {
        [string]$OutString = $prompt.String.InnerXml;
        $OutString = $OutString.Replace($tag.user, $username);
        $OutString = $OutString.Replace($tag.date, $DateString);
        $OutString = $OutString.Replace($tag.currentdir, $CurrentDir);
        $OutString = $OutString.Replace($tag.fulldir, $FullDir);
        $OutString = $OutString.Replace("&gt","`>");
        $OutString = $OutString.Replace(";","");
        if($prompt.String.Color -eq ""){Write-Host ("$($OutString)") -ForegroundColor White -NoNewline}
        else{Write-Host ("$($OutString)") -ForegroundColor $prompt.String.Color -NoNewline;}
        return " "
    }

}
