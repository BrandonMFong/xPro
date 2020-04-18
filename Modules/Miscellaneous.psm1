# Functions that are often used on the command line

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
        [switch]$AddDirectory
    )
    if($AddDirectory)
    {
        $PathToAdd = (Get-Location).path; # Get the directory you are adding
        Push-Location $PSScriptRoot;
            $add = $(Get-Variable 'XMLReader').Value.CreateElement("Directory"); 

            $Alias = Read-Host -Prompt "Set Alias";
            $add.SetAttribute("alias", $Alias);

            $Security = Read-Host -Prompt "Is this private? (y/n)?";
            if($Security -eq "y")
            {
                $add.SetAttribute("SecurityType", "private");
                
                $insert = GetObjectByClass('SQL');
                [int]$MaxID = $insert.GetMax('PersonalInfo');
                [string]$GuidString = $insert.GetGuidString();
                [string]$subject = Read-Host -Prompt "Subject?";
                [int]$TypeContentID = ($insert.Query("select id as ID from typecontent where externalid = 'PrivateDirectory'")).ID; # id must exist
                $querystring = "insert into PersonalInfo values ($($MaxID), $($GuidString),'$($PathToAdd)', '$($subject)', $($TypeContentID))";

                Write-Host "`nQuery: " -NoNewline;Write-Host "$($querystring)`n" -foregroundcolor Cyan;
                $insert.Query($querystring);

                $Var = ($insert.Query("select guid as Guid from personalinfo where id = $($MaxID)")).Guid;
                $add.InnerXml = $Var.Guid; # Adding guid
            }
            else
            {
                $add.SetAttribute("SecurityType", "public")
                $add.InnerXml = $PathToAdd; # Adding literally path
            }
            
            $x = $(Get-Variable 'XMLReader').Value
            $x.Machine.Directories.AppendChild($add);
            $x.Save($(Get-Variable 'AppPointer').Value.Machine.GitRepoDir + '\Config\' + $(Get-Variable 'AppPointer').Value.Machine.ConfigFile);
        Pop-Location;
        break;
    }

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