
Add-Type -assembly "Microsoft.Office.Interop.Outlook";
function InboxObject
{
    $Outlook = New-Object -comobject Outlook.Application;
    $namespace = $Outlook.GetNameSpace("MAPI");
    $inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
    return $inbox;
}