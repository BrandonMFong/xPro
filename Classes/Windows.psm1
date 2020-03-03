class Windows
{
    [string]$ComputerName;
    Windows()
    {
        $this.ComputerName = $env:COMPUTERNAME;
    }
    [void]OpenSettings(){start ms-settings:;}
    [void]OpenBlueToothSettings(){start ms-settings:bluetooth;}
    [void]OpenDisplaySettings(){start ms-settings:display;}
}

