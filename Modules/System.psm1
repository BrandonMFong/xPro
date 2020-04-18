# Functions that are often used on the command line
Import-Module $($PSScriptRoot +  '\FunctionModules.psm1') -DisableNameChecking -Scope Local;

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

function CL 
{
    Clear-Host;Get-ChildItem;
}

function Restart-Session
{
    Start-Process powershell;exit;
}
function Start-Admin
{
    Start-Process powershell -Verb Runas;
}

function List-Color
{
    [Enum]::GetValues([System.ConsoleColor])
}
function Open-Settings{start ms-settings:;}
function Open-Bluetooth{start ms-settings:bluetooth;}
function Open-Display{start ms-settings:display;}

function Get-BatteryLife{Write-Host "Battery @ $((Get-WmiObject win32_battery).EstimatedChargeRemaining )%" -ForegroundColor Cyan}

function Open-Clock{explorer.exe shell:Appsfolder\Microsoft.WindowsAlarms_8wekyb3d8bbwe!App}

function Volume
{
    # https://stackoverflow.com/questions/21355891/change-audio-level-from-powershell
    Param([double]$Adjust=0,[switch]$Up,[switch]$Down,[switch]$Mute,[switch]$Unmute)
Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume
{
    // f(), g(), ... are unused COM method slots. Define these if you care
    int f(); int g(); int h(); int i();
    int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
    int j();
    int GetMasterVolumeLevelScalar(out float pfLevel);
    int k(); int l(); int m(); int n();
    int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
    int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice
{
    int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator
{
    int f(); // Unused
    int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
public class Audio
{
    static IAudioEndpointVolume Vol()
    {
        var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
        IMMDevice dev = null;
        Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
        IAudioEndpointVolume epv = null;
        var epvid = typeof(IAudioEndpointVolume).GUID;
        Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
        return epv;
    }
    public static float Volume
    {
        get { float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v; }
        set { Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty)); }
    }
    public static bool Mute
    {
        get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
        set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
    }
}
'@
    if($Adjust -ne 0)
    {
        [Audio]::Volume = $Adjust * 0.01;
    }
    if($Up){[Audio]::Volume = [Audio]::Volume + (10 * 0.01);}
    if($Down){[Audio]::Volume = [Audio]::Volume - (10 * 0.01);}
    if($Mute){[Audio]::Volume = 0;}
    if($Unmute){[Audio]::Volume = 0.50;}
}


function Config-Editor
{
    Param
    (
        [switch]$AddDirectory,
        [string]$AddProgram=$null
    )
    if($AddDirectory){InsertFromCmd -Tag "Directories" -PathToAdd $(Get-Location).Path;}
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

function Append-Date
{
    Param([Alias('F')][Switch]$FileDate, [String]$FileName="Pass")

    if($FileDate) # this needs work
    {
        Get-ChildItem . | 
            Where-Object {$_.Attributes -eq "Archive"} | 
                ForEach-Object {$_.CreationTime | 
                    Sort-Object | 
                        Select-Object -Last 1 | 
                            ForEach-Object {$creationdate = $_;}$newname = $_.BaseName + "_" + $creationdate.month.ToString() + $creationdate.day.ToString() + $creationdate.year.ToString() + $_.extension;Rename-Item $_ $newname;}
        
        Write-Host "Appended file's creation date.";
        break;
    }
    elseif($FileName -ne "Pass")
    {
        $date = Get-Date;

        $append_string = $date.month.ToString() + $date.day.ToString() + $date.year.ToString() + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString();

        Get-ChildItem $FileName| 
            #Where-Object {$_.Attributes -eq "Archive";} |
                ForEach-Object {$newname = $_.BaseName + "_" + $append_string + $_.extension; Rename-Item $_ $newname;}
        
        Write-Host "Appended today's date to $($FileName)";
        break;
    }
    else
    { 
        $date = Get-Date;

        $append_string = $date.month.ToString() + $date.day.ToString() + $date.year.ToString() + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString();

        Get-ChildItem | 
            Where-Object {$_.Attributes -eq "Archive";} |
                ForEach-Object {$newname = $_.BaseName + "_" + $append_string + $_.extension; Rename-Item $_ $newname;}

        Write-Host "Appended today's date to all file in this directory.";
        break;
    }
}

function Archive
{
    Param([Alias('Z')][Switch]$Zip, [Switch]$OnlyZipFiles, [Switch]$OnlyFiles, [string]$FileName="Pass")

    if($Zip)
    {
        Test;
        if((Get-ChildItem .\archive\).count -gt 10)
        {
            $filename = "Archive_" + (Get-Date).Month.ToString() + (Get-Date).Day.ToString() + (Get-Date).Year.ToString();
            Set-Location .\archive\;
            mkdir $filename;
            Get-ChildItem | 
                Where-Object{($_.Extension -ne '.zip') -and ($_.Name -ne 'archive') -and ($_.Name -ne $filename)} | 
                    ForEach-Object{Move-Item $_ $filename;}
            $ZipName = $filename + '.zip';
            Compress-Archive $filename $ZipName;
            Remove-Item $filename;
            exit;
        }
        else
        {
            throw "Not enough files to compress.";
            exit;
        }
    }
    elseif($OnlyZipFiles)
    {
        Test;
        Get-ChildItem |
        Where-Object{($_.Extension -eq '.zip') -and ($_.Name -ne 'archive')} | 
        ForEach-Object{DoesFileExist($_);}
    }
    elseif($OnlyFiles)
    {
        Test;
        Get-ChildItem *.*|
        Where-Object{$_.Name -ne 'archive'} | 
        ForEach-Object{DoesFileExist($_);}
    }
    else 
    {
        Test;
        Get-ChildItem |
        Where-Object{($_.Extension -ne '.zip') -and ($_.Name -ne 'archive')} | 
        ForEach-Object{DoesFileExist($_);}
    }

}

function Goto 
{
    Param([String[]] $dir, [Alias('p')][Switch] $push)
    [bool]$ProcessExecuted = $false;
	foreach ($Directory in $(Get-Variable 'XMLReader').Value.Machine.Directories.Directory)
	{
		if($Directory.alias -eq $dir)
		{
			if($push){Push-Location $(Evaluate -value $Directory); $ProcessExecuted = $true;}
			else{Set-Location $(Evaluate -value $Directory); $ProcessExecuted = $true;}
		}
	}
	if(!($ProcessExecuted))
	{
		throw "Parameter '$($dir)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag";
	}
}

function Put 
{
    Param([String[]]$File, [Alias ('Dest')][String[]] $Destination)
    [bool]$ProcessExecuted = $false;
        
    foreach ($Directory in $XMLReader.Machine.Directories.Directory)
    {
        if($Directory.alias -eq $Destination)
        {
            move-item $File $(Evaluate -value $Directory); $ProcessExecuted = $true;
        }
    }
    if(!($ProcessExecuted))
    {
        throw "Parameter '$($Destination)' does match any aliases in the configuration.  Please check spelling.";
    }
}

function Query 
{
    param([alias('is')][switch]$inputstring,[string]$Decode="pass")
    $var = $(GetObjectByClass('SQL'));
    if(IsNotPass($Decode)){$var.InputCopy($Decode);}
    elseif($inputstring)
    {
        $x = Read-Host -Prompt "Query";
        $var.query($x);
    }
    else{Write-Host "Nothing passed" -foregroundcolor Red};
}

function Search 
{
    param([switch]$Google,[switch]$Sharepoint,[switch]$Dictionary,[switch]$Youtube)
    $var = $(GetObjectByClass('Web'));
    if($Google)
    {
        $v = read-host -prompt "Google"
        $var.Google($v);
    }
    elseif($Sharepoint)
    {
        $v = read-host -prompt "Sharepoint"
        $var.Sharepoint($v);
    }
    elseif($Dictionary)
    {
        $v = read-host -prompt "Dictionary"
        $var.Dictionary($v);
    }
    elseif($Youtube)
    {
        $v = read-host -prompt "Youtube"
        $var.Youtube($v);
    }
    else{throw "Nothing searched";}
}