<#
.Synopsis
	Lists emails from Outlook app
.Description
    Refs: https://docs.microsoft.com/en-us/archive/msdn-magazine/2013/march/powershell-managing-an-outlook-mailbox-with-powershell
.Notes
    Must have outlook app for this to work
    Can read the configuration dynamically
#>

Param([Switch]$Count, [Switch]$ListMessages,[Switch]$GetObject,[Switch]$GetBody,[int]$index=0,[switch]$BoundedList)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
[XML]$xml = $(Get-Content ($PSScriptRoot + "\..\Config\" + (Get-Variable "AppPointer").Value.Machine.ConfigFile));
$x = $xml.Machine.Email;
$inbox = InboxObject;
if($ListMessages)
{
    if(($inbox.Items|Measure-Object).Count -gt 0)
    {
        Write-Host "------------------------------------------------------------------------------------------";
        for($i=0;$i -lt $inbox.Items.Count;$i++)
        {
            Write-Host `n;
            if($x.IncludeFields.To -eq "True")
            {
                Write-Host "To: " -ForegroundColor Cyan -NoNewline;
                Write-Host "$(($inbox.Items|Select-Object -Property To|Select-Object -Index $($i)).To)";
            }
            if($x.IncludeFields.CC -eq "True")
            {
                Write-Host "CC: " -ForegroundColor Cyan -NoNewline;
                Write-Host "$(($inbox.Items|Select-Object -Property CC|Select-Object -Index $($i)).CC)";
            }
            if($x.IncludeFields.From -eq "True")
            {
                Write-Host "From: " -ForegroundColor Cyan -NoNewline;
                Write-Host "$(($inbox.Items|Select-Object -Property SenderName|Select-Object -Index $($i)).SenderName)";
            }
            if($x.IncludeFields.Subject -eq "True")
            {
                Write-Host "Subject: " -ForegroundColor Cyan -NoNewline; 
                Write-Host "$(($inbox.Items|Select-Object -Property Subject|Select-Object -Index $($i)).Subject)" ;
            }
            if($x.IncludeFields.Time -eq "True")
            {
                Write-Host "Time: " -ForegroundColor Cyan -NoNewline; 
                $Time = ($inbox.Items|Select-Object -Property ReceivedTime|Select-Object -Index $($i)).ReceivedTime;
                Write-Host "$(Get-Date $Time -Format "MM/dd/yyyy hh:mm tt")" ;
            }
            if($x.IncludeFields.Body -eq "True")
            {
                Write-Host "Body: " -ForegroundColor Cyan;
                Write-Host "$(($inbox.Items|Select-Object -Property Body|Select-Object -Index $($i)).Body)" ;
            }
            Write-Host "------------------------------------------------------------------------------------------";
        }
        Write-Host `n;
    }
    else{Write-Host "No Emails!"}
    break;
}
if($index -ne 0)
{
    Write-Host `n;
    Write-Host "----------------------------------------------Start Message--------------------------------------------";
    if($x.IncludeFields.To -eq "True")
    {
        Write-Host "To: " -ForegroundColor Cyan -NoNewline;
        Write-Host "$(($inbox.Items|Select-Object -Property To|Select-Object -Index $($index-1)).To)";
    }
    if($x.IncludeFields.CC -eq "True")
    {
        Write-Host "CC: " -ForegroundColor Cyan -NoNewline;
        Write-Host "$(($inbox.Items|Select-Object -Property CC|Select-Object -Index $($index-1)).CC)";
    }
    if($x.IncludeFields.From -eq "True")
    {
        Write-Host "From: " -ForegroundColor Cyan -NoNewline;
        Write-Host "$(($inbox.Items|Select-Object -Property SenderName|Select-Object -Index $($index-1)).SenderName)";
    }
    if($x.IncludeFields.Subject -eq "True")
    {
        Write-Host "Subject: " -ForegroundColor Cyan -NoNewline; 
        Write-Host "$(($inbox.Items|Select-Object -Property Subject|Select-Object -Index $($index-1)).Subject)" ;
    }
    if($x.IncludeFields.Time -eq "True")
    {
        Write-Host "Time: " -ForegroundColor Cyan -NoNewline; 
        $Time = ($inbox.Items|Select-Object -Property ReceivedTime|Select-Object -Index $($index-1)).ReceivedTime;
        Write-Host "$(Get-Date $Time -Format "MM/dd/yyyy hh:mm tt")" ;
    }
    if($x.IncludeFields.Body -eq "True")
    {
        Write-Host "Body: " -ForegroundColor Cyan;
        Write-Host "$(($inbox.Items|Select-Object -Property Body|Select-Object -Index $($index-1)).Body)" ;
    }
    Write-Host "----------------------------------------------End Message-----------------------------------------------";
    Write-Host `n;
    break;
}
if($Count){return ($inbox.Items|Measure-Object).Count;}
if($GetObject){return $inbox;}
if($BoundedList)
{
    if((![string]::IsNullOrEmpty($x.ListInboxMax)) -and ($(($inbox.Items|Measure-Object).Count) -gt $x.ListInboxMax)){$Max = $x.ListInboxMax;}
    else{$Max = $inbox.Items.Count;}
    if(($inbox.Items|Measure-Object).Count -gt 0)
    {
        for($i=0;$i -lt $Max;$i++)
        {
            Write-Host "{$($i+1)} " -NoNewline -ForegroundColor Cyan;
            Write-Host "[" -NoNewline -ForegroundColor Cyan;
            Write-Host "$(($inbox.Items|Select-Object -Property SenderName|Select-Object -Index $($i)).SenderName)" -ForegroundColor Green -NoNewline;
            Write-Host " - " -NoNewline; 
            $Time = ($inbox.Items|Select-Object -Property ReceivedTime|Select-Object -Index $($i)).ReceivedTime;
            Write-Host "$(Get-Date $Time -Format "MM/dd/yyyy hh:mm tt")" -ForegroundColor Green -NoNewline;
            Write-Host "] " -NoNewline -ForegroundColor Cyan;
            Write-Host "$(($inbox.Items|Select-Object -Property Subject|Select-Object -Index $($i)).Subject)" -ForegroundColor Yellow;
        }
    }
    else{Write-Host "No Emails!" -ForegroundColor Yellow}
}
else
{
    if((![string]::IsNullOrEmpty($x.ListInboxMax)) -and ($(($inbox.Items|Measure-Object).Count) -gt $x.ListInboxMax)){$Max = $x.ListInboxMax;}
    else{$Max = $inbox.Items.Count;}
    if(($inbox.Items|Measure-Object).Count -gt 0)
    {
        for($i=0;$i -lt $Max;$i++)
        {
            Write-Host "{$($i+1)} " -NoNewline -ForegroundColor Cyan;
            Write-Host "[" -NoNewline -ForegroundColor Cyan;
            Write-Host "$(($inbox.Items|Select-Object -Property SenderName|Select-Object -Index $($i)).SenderName)" -ForegroundColor Green -NoNewline;
            Write-Host " - " -NoNewline; 
            $Time = ($inbox.Items|Select-Object -Property ReceivedTime|Select-Object -Index $($i)).ReceivedTime;
            Write-Host "$(Get-Date $Time -Format "MM/dd/yyyy hh:mm tt")" -ForegroundColor Green -NoNewline;
            Write-Host "] " -NoNewline -ForegroundColor Cyan;
            Write-Host "$(($inbox.Items|Select-Object -Property Subject|Select-Object -Index $($i)).Subject)" -ForegroundColor Yellow;
        }
    }
    else{Write-Host "No Emails!" -ForegroundColor Yellow}
}