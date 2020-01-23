#Since my Microsoft Powershell profile is originally in this directory, I call this script to copy the script so I can push to the git repo
try
{
    GO-TO SC -p;
        Set-Location Profile;
        Append-Date; #appending today's date 
        Archive;
        Copy-Item $Profile .;
    Pop-Location;
}
catch 
{
    Pop-Location;
}