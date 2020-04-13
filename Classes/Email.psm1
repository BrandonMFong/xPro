

class Email # Looks in the inbox
{
    [Message[]]$Messages = 0;
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
        for($i=0;$i -lt $this.Messages.Length;$i++)
        {
            Write-Host "Subject: " -ForegroundColor Cyan -NoNewline;Write-Host "$($this.Messages[$i].Subject)";
            Write-Host "From: " -ForegroundColor Cyan -NoNewline;Write-Host "$($this.Messages[$i].From)";
            Write-Host "Date: " -ForegroundColor Cyan -NoNewline;Write-Host "$($this.Messages[$i].Date)";
            Write-Host "Body: " -ForegroundColor Cyan;
            Write-Host "$($this.Messages[$i].Body)";
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