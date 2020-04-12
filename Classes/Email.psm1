

class Email # Looks in the inbox
{
    [Message[]]$Messages;
    Email()
    {
        Import-Module ($PSScriptRoot + "\..\Modules\FunctionModules.psm1");
        $inbox = InboxObject;
        for($i=1;$i -le $inbox.Items.count;$i++)
        {
            if($i){$this.Messages = [Message]::new($inbox.Items($i));}
            else{$this.Messages += [Message]::new($inbox.Items($i));}
        }                         
    }

    [void] ListInbox()
    {
        foreach($m in $this.Messages)
        {
            Write-Host "Subject: " -ForegroundColor Cyan -NoNewline;Write-Host "$($m.Subject)";
            Write-Host "From: " -ForegroundColor Cyan -NoNewline;Write-Host "$($m.From)";
            Write-Host "Date: " -ForegroundColor Cyan -NoNewline;Write-Host "$($m.Date)";
            Write-Host "Body: " -ForegroundColor Cyan;
            Write-Host "$($m.Body)";
        }
    }
}

class Message 
{
    [string]$Date;
    [string]$From;
    [string]$Subject;
    [string]$Body;
    Message($mail)
    {
        $this.Subject = $mail.TaskSubject;
        $this.Date = $mail.ReceivedTime;
        $this.From = $mail.SenderName;
        $this.Body = $mail.Body;
    }
}