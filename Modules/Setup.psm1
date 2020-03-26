function GetConfigName
{  
    Param($n)
    [string]$BaseName = Read-Host -Prompt "Config name (input 'q' for your computer name)";
    if($BaseName -eq "q"){return $env:COMPUTERNAME.ToString();}
    else {return $BaseName;}
}