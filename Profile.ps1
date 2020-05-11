# Engineer: Brandon Fong
# TODO
# ...
Param([bool]$StartDir=$true)
<### CONFIG ###>
Push-Location $($PROFILE |Split-Path -Parent);
    [XML]$AppPointer = Get-Content Profile.xml;
Pop-Location
[XML]$XMLReader = Get-Content $($AppPointer.Machine.GitRepoDir + "\Config\" + $AppPointer.Machine.ConfigFile);

# Get credentials
# Should this be in the beginning?
if($XMLReader.Machine.Secure -eq "True")
{
    $cred = Get-Content ($AppPointer.Machine.GitRepoDir + "\bin\credentials\user.JSON") | ConvertFrom-Json  
    [string]$user = Read-Host -prompt "Username"; 
    $pw = Read-Host -prompt "Password" -AsSecureString; 
    $pw1 = ConvertFrom-SecureString $pw; 
    $pw2 = ConvertTo-SecureString $pw1; 
    $binarystr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw2);
    $pwstr = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($binarystr);

    $credpw = ConvertTo-SecureString -SecureString $cred.Password;
    $credbin = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credpw);
    $decpw = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($credbin)

    if(($user -ne $cred.Username) -or ($pwstr -ne $decpw))
    {
        Write-Error "WRONG CREDENTIALS";
        return;
    }
}
if($XMLReader.Machine.LoadProcedure -eq "Verbose"){[bool]$Verbose = $true}
else{[bool]$Verbose = $false}

Push-Location $AppPointer.Machine.GitRepoDir; 
    Import-Module .\Modules\FunctionModules.psm1 -DisableNameChecking -Scope Local;
    Import-Module .\Modules\Terminal.psm1 -DisableNameChecking -Scope Local;
    
    _SetBackgroundColor;

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){throw "Profile was updated, please rerun Profile load.";}
        
    <### PROGRAMS ###> 
        LoadPrograms -XMLReader:$XMLReader -Verbose:$Verbose
    
    <### MODULES ###>
        LoadModules -XMLReader:$XMLReader -Verbose:$Verbose
        
    <### OBJECTS ###>
        LoadObjects -XMLReader:$XMLReader -Verbose:$Verbose
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        if($XMLReader.Machine.StartScript.Enable -eq "true") {Invoke-Expression $($XMLReader.Machine.StartScript.InnerXML)}
    
    try 
    {
        [string]$gitstring = "Version: $(git describe --tags)"
        if($gitstring.Contains("-")){Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;}
        else {Write-Host "`n$($gitstring)`n" -ForegroundColor Gray;}
    }
    catch 
    {
        Write-Warning "You may not have posh-git installed in powershell"
    }

Pop-Location;

if($StartDir -and (![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.StartDirectory)))
{Set-Location $XMLReader.Machine.ShellSettings.StartDirectory;}