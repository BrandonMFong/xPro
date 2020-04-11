class Email
{
    [System.MarshalByRefObject]$inbox;
    # Put items in a hashtable

    Email()
    {
        Add-Type -assembly "Microsoft.Office.Interop.Outlook";
        $Outlook = New-Object -comobject Outlook.Application;
        $namespace = $Outlook.GetNameSpace("MAPI");
        $this.inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
    }

    
}