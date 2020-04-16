

class Email # Looks in the inbox
{
    hidden $inbox; # TODO find object type
    [Messages[]]$Messages = [messages]::new();

    Email()
    {
        Import-Module ($PSScriptRoot + "\..\Modules\FunctionModules.psm1");
        $this.inbox = InboxObject;
    }

    [void] ListInbox()
    {
        for($i=0;$i -lt $this.Messages.Length;$i++)
        {
            Write-Host "Subject: " -ForegroundColor Cyan -NoNewline;Write-Host "$($this.Messages[$i].Subject)";
            Write-Host "From: " -ForegroundColor Cyan -NoNewline;Write-Host "$($this.Messages[$i].From)";
            Write-Host "Date: " -ForegroundColor Cyan -NoNewline;Write-Host "$($this.Messages[$i].Date)";
            Write-Host "Body: " -ForegroundColor Cyan;
            Write-Host "$($this.Messages[$i].Body)";
        }
    }

    hidden [void] LoadInbox()
    {
        foreach($i in $this.inbox.Items)
        {
            $this.Messages += [Messages]::new($i.Body);
        } 
    }
}

class Messages
{
    [string]$Body;
    [string]$From;

    Messages(){}

    Messages([string]$Body,[string]$From)
    {
        $this.Body = $Body;
    }
}