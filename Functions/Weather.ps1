<#
.Synopsis
	
.Description
	
.Parameter 

.Example
	
.Notes

#>

param
(
    [string]$Area,
    [switch]$RightNow,
    [switch]$Today,
    [switch]$Tomorrow,
    [switch]$DayAfterTomorrow,
    [switch]$All
)
$weather = (Invoke-WebRequest "http://wttr.in/$Area").ParsedHtml.body.outerText -split "`n";
Write-Host "`n$($weather[0])`n" -ForegroundColor Green;

if($RightNow){$weather[2..6];}
elseif($Today){$weather[7..16];}
elseif($Tomorrow){$weather[17..26];}
elseif($DayAfterTomorrow){$weather[27..36];}
else{$weather}
Write-Host `n;