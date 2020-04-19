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
$var = $(GetObjectByClass('Web'));

if($Google)
{
    $v = read-host -prompt "Google"
    $var.Google($v);
}
elseif($Sharepoint)
{
    $v = read-host -prompt "Sharepoint"
    $var.Sharepoint($v);
}
elseif($Dictionary)
{
    $v = read-host -prompt "Dictionary"
    $var.Dictionary($v);
}
elseif($Youtube)
{
    $v = read-host -prompt "Youtube"
    $var.Youtube($v);
}
else{throw "Nothing searched";}
