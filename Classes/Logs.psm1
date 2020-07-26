# On by default
class Logs
{
    [string]$LogFile;
    Logs($LogFile)
    {
        $this.LogFile = $LogFile;
        if(!$(Test-Path $this.LogFile))
        {
            New-Item $this.LogFile -Force | Out-Null;
        }
    }

    # Only need to pass the content you are logging
    # Don't need to pass the date
    [Void] Write([String]$logstring)
    {
        [String]$contentstring = $null;
        [String]$datestring = Get-Date -Format "yyyy-MM-dd HH:mm:ss"; # Get the date
        $callstack = Get-PSCallStack;
        [String]$SourceFile = $null;
        if(![string]::IsNullOrEmpty($callstack[1].ScriptName)){$SourceFile = $callstack[1].Location | Split-Path -Leaf;} # Get the script that called this method
        $contentstring = "[$($datestring) - $($SourceFile)] $($logstring)";

        Add-Content $this.LogFile $contentstring;
    }
}