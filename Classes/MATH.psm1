class Calculations
{
    [int]$QuantizedStepSize;
    [string]$PathToGradeImport = $null;
    [System.Object[]]$GradeColors = $null;
    hidden [string]$ImportDir = $($PSScriptRoot + "\..\Resources\MathImports");  

    Calculations() 
    {
        $this.QuantizedStepSize = 1; # basically not event quantizing
        $this.MakeNecessaryDirectories();
    }

    Calculations([int]$QuantizedStepSize=$null,[string]$PathToGradeImport,[System.Object[]]$GradeColors)
    {
        if($null -ne $QuantizedStepSize){$this.QuantizedStepSize = $QuantizedStepSize;}
        else{$this.QuantizedStepSize = 5;}
        $this.PathToGradeImport = $PathToGradeImport;
        $this.GradeColors = $GradeColors;
        $this.MakeNecessaryDirectories();
    }

    hidden [void]MakeNecessaryDirectories(){if(!(Test-Path $this.ImportDir)){mkdir $this.ImportDir;}}


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
    
    [void]GetGrade()
    {
        if([string]::IsNullOrEmpty($this.PathToGradeImport)){Write-Warning "File not configured!";break;} # Checks to see if file is configured

        Write-Host "`n";
        [System.Object[]]$CSVReader = Import-Csv $this.PathToGradeImport;
        [double]$TotalGrade = 0;
        for([int]$i=0;$i -lt $CSVReader.Length;$i++)
        {
            [double]$Grade = ($CSVReader[$i].ActualGrade/$CSVReader[$i].TotalGrade);

            # Default weight is 1
            if($CSVReader[$i].Weight -eq 0){[double]$WeightedGrade = $Grade*1;}
            else{[double]$WeightedGrade = $Grade*$CSVReader[$i].Weight;}

            $TotalGrade += $WeightedGrade; # Total Grade

            Write-Host "$($CSVReader[$i].GradeName) :" -NoNewline;
            Write-Host " $($($WeightedGrade*100).ToString("##.##"))%" -ForegroundColor $this.GetGradeColor($Grade*100);# Determines color from unweight grade
        }
        Write-Host "Total Grade : $($($TotalGrade*100).ToString("##.##"))%" -ForegroundColor $this.GetGradeColor($TotalGrade*100);
        Write-Host "`n";
    }

    # Gets color from configuration
    # Default is White
    hidden [string]GetGradeColor([double]$Grade)
    {
        [string]$Color = "White";

        # Starts from the highest grade and decides the color for the grade
        foreach($GradeColor in $this.GradeColors.GradeColor)
        {
            if($Grade -ge $GradeColor.MinimumThreshold.ToDouble($null)){$Color = $GradeColor.InnerXml;break;}
        }
        return $Color;
    }

    # Lists colors from configured
    [void]ListGradeColors()
    {
        [double]$MaxValue = 100;
        [double]$MinValue = 0;
        foreach($GradeColor in $this.GradeColors.GradeColor)
        {
            $MinValue = $GradeColor.MinimumThreshold.ToDouble($null);
            Write-Host "$($MaxValue)%-$($MinValue)% : " -NoNewline;
            Write-Host "$($GradeColor.InnerXml)" -ForegroundColor $GradeColor.InnerXml;
            $MaxValue = $MinValue;
        }
    }
}

# $test = [Calculations]::new($asdf)
# $test.IntToBinary(7);
# $test.IntToBinary(8);