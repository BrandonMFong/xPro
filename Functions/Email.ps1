<#
.Synopsis
	Lists emails from Outlook app
.Description
    Refs: https://docs.microsoft.com/en-us/archive/msdn-magazine/2013/march/powershell-managing-an-outlook-mailbox-with-powershell
.Notes
    Must have outlook app for this to work
#>

Param([Switch]$Count, [Switch]$ListMessages, [Switch]$ListInbox,[Switch]$GetObject,[Switch]$GetBody,[int]$index=0)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;

$Outlook = New-Object -comobject Outlook.Application;
$namespace = $Outlook.GetNameSpace("MAPI");
$inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)

if($ListMessages)
{
    if(($inbox.Items|Measure-Object).Count -gt 0)
    {
        Write-Host "------------------------------------------------------------------------------------------";
        for($i=0;$i -lt $inbox.Items.Count;$i++)
        {
            Write-Host `n;
            Write-Host "From: " -ForegroundColor Cyan -NoNewline;
            Write-Host "$(($inbox.Items|Select-Object -Property SenderName|Select-Object -Index $($i)).SenderName)";
            Write-Host "Subject: " -ForegroundColor Cyan -NoNewline; 
            Write-Host "$(($inbox.Items|Select-Object -Property Subject|Select-Object -Index $($i)).Subject)" ;
            Write-Host "Time: " -ForegroundColor Cyan -NoNewline; 
            $Time = ($inbox.Items|Select-Object -Property ReceivedTime|Select-Object -Index $($i)).ReceivedTime;
            Write-Host "$(Get-Date $Time -Format "MM/dd/yyyy hh:mm tt")" ;
            Write-Host "Body: " -ForegroundColor Cyan;
            Write-Host "$(($inbox.Items|Select-Object -Property Body|Select-Object -Index $($i)).Body)" ;
            Write-Host "------------------------------------------------------------------------------------------";
        }
        Write-Host `n;
    }
    else{Write-Host "No Emails!"}
}
if($index -ne 0)
{
    Write-Host `n;
    Write-Host "From: " -ForegroundColor Cyan -NoNewline;
    Write-Host "$(($inbox.Items|Select-Object -Property SenderName|Select-Object -Index $($index-1)).SenderName)";
    Write-Host "Subject: " -ForegroundColor Cyan -NoNewline; 
    Write-Host "$(($inbox.Items|Select-Object -Property Subject|Select-Object -Index $($index-1)).Subject)" ;
    Write-Host "Time: " -ForegroundColor Cyan -NoNewline; 
    $Time = ($inbox.Items|Select-Object -Property ReceivedTime|Select-Object -Index $($index-1)).ReceivedTime;
    Write-Host "$(Get-Date $Time -Format "MM/dd/yyyy hh:mm tt")" ;
    Write-Host "Body: " -ForegroundColor Cyan;
    Write-Host "$(($inbox.Items|Select-Object -Property Body|Select-Object -Index $($index-1)).Body)" ;
    Write-Host `n;
}
if($ListInbox)
{
    if(($inbox.Items|Measure-Object).Count -gt 0)
    {
        for($i=0;$i -lt $inbox.Items.Count;$i++)
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
if($Count){return ($inbox.Items|Measure-Object).Count;}
if($GetObject){return $inbox;}