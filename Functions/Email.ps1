<#
.Synopsis
	Outlook data mining
.Description
    Refs: https://docs.microsoft.com/en-us/archive/msdn-magazine/2013/march/powershell-managing-an-outlook-mailbox-with-powershell
.Notes
    
#>

Param([Switch]$Count, [Switch]$ListInbox,[Switch]$GetObject,[Switch]$GetBody,[int]$index=$null)

Add-Type -assembly "Microsoft.Office.Interop.Outlook";
$Outlook = New-Object -comobject Outlook.Application;
$namespace = $Outlook.GetNameSpace("MAPI");
$inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)

if($ListInbox){return ($inbox.Items | Select-Object -Property  Subject, ReceivedTime, Sendername)}
if($Count){return ($inbox.Items|Measure-Object).Count;}
if($GetObject){return $inbox}
if($GetObject)
{
    if($null -eq $index){write-host "null";}
}