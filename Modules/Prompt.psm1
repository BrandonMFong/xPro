using module .\..\Classes\Tag.psm1;

function prompt
{
    [Tag]$tag = [Tag]::new();
    [Xml]$x = (Get-Content($PSScriptRoot + '\..\Config\' + (Get-Variable 'AppPointer').Value.Machine.ConfigFile));
    $prompt = $x.Machine.Prompt;

    # @ tag replacements

    # Username
    $username = ((Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty username) -split '\\' )[1]
    
    # Date
    if(($prompt.DateFormat -eq "") -or ($prompt.DateFormat -eq "Default"))
    {$DateString = Get-Date -Format 'yyyy-dd-MM'}
    else
    {
        # Should not have time format chars
        $dstring = $prompt.DateFormat.Replace("m","");
        $dstring = $prompt.DateFormat.Replace("h","");
        $dstring = $prompt.DateFormat.Replace("s","");
        $dstring = $prompt.DateFormat.Replace("t","");
        $DateString = Get-Date -Format $dstring;
    }

    # Current directeory
    $CurrentDir = $((Get-Location).Path | Split-Path -Leaf); 
   
    # Full directory path
    $FullDir = $((Get-Location).Path);
    
    # Time
    if(($prompt.TimeFormat -eq "") -or ($prompt.DateFormat -eq "Default"))
    {$TimeString = Get-Date -Format 'hh:mm:ss'}
    else
    {
        # Should not have day format chars
        $tstring = $prompt.TimeFormat.Replace("M","");
        $tstring = $prompt.TimeFormat.Replace("d","");
        $tstring = $prompt.TimeFormat.Replace("y","");
        $TimeString = Get-Date -Format $tstring;
    }

    # Battery Life
    $BatteryPercent = (Get-WmiObject win32_battery).EstimatedChargeRemaining;

    # Prompt output
    if(($prompt.String.InnerXml -eq "Default") -or ($prompt.String.InnerXml -eq "") -or ([string]::IsNullOrEmpty($XMLReader.Machine.Prompt)))
    {"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";}
    else 
    {
        [string]$OutString = $prompt.String.InnerXml;
        $OutString = $OutString.Replace($tag.user, $username);
        $OutString = $OutString.Replace($tag.date, $DateString);
        $OutString = $OutString.Replace($tag.currentdir, $CurrentDir);
        $OutString = $OutString.Replace($tag.fulldir, $FullDir);
        $OutString = $OutString.Replace($tag.time, $TimeString);
        $OutString = $OutString.Replace($tag.batteryperc, $BatteryPercent);
        $OutString = $OutString.Replace("&gt","`>");
        $OutString = $OutString.Replace(";","");

        if($prompt.String.Color -eq "")
        {
            if(($prompt.BaterryLifeThreshold.Enabled -eq "true") -and ($BatteryPercent -lt $prompt.BaterryLifeThreshold.InnerXml))
            {
                Write-Host ("$($OutString)") -ForegroundColor Red -NoNewline
            }
            else 
            {
                Write-Host ("$($OutString)") -ForegroundColor White -NoNewline
            }
        }
        else
        {
            if(($prompt.BaterryLifeThreshold.Enabled -eq "true") -and ($BatteryPercent -lt $prompt.BaterryLifeThreshold.InnerXml))
            {
                Write-Host ("$($OutString)") -ForegroundColor Red -NoNewline
            }
            else 
            {
                Write-Host ("$($OutString)") -ForegroundColor $prompt.String.Color -NoNewline;
            }
        }
        return " ";
    }

}
