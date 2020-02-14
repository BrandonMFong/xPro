class Calculations
{
    # Object method
    [double]KgToPounds($x) #0.453592kg per 1 lb
    {
        return ($x / 0.453592)
    }
    [double]PoundsToKg($x) #0.453592kg per 1 lb
    {
        return (0.453592 * $x)
    }
    
    [double]CtoF($x)
    {
        return ($x*(9/5)) + 32;
    }
    
    [double]FtoC($x)
    {
        return ($x - 32)*(5/9);
    }

    [void]SwapTwoVariables($x, $y)
    {
        $temp = $x;$x = $y;$y = $x;
    }

    [void]SwapTwoVariablesWithoutTempVarAS($x, $y)
    {
        $x = $x + $y; $y = $x - $y; $x = $x - $y;
    }

    [void]SwapTwoVariablesWithoutTempVarMD($x, $y)
    {
        $x = $x * $y; $y = $x / $y; $x = $x / $y;
    }

    [void]SwapTwoVariablesUsingStack($x, $y)
    {
        $stack = [System.Collections.Stack]::new();
        $stack.Push($x);$stack.Push($y);
        $x = $stack.Pop();$y = $stack.Pop();
    }

    [double]LogBaseTwo($x)
    {
        return [Math]::Log($x)/[Math]::Log(2);
    }
}