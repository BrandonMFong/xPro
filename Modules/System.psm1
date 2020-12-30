Import-Module $($PSScriptRoot +  '\xProUtilities.psm1') -DisableNameChecking;

function Hop 
{
    Param($j)
    if ($j -gt 0)
    {
        $j = $j - 1;
        Set-Location ..;
        hop $j;
    }
}

function Jump 
{
    Param($j)
    for($i = 0; $i -lt $j; $i++)
    {
        Set-Location ..;
    }
}

function Slide
{
    Param([int]$j)
    while($j -gt 0){Set-Locatioin ..;$j = $j - 1}
}

function CL {Clear-Host;Get-ChildItem;}

function Restart-Session
{
    Param([Alias('s')][Switch]$DontSaveDir)
    _CacheDir -DontSaveDir:$DontSaveDir;

    if($PSVersionTable.PSVersion.Major -lt 7){Start-Process powershell;Stop-Process -Id $PID;}
    else{Start-Process pwsh;Stop-Process -Id $PID;}
}
function Start-Admin
{
    Param([Alias('s')][Switch]$DontSaveDir)
    _CacheDir -DontSaveDir:$DontSaveDir;

    if($PSVersionTable.PSVersion.Major -lt 7){Start-Process powershell -Verb Runas;}
    else{Start-Process pwsh -Verb Runas;}
}

function _CacheDir
{
    Param([Alias('s')][Switch]$DontSaveDir)
    # this creates the file regardless, so I can delete the file in the profile script 
    if(!$DontSaveDir){New-Item $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Files.SessionCache) -Force -Value $(Get-Location).Path | Out-Null;}
}

function List-Color{[Enum]::GetValues([System.ConsoleColor])}
function Open-Settings{start ms-settings:;}
function Open-Bluetooth{start ms-settings:bluetooth;}
function Open-Display{start ms-settings:display;}

function Get-BatteryLife
{
    if($PSVersionTable.PSVersion.Major -lt 7){Write-Host "Battery @ $((Get-WmiObject win32_battery).EstimatedChargeRemaining )%" -ForegroundColor Cyan;}
    else{Write-Host "Battery @ $((Get-CimInstance win32_battery).EstimatedChargeRemaining )%" -ForegroundColor Cyan;}
}

function Set-Brightness
{
    param([int]$Percentage)
    try
    {
        $monitor = Get-WmiObject -ns root/wmi -class wmiMonitorBrightNessMethods
        $monitor.WmiSetBrightness(0,$Percentage)
    }
    catch 
    {
        if($PSVersionTable.PSVersion.Major -lt 7){$Global:LogHandler.WriteError("Something bad happened");}
        else{$Global:LogHandler.Warning("This will not work in pwsh");}
    }
}

function Reload-Profile 
{
    param([Switch]$StartScript)
    if($StartScript){.$PROFILE -StartDir:$false -StartScript:$true;}
    else{.$PROFILE -StartDir:$false -StartScript:$false;}
}

