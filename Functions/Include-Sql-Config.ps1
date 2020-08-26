<#
.Synopsis
    If user wants to include the SQL config, they can run this script to include it into their config file 
#>

[System.Xml.XmlDocument]$BaseConfig = Get-Content $($Global:AppPointer.Machine.GitRepoDir + $AppJson)