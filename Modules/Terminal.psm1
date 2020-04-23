using module .\..\Classes\Tag.psm1;

function _Replace 
{
    Param([ref]$OutString)
    [Tag]$tag = [Tag]::new();
    [Xml]$x = (Get-Content($PSScriptRoot + '\..\Config\' + (Get-Variable 'AppPointer').Value.Machine.ConfigFile));
    $format = $x.Machine.ShellSettings.Format;
    # @ tag replacements

    # Username
    if($OutString.Value.Contains($tag.user))
    {$OutString.Value = $OutString.Value.Replace($tag.user, $(((Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty username) -split '\\' )[1]));}
    
    # Date
    if($OutString.Value.Contains($tag.date))
    {
        if(($format.Date -eq "") -or ($format.Date -eq "Default"))
        {$DateString = Get-Date -Format 'yyyy-dd-MM'}
        else
        {
            # Should not have time format chars
            $dstring = $format.Date.Replace("m","");
            $dstring = $format.Date.Replace("h","");
            $dstring = $format.Date.Replace("s","");
            $dstring = $format.Date.Replace("t","");
            $DateString = Get-Date -Format $dstring;
        }
        $OutString.Value = $OutString.Value.Replace($tag.date, $DateString);
    }

    # Current directeory
    if($OutString.Value.Contains($tag.currentdir)){$OutString.Value = $OutString.Value.Replace($tag.currentdir, $((Get-Location).Path | Split-Path -Leaf));}
   
    # Full directory path
    if($OutString.Value.Contains($tag.fulldir)){$OutString.Value = $OutString.Value.Replace($tag.fulldir, $((Get-Location).Path));}
    
    # Time
    if($OutString.Value.Contains($tag.time))
    {
        if(($format.Time -eq "") -or ($format.Date -eq "Default"))
        {$TimeString = Get-Date -Format 'hh:mm:ss'}
        else
        {
            # Should not have day format chars
            $tstring = $format.Time.Replace("M","");
            $tstring = $format.Time.Replace("d","");
            $tstring = $format.Time.Replace("y","");
            $TimeString = Get-Date -Format $tstring;
        }
        $OutString.Value = $OutString.Value.Replace($tag.time, $TimeString);
    }

    # Battery Life
    if($OutString.Value.Contains($tag.batteryperc)){$OutString.Value = $OutString.Value.Replace($tag.batteryperc, $((Get-WmiObject win32_battery).EstimatedChargeRemaining));}

    # Greater than sign
    if($OutString.Value.Contains($tag.greaterthan)){$OutString.Value = $OutString.Value.Replace($tag.greaterthan,"`>");}
}

function _GetHeader
{
    [Xml]$x = (Get-Content($PSScriptRoot + '\..\Config\' + (Get-Variable 'AppPointer').Value.Machine.ConfigFile));
    [string]$OutString = $x.Machine.ShellSettings.Header.String;
    _Replace([ref]$OutString);
    if(($x.Machine.ShellSettings.Header.Enabled -eq "False") -or ([string]::IsNullOrEmpty($x.Machine.ShellSettings.Header)))
    {$OutString = $Host.UI.RawUI.WindowTitle}
    return $OutString;
}
function prompt
{
    $Host.UI.RawUI.WindowTitle = _GetHeader; # Sets Header
    [Xml]$x = (Get-Content($PSScriptRoot + '\..\Config\' + (Get-Variable 'AppPointer').Value.Machine.ConfigFile));
    $prompt = $x.Machine.ShellSettings.Prompt;
    [string]$OutString = $x.Machine.ShellSettings.Prompt.String.InnerXml;
    
    _Replace([ref]$OutString);

    # Prompt output
    if(($prompt.String.InnerXml -eq "Default") -or ($prompt.Enabled -eq "False") -or ([string]::IsNullOrEmpty($x.Machine.ShellSettings.Prompt)))
    {"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";}
    else 
    {
        if($prompt.String.Color -eq "")
        {
            if(($prompt.BaterryLifeThreshold.Enabled -eq "true") -and ($((Get-WmiObject win32_battery).EstimatedChargeRemaining) -lt $prompt.BaterryLifeThreshold.InnerXml))
            {Write-Host ("$($OutString)") -ForegroundColor Red -NoNewline;}
            else {Write-Host ("$($OutString)") -ForegroundColor White -NoNewline;}
        }
        else
        {
            if(($prompt.BaterryLifeThreshold.Enabled -eq "true") -and ($((Get-WmiObject win32_battery).EstimatedChargeRemaining) -lt $prompt.BaterryLifeThreshold.InnerXml))
            {Write-Host ("$($OutString)") -ForegroundColor Red -NoNewline;}
            else {Write-Host ("$($OutString)") -ForegroundColor $prompt.String.Color -NoNewline;}
        }
        return " ";
    }
}