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

    [double]Log2($x)
    {
        return [Math]::Log($x)/[Math]::Log(2);
    }

    [void]WaterBillSplit([Double]$TotalPayment, [int]$TotalHousemates=10)
    {
        #[int]$TotalHousemates = 10;
        [Double]$EveryonePays = $TotalPayment/$TotalHousemates;
        [Double]$TotalPaymentExcludingUser = $TotalPayment - $EveryonePays;

        Write-Host "Total Payment for WaterBill: $($TotalPayment)";
        Write-Host "Everyone pays: $($EveryonePays)";
        Write-Host "Your venmo total charge (excluding you) will look like: $($TotalPaymentExcludingUser)";
    }
}