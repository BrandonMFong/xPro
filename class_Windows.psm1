class Windows
{
    [int]$Main = 1;
    [int]$Bluetooth = 2;
    [int]$Display = 3;
    [int]$test = 4;
    
    Settings([int]$value)
    {
        switch ($value)
        {
            1 { Start-Process ms-settings;}
            2 { Start-Process ms-settings:BlueTooth;}
            default {throw "Nothing was passed.";}
        }
    }
}

