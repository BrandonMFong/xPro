
    Param([string]$URL,[string]$DecodeUrl=' ', [switch]$NewWindow)
    Set-Alias c 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe';
    try
    {
        if($DecodeUrl -ne ' ')
        {
            if($NewWindow){c $Decode.InputReturn($DecodeUrl) --new-window}
            else{c $Decode.InputReturn($DecodeUrl)};
        }
        else
        {
            if($NewWindow){c $URL --new-window}
            else{c $URL};
        }
    }
    catch 
    {
        Write-Warning $_;
    }