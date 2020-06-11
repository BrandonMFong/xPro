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
param([switch]$Google,[switch]$Sharepoint,[switch]$Dictionary,[switch]$Youtube)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;

if($Google)
{
    $Value = read-host -prompt "Google";
    $Search = "https://google.com/search?q= $($Value)";
    Start-Process $Search;
}
elseif($Dictionary)
{
    $Value = read-host -prompt "Dictionary";
    $Search = "https://www.dictionary.com/browse/" + $Value;
    Start-Process $Search;
}
elseif($Youtube)
{
    $Value = read-host -prompt "Youtube";
    $YT_Search = "https://youtube.com/results?search_query= $Value";
    Start-Process $YT_Search;
}
else{throw "Nothing searched";}
