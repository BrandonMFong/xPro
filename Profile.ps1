# Engineer: Brandon Fong
Param([bool]$StartDir=$true,[Bool]$StartScript=$true)

<### CONFIG ###>
Push-Location $($PROFILE |Split-Path -Parent);
    [XML]$AppPointer = Get-Content Profile.xml;
Pop-Location
[XML]$XMLReader = Get-Content $($AppPointer.Machine.GitRepoDir + "\Config\" + $AppPointer.Machine.ConfigFile);

if(!$XMLReader.Machine.LoadProfile.ToBoolean($null)){break;} # Flag to load profile (in case someone wanting to use powershell)
if($XMLReader.Machine.LoadProcedure -eq "Verbose"){[bool]$Verbose = $true} # Helps debugging if on
else{[bool]$Verbose = $false}

Push-Location $AppPointer.Machine.GitRepoDir; 
    Import-Module .\Modules\FunctionModules.psm1 -DisableNameChecking -Scope Local;

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){throw "Profile was updated, please rerun Profile load.";}

    <### GET CREDENTIALS ###>
    
    # Get credentials
    # Should this be in the beginning?
    if($XMLReader.Machine.Secure.ToBoolean($null) -and !$LoggedIn)
    {
        $cred = Get-Content ($AppPointer.Machine.GitRepoDir + "\bin\credentials\user.JSON") | ConvertFrom-Json  
        [string]$user = Read-Host -prompt "Username"; 

        # Get Secure string and then convert it back to plain text
        [System.Object]$var = Read-Host -prompt "Password" -AsSecureString; 
        [System.ValueType]$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($var)
        [String]$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        
        if(($user -ne $cred.Username) -or ($cred.Password -ne $password))
        {
            Write-Error "WRONG CREDENTIALS";
            Pop-Location;
            exit;
        }
        else{[Boolean]$LoggedIn = $true;}
    }

    # Background setting for write-progress
    Import-Module .\Modules\Terminal.psm1 -DisableNameChecking -Scope Local;
    _SetBackgroundColor;
        
    <### PROGRAMS ###> 
        LoadPrograms -XMLReader:$XMLReader -Verbose:$Verbose
    
    <### MODULES ###>
        LoadModules -XMLReader:$XMLReader -Verbose:$Verbose
        
    <### OBJECTS ###>
        LoadObjects -XMLReader:$XMLReader -Verbose:$Verbose
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        if(($XMLReader.Machine.StartScript.Enable -eq "true") -and ($StartScript)) {Invoke-Expression $($XMLReader.Machine.StartScript.InnerXML)}
    
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
