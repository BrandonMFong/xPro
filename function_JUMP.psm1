
function jump #jumps back directories
{
    Param($j)

    for($i = 0; $i -lt $j; $i++)
    {
        cd ..
    }
}

function hop
{
    Param($j)
    if ($j -gt 0)
    {
        $j = $j - 1;
        cd ..;
        hop $j;
    }
}