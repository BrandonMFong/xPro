using module .\..\Classes\Tag.psm1;

Import-Module $PSScriptRoot\FunctionModules.psm1 -Scope Local;

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

    # Git Branch
    if($OutString.Value.Contains($tag.gitbranch))
    {
        [string]$BranchString = $null;
        $BranchString = "$(git rev-parse --abbrev-ref HEAD)";
        if(![string]::IsNullOrEmpty($BranchString))
        {
            [string]$gitchanges = $null;
            $gitchangesUnstaged = "$(git diff --exit-code)";
            $gitchangesStaged = "$(git diff --cached)";
            if(![string]::IsNullOrEmpty($gitchangesUnstaged) -or ![string]::IsNullOrEmpty($gitchangesStaged)){$BranchString += "*";} # for changes
            if(![string]::IsNullOrEmpty($gitchanges)){$BranchString += "*";} # for changes
            if(![string]::IsNullOrEmpty($x.Machine.ShellSettings.Format.GitString))
            {[string]$gitstring = $x.Machine.ShellSettings.Format.GitString.Replace($tag.gitbranch,$BranchString);}
            else{[string]$gitstring = " ($($BranchString)) ";}
            $OutString.Value = $OutString.Value.Replace($tag.gitbranch,$gitstring);
        }
        else{$OutString.Value = $OutString.Value.Replace($tag.gitbranch,'')}
    }

    # admin
    if($OutString.Value.Contains($tag.admin))
    {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq "True"){$OutString.Value = $OutString.Value.Replace($tag.admin," <Admin> ");}
        else{$OutString.Value = $OutString.Value.Replace($tag.admin,"");}
    }

    # Time Stamp
    if($OutString.Value.Contains($tag.stamp))
    {
        $var = GetObjectByClass('Calendar'); # If I want the timestamp, I am assuming it is already configured
        [string]$time = $var.GetTimeStampDuration();
        if(![string]::IsNullOrEmpty($time)){$OutString.Value = $OutString.Value.Replace($tag.stamp,$time);}
        else{$OutString.Value = $OutString.Value.Replace($tag.stamp,"");}
    }
}

function _SetHeader
{
    [string]$OutString = $XMLReader.Machine.ShellSettings.Header.String;
    _Replace([ref]$OutString);
    if(($XMLReader.Machine.ShellSettings.Header.Enabled -ne "False") -or (![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.Header)))
    {$Host.UI.RawUI.WindowTitle = $OutString}
}
function _SetBackgroundColor
{
    # BackgroundColor
    if(![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.ShellColors.BackgroundColor))
    {$Host.UI.RawUI.BackgroundColor = $XMLReader.Machine.ShellSettings.ShellColors.BackgroundColor;}
    # ForegroundColor
    if(![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.ShellColors.ForegroundColor))
    {$Host.UI.RawUI.ForegroundColor = $XMLReader.Machine.ShellSettings.ShellColors.ForegroundColor;}
    # ProgressForegroundColor
    if(![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.ShellColors.ProgressForegroundColor))
    {$Host.PrivateData.ProgressForegroundColor = $XMLReader.Machine.ShellSettings.ShellColors.ProgressForegroundColor;}
    # ProgressBackgroundColor
    if(![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.ShellColors.ProgressBackgroundColor))
    {$Host.PrivateData.ProgressBackgroundColor = $XMLReader.Machine.ShellSettings.ShellColors.ProgressBackgroundColor;}
}
function prompt
{
    _SetHeader; # Sets Header
    _SetBackgroundColor; # Sets BG color
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

# https://marco-difeo.de/2012/06/19/powershell-colorize-string-output-with-colorvariables-in-the-output-string/