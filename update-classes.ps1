# update classes

$ModuleDirName = 'Classes';
$Destination = $($PROFILE | Split-Path -Parent) + '\' + $ModuleDirName;

Push-Location $PSScriptRoot;
    $ArchiveScriptPath = $PSScriptRoot + '\Functions\ARCHIVE.ps1'
    Set-Alias 'Archive-Files' $ArchiveScriptPath;

    # Gets dates from each directory 
    Get-ChildItem *$ModuleDirName* |
        Where-Object{$_.Mode -eq 'd-----'}|
            ForEach-Object{$ClassesAtRepo = $_.LastWriteTime;}   
    Get-ChildItem $($PROFILE | Split-Path -Parent) |
        Where-Object{($_.Name -eq 'Classes') -and ($_.Mode -eq 'd-----')} |
            ForEach-Object{$ClassesAtProfDir = $_.LastWriteTime}
    
    Write-Host -NoNewline "`nChecking for updates to classes`n" -ForegroundColor Red;
    
    if ($ClassesAtProfDir.CompareTo($ClassesAtRepo) -lt 0)
    {
        Write-Host "`nThere is an update to classes`n" -ForegroundColor Red;
        $prompt = Read-Host -Prompt "Want to update? (y/n)"
        if($prompt -eq 'y')
        {   
            # Archives all modules and removes when it overflows
            Push-Location $($($PROFILE | Split-Path -Parent) + '\' + $ModuleDirName)
                if(Test-Path .\archive\)
                {
                    if(($(Get-ChildItem .\archive).count -gt 0)) {Remove-Item .\archive\*.*;}
                }
                Archive-Files; 
            Pop-Location

            # Copies updated modules to destination
            Push-Location $ModuleDirName;
                Get-ChildItem |
                    ForEach-Object{Copy-Item $_ $Destination;}
            Pop-Location

            Write-Warning "Must restart session for updated classes to come to effect.";
            Start-Sleep 2;
        }
        else{Write-Host "`nNot updating.`n" -ForegroundColor Red -BackgroundColor Yellow;}
    }
    else{Write-Host "`nNo updates.`n" -ForegroundColor Green;}
    Start-Sleep 1;
Pop-Location;