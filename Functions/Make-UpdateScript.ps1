[DateTime]$d = Get-Date;
Copy-Item $($PSScriptRoot + "\..\Config\UpdateConfig\Template\Template.ps1") $($PSScriptRoot + "\..\Config\UpdateConfig\" + $d.ToString('MMddyyyy') + ".ps1") -Verbose;