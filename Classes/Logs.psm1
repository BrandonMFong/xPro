# On by default
class Logs
{
    [string]$LogFile;
    [int16]$DayThreshold = -2; # Two days
    Logs($LogFile)
    {

        $this.LogFile = $LogFile;
        if(!$(Test-Path $this.LogFile))
        {
            New-Item $this.LogFile -Force | Out-Null;
            $this.ClearOldLogs($($this.LogFile | Split-Path -Parent));
        }
    }

    # Clears the old log files
    hidden ClearOldLogs([string]$Directory)
    {
        [System.Array]$o = Get-ChildItem $Directory; # Get all the files in the log directory
        
        for([int16]$i = 0;$i -lt $o.Length;$i++)
        {
            # If the file more than 2 days old, delete
            if($o[$i].LastWriteTime -lt $(Get-Date).AddDays($this.DayThreshold))
            {
                Remove-Item $o[$i].FullName -Force;
                $this.Write("Removing $($o[$i].FullName)");
            }
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
    [Void] Warning([String]$logstring){$this.Write(" [WARNING] " + $logstring);}

    # Going to put it in the same logs
    # TODO change WriteError to Error
    [Void] WriteError($logstring)
    {
        Write-Warning "Error. Check logs";

        [String]$contentstring = $null;
        [String]$datestring = Get-Date -Format "yyyy-MM-dd HH:mm:ss"; # Get the date
        $callstack = Get-PSCallStack;
        [String]$SourceFile = $null;
        if(![string]::IsNullOrEmpty($callstack[1].ScriptName)){$SourceFile = $callstack[1].Location | Split-Path -Leaf;} # Get the script that called this method

        # Writing the content into the log
        $contentstring = "[$($datestring) - $($SourceFile)] - ERROR";
        $contentstring += "`n   Error in $($SourceFile)";
        $contentstring += "`n   $($logstring)";
        for([int16]$i=0;$i -lt $callstack.Count;$i++){$contentstring += "`n   $($callstack[$i])";}

        Add-Content $this.LogFile $contentstring;
    }
}