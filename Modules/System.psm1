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

function Restart-Session{Start-Process powershell;exit;}
function Start-Admin{Start-Process powershell -Verb Runas;}

function List-Color{[Enum]::GetValues([System.ConsoleColor])}
function Open-Settings{start ms-settings:;}
function Open-Bluetooth{start ms-settings:bluetooth;}
function Open-Display{start ms-settings:display;}

function Get-BatteryLife{Write-Host "Battery @ $((Get-WmiObject win32_battery).EstimatedChargeRemaining )%" -ForegroundColor Cyan}

function Open-Clock{explorer.exe shell:Appsfolder\Microsoft.WindowsAlarms_8wekyb3d8bbwe!App}

function Config-Editor
{
    Param
    (
        [switch]$AddDirectory,
        [string]$AddProgram=$null
    )
    if($AddDirectory){InsertFromCmd -Tag "Directory" -PathToAdd $(Get-Location).Path;}
    if(![string]::IsNullOrEmpty($AddProgram)){InsertFromCmd -Tag "Program" -PathToAdd $(GetFullFilePath($AddProgram));}

}

function List-Directories
{
    Write-Host "`nDirectories and their aliases:`n" -ForegroundColor Cyan;
    foreach($d in $(Get-Variable 'XMLReader').Value.Machine.Directories.Directory)
    {
        Write-Host "$($d.alias)" -ForegroundColor Green -NoNewline;
        Write-Host " => " -NoNewline;
        Write-Host "$($d.InnerXML)" -ForegroundColor Cyan;
    }
    Write-Host `n;
}
function List-Programs
{
    Write-Host "`nPrograms, their aliases, and their type:`n" -ForegroundColor Cyan;
    foreach($p in $(Get-Variable 'XMLReader').Value.Machine.Programs.Program)
    {
        Write-Host "$($p.alias)" -ForegroundColor Green -NoNewline;
        Write-Host " => " -NoNewline;
        Write-Host "$($p.InnerXML)" -ForegroundColor Cyan -NoNewline;
        Write-Host " (" -NoNewline; Write-Host "$($p.Type)" -ForegroundColor Cyan -NoNewline; Write-Host ") ";
    }
    Write-Host `n;
}

function Reload-Profile {.$PROFILE}

function Git-Tag
{
    [string]$gitstring = "Version: $(git describe --tags)"
    Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;
}