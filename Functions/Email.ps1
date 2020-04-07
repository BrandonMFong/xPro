<#
.Synopsis
	Outlook data mining
.Description
    Refs: https://docs.microsoft.com/en-us/archive/msdn-magazine/2013/march/powershell-managing-an-outlook-mailbox-with-powershell
.Notes
    
#>

Param([Switch]$Count, [Switch]$ListInbox)

Add-Type -assembly "Microsoft.Office.Interop.Outlook";
$Outlook = New-Object -comobject Outlook.Application;
$namespace = $Outlook.GetNameSpace("MAPI");
$inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)

if($ListInbox){return ($inbox.Items | Select-Object -Property To, Sendername, Subject, ReceivedTime)}
if($Count){return ($inbox.Items|Measure-Object).Count;}