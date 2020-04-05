# Contains any functions that are really short in code


function Hop 
{
    Param($j)
    if ($j -gt 0)
    {
        $j = $j - 1;
        Set-Location ..;
        hop $j;
    }
}

function Jump 
{
    
    Param($j)

    for($i = 0; $i -lt $j; $i++)
    {
        Set-Location ..;
    }
}

function Slide
{
    Param([int]$j)
    while($j -gt 0){Set-Locatioin ..;$j = $j - 1}
}

function CL 
{
    Clear-Host;Get-ChildItem;
}

function Restart-Session
{
    Start-Process powershell;exit;
}

function List-Color
{
    [Enum]::GetValues([System.ConsoleColor])
}
function Open-Settings{start ms-settings:;}
function Open-Bluetooth{start ms-settings:bluetooth;}
function Open-Display{start ms-settings:display;}