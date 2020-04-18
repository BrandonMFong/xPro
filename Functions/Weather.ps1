<#
.Synopsis
	Get's weather data from http://wttr.in/
.Description
    Credits to https://github.com/chubin/wttr.in & 
    https://gist.github.com/PrateekKumarSingh/cf641670f89be6c8e0c3c4af73caf914#file-get-weather-ps1
.Parameter Area
    A city, default the city is determined 
.Example
    Weather.ps1 -Area "San Diego" -Today
.Notes
    This takes a while, this may start the idea of threading
#>

param
(
    [string]$Area=$(Get-Variable "XMLReader").Value.Machine.Weather.Area,
    [switch]$RightNow,
    [switch]$Today,
    [switch]$Tomorrow,
    [switch]$DayAfterTomorrow,
    [switch]$All
)
$weather = (Invoke-WebRequest "http://wttr.in/$Area").ParsedHtml.body.outerText -split "`n";
Write-Host "`n$($weather[0])" -ForegroundColor Green;

try 
{
    if($RightNow){$weather[2..6];}
    elseif($Today){$weather[7..16];}
    elseif($Tomorrow){$weather[17..26];}
    elseif($DayAfterTomorrow){$weather[27..36];}
    else{$weather[2..36]}
    Write-Host `n;
}
catch 
{
    Write-Warning "Error in Weather, following is the exception";
    Write-Warning $_;
}