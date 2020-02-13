class Windows
{
    [int]$Main = 1;
    [int]$Bluetooth = 2;
    [int]$Display = 3;
    
    [void]OpenSettings(){start ms-settings:;}
    [void]OpenBlueToothSettings(){start ms-settings:bluetooth;}
    [void]OpenDisplaySettings(){start ms-settings:display;}
}

