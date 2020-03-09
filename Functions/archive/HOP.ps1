
Param($j)
if ($j -gt 0)
{
    $j = $j - 1;
    cd ..;
    hop $j;
}
