# update classes

$ModuleDirName = 'Classes';
$Destination = $($PROFILE | Split-Path -Parent) + '\' + $ModuleDirName;

Push-Location $PSScriptRoot;

    # Gets dates from each directory 
    Get-ChildItem *$ModuleDirName* |
        Where-Object{$_.Mode -eq 'd-----'}|
            ForEach-Object{$ClassesAtRepo = $_.LastWriteTime;}   
    Get-ChildItem $($PROFILE | Split-Path -Parent) |
        Where-Object{($_.Name -eq 'Classes') -and ($_.Mode -eq 'd-----')} |
            ForEach-Object{$ClassesAtProfDir = $_.LastWriteTime}
    
    Write-Host -NoNewline "`nChecking for updates to classes" -ForegroundColor Red;
    
    if ($ClassesAtProfDir.CompareTo($ClassesAtRepo) -lt 0)
    {
        Write-Host "There is an update to classes`n" -ForegroundColor Red;
        $prompt = Read-Host -Prompt "Want to update? (y/n)"
        if($prompt -eq 'y')
        {   
            # Archives all modules and removes when it overflows
            Push-Location $($($PROFILE | Split-Path -Parent) + '\' + $ModuleDirName)
                if($(Get-ChildItem .\archive).count -gt 0) {Remove-Item .\archive\*.*;}
                Archive; # Must have Archive configured
            Pop-Location

            # Copies updated modules to destination
            Push-Location $ModuleDirName;
                Get-ChildItem |
                    ForEach-Object{Copy-Item $_ $Destination;}
            Pop-Location
        }
        else{Write-Host "`nNot updating.`n" -ForegroundColor Red -BackgroundColor Yellow;}
    }
    else{Write-Host "`nNo updates.`n" -ForegroundColor Green;}
    Start-Sleep 1;
Pop-Location;