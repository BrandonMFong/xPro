class Windows
{
    [int]$Main = 1;
    [int]$Bluetooth = 2;
    [int]$Display = 3;
    
    Settings([int]$value)
    {
        switch ($value)
        {
            1 { Start ms-settings;}
            2 { Start ms-settings:BlueTooth;}
            default {Start ms-settings;}
        }
    }
}

