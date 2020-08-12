Import-Module $($PSScriptRoot +  '\FunctionModules.psm1') -DisableNameChecking;

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
    if($PSVersionTable.PSVersion.Major -lt 7){Start-Process powershell;Stop-Process -Id $PID;}
    else{Start-Process pwsh;Stop-Process -Id $PID;}
}
function Start-Admin{Start-Process powershell -Verb Runas;}

function List-Color{[Enum]::GetValues([System.ConsoleColor])}
function Open-Settings{start ms-settings:;}
function Open-Bluetooth{start ms-settings:bluetooth;}
function Open-Display{start ms-settings:display;}

function Get-BatteryLife
{
    if($PSVersionTable.PSVersion.Major -lt 7){Write-Host "Battery @ $((Get-WmiObject win32_battery).EstimatedChargeRemaining )%" -ForegroundColor Cyan;}
    else{Write-Host "Battery @ $((Get-CimInstance win32_battery).EstimatedChargeRemaining )%" -ForegroundColor Cyan;}
}

function Open-Clock{explorer.exe shell:Appsfolder\Microsoft.WindowsAlarms_8wekyb3d8bbwe!App}

# https://www.tenforums.com/software-apps/57000-method-open-any-windows-10-apps-command-line.html
function Open-Mail {explorer.exe shell:Appsfolder\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail}

function Open-Todo {explorer.exe shell:appsFolder\Microsoft.Todos_8wekyb3d8bbwe!App}

function Set-Brightness
{
    param([int]$Percentage)
    $monitor = Get-WmiObject -ns root/wmi -class wmiMonitorBrightNessMethods
    $monitor.WmiSetBrightness(0,$Percentage)
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
    $XMLReader.Machine.LoadProfile = (!$XMLReader.Machine.LoadProfile.ToBoolean($null)).ToString();
    $XMLReader.Save($($AppPointer.Machine.GitRepoDir + "\Config\" + $AppPointer.Machine.ConfigFile));
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

function Get-Info
{
    Write-Host "Computer Name: $($env:computername)";
    [double]$sum = 0;
    for([int]$i=0;$i -lt $(Get-CimInstance win32_physicalmemory).Capacity.Length;$i++)
    {
        $sum += $(Get-CimInstance win32_physicalmemory)[$i].Capacity;
    }
    Write-Host "RAM: $($sum/1gb) GB";
    for([int]$i = 0;$i -lt ($(Get-CimInstance CIM_LogicalDisk).Length);$i++)
    {
        if(![string]::IsNullOrEmpty($(Get-CimInstance CIM_LogicalDisk)[$i].FreeSpace))
        {
            Write-Host "Drive $($(Get-CimInstance CIM_LogicalDisk)[$i].DeviceID), " -NoNewLine;
            Write-Host "$($(Get-CimInstance CIM_LogicalDisk)[$i].FreeSpace/1gb) GB free";
        }
    }
}

# This clears ALL cache
function Clear-Cache
{
    Param([ValidateSet("git","Greetings")][String]$CacheType)
    switch($CacheType)
    {
        "git"{Remove-Item $($PSScriptRoot + "\..\Cache\git") -Recurse -Force;}
        "Greetings"{Remove-Item $($PSScriptRoot + "\..\Cache\Greetings") -Recurse -Force;}
        default{Remove-Item $($PSScriptRoot + "\..\Cache\") -Recurse -Force;}
    }
    
}