function Toggle-Load 
{
    param([Switch]$Restart)
    $Global:XMLReader.Machine.LoadProfile = (!$Global:XMLReader.Machine.LoadProfile.ToBoolean($null)).ToString();
    $Global:XMLReader.Save($($Global:AppPointer.Machine.GitRepoDir + "\Config\Users\" + $Global:AppPointer.Machine.ConfigFile));
    if($Restart){Restart-Session;}
}

function Get-Size
{
    Param
    (
        [String]$Item,
        [ValidateSet('Giga','Mega','Kilo')][String]$Type
    )
    if($Type.Equals('Giga')){return (Get-ChildItem $Item | Measure-Object Length -Sum).Sum/1GB; }
    elseif($Type.Equals('Mega')){return (Get-ChildItem $Item | Measure-Object Length -Sum).Sum/1MB; }
    elseif($Type.Equals('Kilo')){return (Get-ChildItem $Item | Measure-Object Length -Sum).Sum/1KB; }
    else{return (Get-ChildItem $Item | Measure-Object Length -Sum).Sum; }
}

# This clears ALL cache
function Clear-Cache
{
    Param([ValidateSet("git","Greetings","Calendar")][String]$CacheType,[switch]$CurrentDir)
    switch($CacheType)
    {
        "git"
        {
            # Use if you want to refresh current directory cache
            # Purpose is to refresh the directory if the directory became a git from a regular dir
            [string]$ParsedDirectory = $null; # Assuming no directory initially
            if($CurrentDir){$ParsedDirectory = "\" + (Get-Location).Path.ToString().Replace("\",".").Replace(":","");}
            Remove-Item $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.gitCache + $ParsedDirectory) -Recurse -Force;
        }
        "Greetings"{Remove-Item $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.GreetingsCache) -Recurse -Force;}
        "Calendar"{Remove-Item $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.CalendarCache) -Recurse -Force;}
        default{Remove-Item $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.UserCache + "\*") -Recurse -Force;}
    }
    
}

function goto 
{
<#
.Synopsis
	This relates an alias to a directory and sets the directory location to alias/dir relationship
.Description
	Useful to easily jump to a directory without writing out the whole path
.Parameter push
	Push-Location instead of set-location
.Example
	Goto CDrive -p 
.Notes

#>
    Param([String]$dir, [Alias('p')][Switch]$push)
    # Import-Module $($PSScriptRoot + "\..\Modules\xProUtilities.psm1") -Scope Local;
    [bool]$ProcessExecuted = $false;
    
    foreach ($Directory in $(Get-Variable 'XMLReader').Value.Machine.Directories.Directory)
    {
        if($Directory.alias -eq $dir)
        {
            [String]$result = $(Evaluate -value:$Directory -IsDirectory:$true);
            if($push){Push-Location $result; $ProcessExecuted = $true;break;}
            else{Set-Location $result; $ProcessExecuted = $true;break;}
        }
        
    }

    # Test to see if this is a directory
    if(Test-Path $dir)
    {
        if($push){Push-Location $dir; $ProcessExecuted = $true;}
        else{Set-Location $dir; $ProcessExecuted = $true;}
    }

    if(!($ProcessExecuted))
    {
        $global:LogHandler.Write("Parameter '$($dir)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag");
        Write-Warning "Parameter '$($dir)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag";
    }
    else{$global:LogHandler.Write("Jumped to $($result)");}

}

function Get-Calendar
{
<#
.Synopsis
    Utilizes the Calendar class to display months
    This requires that the user has a Calendar type object
.Description
    
.Parameter <Name>

.Example

.Notes
    
#>
    param
    (
        [ValidateSet(
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        )]
        [string]$month,
        [switch]$Current,
        [switch]$Events,
        [switch]$InsertEvents
    )
    Import-Module $($PSScriptRoot + "\..\Modules\xProUtilities.psm1");
    $var = $(GetObjectByClass('Calendar'));

    if($Events)
    {
        Write-Host "`n";
        $var.Events();
        Write-Host "`n";
        break;
    }
    if($InsertEvents){$var.InsertEvents();break;}
    else 
    {
        Write-Host "`n";
        switch ($month)
        {
            "January"{$var.GetMonth("January");break;}
            "February"{$var.GetMonth("February");break;}
            "March"{$var.GetMonth("March");break;}
            "April"{$var.GetMonth("April");break;}
            "May"{$var.GetMonth("May");break;}
            "June"{$var.GetMonth("June");break;}
            "July"{$var.GetMonth("July");break;}
            "August"{$var.GetMonth("August");break;}
            "September"{$var.GetMonth("September");break;}
            "October"{$var.GetMonth("October");break;}
            "November"{$var.GetMonth("November");break;}
            "December"{$var.GetMonth("December");break;}
            default{$var.GetMonth();break;}
        }
        Write-Host "`n";
    }

}