#Since my Microsoft Powershell profile is originally in this directory, I call this script to copy the script so I can push to the git repo
try
{
    goto PowershellRepoPath -p;
        Set-Location Profile;
        $FileName="Pass"; # Check function appendate file
        Get-ChildItem | 
            Where-Object{$_.Name -eq "Microsoft.PowerShell_profile.ps1"} | 
                ForEach-Object{$FileName = $_};
        Append -FileName $FileName; #appending today's date 
        if((Test-Path .\archive\) -AND ((Get-ChildItem .\archive\).count -gt 10)){Archive -Zip;}# TODO this puts the appended profile outside
        else{Archive;}
        Copy-Item $Profile .;
    Pop-Location;
}
catch 
{
    Pop-Location;
}