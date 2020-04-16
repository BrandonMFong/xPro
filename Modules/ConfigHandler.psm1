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
                # Do an insert query and get the guid
                # This is type PrivateDirectory so should be easy
            }
            else{$add.SetAttribute("SecurityType", "public");}
            
            $add.InnerXml = $PathToAdd;
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


