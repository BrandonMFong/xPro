class Calculations
{
    [int]$QuantizedStepSize;
    Calculations() 
    {
        $this.QuantizedStepSize = 1; # basically not event quantizing
    }
    Calculations([int]$QuantizedStepSize=$null)
    {
        if($null -ne $QuantizedStepSize){$this.QuantizedStepSize = $QuantizedStepSize;}
        else{$this.QuantizedStepSize = 5;}
    }
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
        $temp = $x;$x = $y;$y = $temp;
    }

    [void]SwapTwoVariablesWithoutTempVarAS([ref]$x, [ref]$y)
    {
        $x.value = $x.value + $y.value; $y.value = $x.value - $y.value; $x.value = $x.value - $y.value;
    }

    [void]SwapTwoVariablesWithoutTempVarMD([ref]$x, [ref]$y)
    {
        $x.value = $x.value * $y.value; $y.value = $x.value / $y.value; $x.value = $x.value / $y.value;
    }

    [void]SwapTwoVariablesUsingStack([ref]$x, [ref]$y)
    {
        $stack = [System.Collections.Stack]::new();
        $stack.Push($x.value);$stack.Push($y.value);
        $x.value = $stack.Pop();$y.value = $stack.Pop();
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

    [void]IsPrime([int]$num)
    {
        $composite_flag = $False;
        for($i = 2; $i -lt $num; $i++)
        {
            if(($num % $i) -eq 0){$composite_flag = $True}
        }

        if($composite_flag){Write-Host "$i is composite"}
        else {Write-Host "$i is prime"}
    }
    
    # Self Entropy
    [double]I([double]$x)
    {
        return -$this.Log2($x);
    }

    # Message Entropy
    [double]H($Codewords)
    {
        [double]$ans = 0;
        for($i = 0;$i -lt $Codewords.Count;$i++)
        {
            $ans = $ans + ( $Codewords[$i] * $this.Log2($Codewords[$i]));
        }
        return -$ans;
    }

    [BYTE]AsciiToDec([string]$string)
    {
        return [BYTE][CHAR]$string;
    }

    [CHAR]DecToAscii([int]$Hex)
    {
        return [CHAR][BYTE]$Hex;
    }

    [int]Quantize([int]$Value)
    {
        return [int]($Value/$this.QuantizedStepSize)*$this.QuantizedStepSize;
    }

    [string]IntToBinary([int]$int)
    {
        [string]$Binary = $null;

        # Convert
        for([int]$MaxBits = [int]($this.Log2($int) + 0.5); $MaxBits -gt 0;$MaxBits--)
        {
            $x = [math]::Pow(2,$MaxBits - 1);
            if($x -le $int) {$Binary += "1";$int = $int - $x;}
            else {$Binary += "0";}
        }

        # Zero pad
        while($true)
        {
            if(($Binary.Length % 4) -eq 0){break;}
            else{$Binary = "0" + $Binary;}
        }

        return $Binary;
    }

    # Basically a method to split up the binary conversion
    [void]InsertSpace($InsertForEvery=$null, [ref]$ref)
    {
        if($null -eq $InsertForEvery){$InsertForEvery = 4}
        for([int]$i = $ref.Value.Length;$i -gt 0;$i = $i - $InsertForEvery)
        {

        }
    }
}

# $test = [Calculations]::new($asdf)
# $test.IntToBinary(7);
# $test.IntToBinary(8);