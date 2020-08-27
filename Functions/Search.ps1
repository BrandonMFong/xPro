<#
.Synopsis
    Concat user prompt with search links
.Description
    Uses Web class
.Parameter Google
    User inputs string to search with google
.Example

.Notes
    Wondering if there should be a class for Web or just put all strings in this function
#>
param(
    [switch]$Google,
    [switch]$Sharepoint,
    [switch]$Dictionary,
    [switch]$Youtube,
    [Switch]$NewWindow,
    [Switch]$Facebook,
    [Switch]$Maps # Google Maps
)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;

if($Google)
{
    $Value = read-host -prompt "Google";
    $Search = "https://google.com/search?q= $($Value)";
}
elseif($Dictionary)
{
    $Value = read-host -prompt "Dictionary";
    $Search = "https://www.dictionary.com/browse/" + $Value;
}
elseif($Youtube)
{
    $Value = read-host -prompt "Youtube";
    $Search = "https://youtube.com/results?search_query= $Value";
}
elseif($Facebook)
{
    $Value = read-host -prompt "Facebook";
    $Search = "https://www.facebook.com/search/top/?q=$Value&epa=SEARCH_BOX";
}
elseif($Maps)
{
    [String]$Value = Read-Host -Prompt "Google Maps";
    [String]$Search = "https://www.google.com/maps/search/" + $Value;
}
else{$Global:LogHandler.Write("Nothing searched");}

Start-Process $Search; # Execute the command
