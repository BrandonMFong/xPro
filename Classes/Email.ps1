
$_Outlook = New-Object -comobject Outlook.Application;
class Email
{
    [__ComObject]$_namespace = $_Outlook.GetNameSpace("MAPI");

    [string]$Folder;
    hidden [string]$BaseFolderPath;
    hidden [string]$FullFolderPath;
    hidden [XML]$Xml; 
    hidden [__ComObject]$FolderObject;
    
    Email([string]$FolderName,[string]$BaseFolderPath)
    {
        # $this.Xml = Get-Content (Get-Variable "ConfigFile").Value;
        $this.Folder = $FolderName;
        $this.BaseFolderPath = $BaseFolderPath;
        $this.FullFolderPath = $BaseFolderPath + "\" + $FolderName;
        $this.FindFolder($this.GetEmailObject($this._namespace));
    }

    hidden FindFolder([__ComObject]$Object)
    {
        foreach($Folder in $Object.Folders)
        {
            if($Folder.FolderPath -eq $this.FullFolderPath){$this.FolderObject = $Folder; return;}
        }
        $this.FindFolder($Folder);
    }

    hidden [__ComObject]GetEmailObject([__ComObject]$np)
    {
        foreach($obj in $np.Folders)
        {
            if($obj -eq $this.BaseFolderPath){return $obj;}
        }
        throw "Didn't find object!";
    }
}

[Email]$Test = [Email]::new("Inbox", "\\fong.m.brandon97@gmail.com")