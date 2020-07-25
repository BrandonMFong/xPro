using module .\..\Classes\Tag.psm1;

Import-Module $PSScriptRoot\FunctionModules.psm1 -Scope Local;

function _Replace 
{
    Param([ref]$OutString)
    [Tag]$tag = [Tag]::new();
    # [Xml]$x = _GetXMLContent;
    $format = $XMLReader.Machine.ShellSettings.Format;
    # @ tag replacements

    # Username
    if($OutString.Value.Contains($tag.user))
    {$OutString.Value = $OutString.Value.Replace($tag.user, $([System.Environment]::UserName));}
    
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
    if($OutString.Value.Contains($tag.batteryperc)){$OutString.Value = $OutString.Value.Replace($tag.batteryperc, $(GetBatteryStatus));}

    # Greater than sign
    if($OutString.Value.Contains($tag.greaterthan)){$OutString.Value = $OutString.Value.Replace($tag.greaterthan,"`>");}

    # Git Branch
    [System.Object[]]$GitDisplay = $x.Machine.ShellSettings.GitDisplay;
    if($OutString.Value.Contains($tag.gitbranch))
    {
        [string]$BranchString = $null;
        $BranchString = "$(git rev-parse --abbrev-ref HEAD)"; # This checks if we are in a branch
        if(![string]::IsNullOrEmpty($BranchString) -and $GitDisplay.Enabled.ToBoolean($null))
        {
            # If user wants
            # Having it all enabled can reduce performance
            if(![string]::IsNullOrEmpty($GitDisplay.Unstaged) -and $GitDisplay.Unstaged.ToBoolean($null)){$gitchangesUnstaged = "$(git diff --exit-code)";}
            if(![string]::IsNullOrEmpty($GitDisplay.Staged) -and $GitDisplay.Staged.ToBoolean($null)){$gitchangesStaged = "$(git diff --cached)";}
            if(![string]::IsNullOrEmpty($GitDisplay.Commits) -and $GitDisplay.Commits.ToBoolean($null)){[string[]]$gitchangesCommits = git log "@{u}.." --oneline;}

            if(![string]::IsNullOrEmpty($gitchangesUnstaged) -or ![string]::IsNullOrEmpty($gitchangesStaged)){$BranchString += "*";} # for changes
            if(![string]::IsNullOrEmpty($gitchangesStaged) -and !$BranchString.Contains('*')){$BranchString += "*";} # for changes
            if(![string]::IsNullOrEmpty($gitchangesCommits)){$BranchString += ", commits: $($gitchangesCommits.Length)";} # for commits

            # Add to Outstring
            if(![string]::IsNullOrEmpty($x.Machine.ShellSettings.Format.GitString))
            {[string]$gitstring = $x.Machine.ShellSettings.Format.GitString.Replace($tag.gitbranch,$BranchString);}
            else{[string]$gitstring = " ($($BranchString)) ";} # Default is ()
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
    if(($XMLReader.Machine.ShellSettings.Header.Enabled.ToBoolean($null)) -or (![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.Header)) -and ($XMLReader.Machine.ShellSettings.Header.String -ne "Default"))
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
    if(![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.ShellColors.ProgressForegroundColor) -and ![string]::IsNullOrEmpty($Host.PrivateData.ProgressForegroundColor))
    {$Host.PrivateData.ProgressForegroundColor = $XMLReader.Machine.ShellSettings.ShellColors.ProgressForegroundColor;}
    # ProgressBackgroundColor
    if(![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.ShellColors.ProgressBackgroundColor) -and ![string]::IsNullOrEmpty($Host.PrivateData.ProgressBackgroundColor))
    {$Host.PrivateData.ProgressBackgroundColor = $XMLReader.Machine.ShellSettings.ShellColors.ProgressBackgroundColor;}
}

# Prompt output
[Xml]$x = _GetXMLContent;
if(($x.Machine.ShellSettings.Enabled.ToBoolean($null)) -and (![string]::IsNullOrEmpty($x.Machine.ShellSettings.Prompt.String)) -and ($x.Machine.ShellSettings.Prompt.String.InnerText -ne "Default"))
{
    function prompt
    {
        [System.Xml.XmlElement]$prompt = $XMLReader.Machine.ShellSettings.Prompt;
        _SetHeader; # Sets Header
        _SetBackgroundColor; # Sets BG color

        if($prompt.Enabled.ToBoolean($null) -and (![string]::IsNullOrEmpty($prompt)))
        {
            [string]$OutString = $XMLReader.Machine.ShellSettings.Prompt.String.InnerXml;
            
            _Replace([ref]$OutString);
    
            if(($prompt.BaterryLifeThreshold.Enabled -eq "True") -and ($(GetBatteryStatus) -lt $prompt.BaterryLifeThreshold.InnerXml))
            {Write-Host ("$($OutString)") -ForegroundColor Red -NoNewline;}
            else {Write-Host ("$($OutString)") -ForegroundColor $(_EvalColor($prompt.String.Color)) -NoNewline;}
            
            return " ";
        }
    }
}

function _EvalColor([string]$Color)
{
    if([string]::IsNullOrEmpty($Color) -or ($Color -eq "Default")){return "White"}
    else{return $Color}
}

function GetBatteryStatus
{
    if($PSVersionTable.PSVersion.Major -lt 7){return (Get-WmiObject win32_battery).EstimatedChargeRemaining;}
    else{(Get-CimInstance win32_battery).EstimatedChargeRemaining;} # Powershell 7 removed the wmi objects
}