using module .\..\..\..\Classes\CALENDAR.psm1 
<#
.Synopsis
   Testing cache for calendar function 
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

Write-Host " - Has Calendar Object loaded correctly";
[Calendar]$o = (Get-Variable "Calendar").Value;

# Double checking if the object was created 
Write-Host "   - Does variable exist" -NoNewline;
if($null -eq $o)
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# Testing values 
Write-Host "   - Are the values okay";

Write-Host "      - Month" -NoNewline;
if($o.Today.Month -ne $(Get-Date).Month)
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host "      - Day" -NoNewline;
if($o.Today.Number -ne $(Get-Date).Day)
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host "      - Year" -NoNewline;
if($o.Today.Year -ne $(Get-Date).Year)
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# TESTING PRINT
Write-Host " - Print Calendar`n";
try 
{
   $o.GetMonth();
   Write-Host "`n   - Print result" -NoNewline;
   Write-Host " [PASSED]" -ForegroundColor Green;
}
catch # FAILURE
{
   
   Write-Host "`n   - Print result" -NoNewline;
   Write-Host " [FAILED]" -ForegroundColor Green;
   $Global:LogHandler.WriteError($_);
   $RETURNVALUE = 1;
}

# Is the cache file created
Write-Host " - Is Calendar cached" -NoNewline;

[string]$FileName = $o.Today.DateString + "_0.IsToday_True";
if(!(Test-Path $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.CalendarCache + "\" + $FileName + ".txt")))
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

<# TEST END #>
return $RETURNVALUE;