using module .\..\Classes\Tag.psm1;

Import-Module $PSScriptRoot\FunctionModules.psm1 -Scope Local;

# Git info 
# [HashTable]$_GitInfo = @{"Path"=""};

# Prompt output
[Xml]$x = $Global:XMLReader;
[System.Boolean]$ShellSettingsEnabled = $x.Machine.ShellSettings.Enabled.ToBoolean($null);
[System.Boolean]$ShellSettingsPrompt = [string]::IsNullOrEmpty($x.Machine.ShellSettings.Prompt.String);
[System.Boolean]$PromptText = ($x.Machine.ShellSettings.Prompt.String.InnerText -ne "Default");
if($ShellSettingsEnabled -and !$ShellSettingsPrompt -and $PromptText)
{
    function prompt
    {
        [System.Xml.XmlElement]$prompt = $XMLReader.Machine.ShellSettings.Prompt;
        _SetHeader; # Sets Header
        # _SetBackgroundColor; # Sets BG color

        if($prompt.Enabled.ToBoolean($null) -and (![string]::IsNullOrEmpty($prompt)))
        {
            [string]$OutString = $XMLReader.Machine.ShellSettings.Prompt.String.InnerXml;
            
            _Replace([ref]$OutString); # Form the prompt string
    
            if(($prompt.BaterryLifeThreshold.Enabled -eq "True") -and ($(GetBatteryStatus) -lt $prompt.BaterryLifeThreshold.InnerXml))
            {Write-Host ("$($OutString)") -ForegroundColor Red -NoNewline;}
            else {Write-Host ("$($OutString)") -ForegroundColor $(_EvalColor($prompt.String.Color)) -NoNewline;}
            
            return " ";
        }
    }
}
function _Replace 
{
    Param([ref]$OutString)
    try 
    {
        [Tag]$tag = [Tag]::new();
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
    
            if($GitDisplay.Enabled.ToBoolean($null))
            {
                # Cache-Aside pattern: using counter
                # GitCachePath is only created if it was a git repo
                [String]$GitCachePath = $($PSScriptRoot+"\..\Cache\git\"+$((Get-Location).Path).Replace("\",".").Replace(":",".").Replace("..","."));
    
                # If there is a file and the first row on the file is less than the cache count number, then set git display values that are cached
                # There are two else statements because there are two unique else cases and I cannot think of another way to consolidate without an exception being thrown
                # I can probably put a try/catch. hmmmmm
                if(Test-Path $GitCachePath)
                {
                    [string[]]$GitCacheReader = Get-Content $GitCachePath;
                    if($GitCacheReader[0].ToInt16($null) -lt $GitDisplay.CacheCount.ToInt16($null))
                    {
                        $BranchString = $GitCacheReader[1]; # Branch
        
                        # update cache values
                        New-Item $GitCachePath -Force -Value "$($GitCacheReader[0].ToInt16($null)+1)`n$BranchString"|Out-Null;
                    }
                    else {GetGitValues -BranchString:$([ref]$BranchString) -GitCachePath:$GitCachePath -GitDisplay:$GitDisplay}
                }
                else {GetGitValues -BranchString:$([ref]$BranchString) -GitCachePath:$GitCachePath -GitDisplay:$GitDisplay}
    
                # Add to Outstring
                if(![string]::IsNullOrEmpty($BranchString)){$BranchString = " ($($BranchString)) ";} # Default is ()
                $OutString.Value = $OutString.Value.Replace($tag.gitbranch,$BranchString); 
            }
            else{$OutString.Value = $OutString.Value.Replace($tag.gitbranch,'');}
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
    catch 
    {
        $Global:LogHandler.WriteError($_);
    }
}


function GetGitValues
{
    Param([ref]$BranchString,[String]$GitCachePath,[System.Object[]]$GitDisplay)
    # Runs through the git commands so it can update the gitdisplay string
    # We also have to make sure where we are at is a git repo
    # will replace if null since git rev-parse --abbrev-ref HEAD returns nothing if not in git repo
    $BranchString.Value = "$(git rev-parse --abbrev-ref HEAD)"; # This checks if we are in a branch

    # Will not make a cache file this is not a git repo
    if(![string]::IsNullOrEmpty($BranchString.Value))
    {
        # Staged and Unstaged
        if($GitDisplay.Unstaged.ToBoolean($null)){[string]$gitchangesUnstaged = "$(git diff --exit-code)";}
        if($GitDisplay.Staged.ToBoolean($null)){[string]$gitchangesStaged = "$(git diff --cached)";}
        if(![string]::IsNullOrEmpty($gitchangesUnstaged) -or ![string]::IsNullOrEmpty($gitchangesStaged))
        {
            $BranchString.Value += "*";
        }

        # Commits
        if(![string]::IsNullOrEmpty($GitDisplay.Commits) -and $GitDisplay.Commits.ToBoolean($null))
        {
            [string[]]$gitchangesCommits = git log "@{u}.." --oneline;
            if($gitchangesCommits.Length -gt 0){$BranchString.Value += ", commits: $($gitchangesCommits.Length)";}
        }

        # Cache the git values
        # No item will be made if it is inside this if statement and we are not in a git repo
        New-Item $GitCachePath -Force -Value "0`n$($BranchString.Value)"|Out-Null; 
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