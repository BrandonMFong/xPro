class Calculations
{
    [int]$QuantizedStepSize=0;
    hidden [string]$PathToGradeImport = $null;
    hidden [System.Object[]]$GradeColors = $null;
    hidden [string]$ImportDir = $($PSScriptRoot + "\..\Resources\MathImports");  

    Calculations() 
    {$this.MakeNecessaryDirectories();}

    Calculations([int]$QuantizedStepSize=$null,[string]$PathToGradeImport,[System.Object[]]$GradeColors)
    {
        if($null -ne $QuantizedStepSize){$this.QuantizedStepSize = $QuantizedStepSize;}
        if([string]::IsNullOrEmpty($PathToGradeImport)){$this.PathToGradeImport = $PathToGradeImport;}
        if([string]::IsNullOrEmpty($GradeColors)){$this.GradeColors = $GradeColors;}
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

    [Double]Log2([Int16]$x)
    {
        if($x -eq 0){return 0;}
        else{return [Math]::Log($x)/[Math]::Log(2);}
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

    [string]IntToBinary([int]$int){return $([Binary]::new($int)).Value;}
    [int]BinaryToInt([string]$string){return [Binary]::IntValue($string);}

    # binary add
    [String]badd([String]$ainput,[String]$binput){return $([Binary]::new($ainput)).Add([Binary]::new($binput)).Value;}
    [String]badd([int]$ainput,[int]$binput){return $([Binary]::new($ainput)).Add([Binary]::new($binput)).Value;}

    # binary or
    [String]Or([String]$ainput,[String]$binput){return $([Binary]::new($ainput)).Or([Binary]::new($binput)).Value;}
    [String]Or([int]$ainput,[int]$binput){return $([Binary]::new($ainput)).Or([Binary]::new($binput)).Value;}

    # binary Xor
    [String]Xor([String]$ainput,[String]$binput){return $([Binary]::new($ainput)).Xor([Binary]::new($binput)).Value;}
    [String]Xor([int]$ainput,[int]$binput){return $([Binary]::new($ainput)).Xor([Binary]::new($binput)).Value;}

    # binary And
    [String]And([String]$ainput,[String]$binput){return $([Binary]::new($ainput)).And([Binary]::new($binput)).Value;}
    [String]And([int]$ainput,[int]$binput){return $([Binary]::new($ainput)).And([Binary]::new($binput)).Value;}
}

class Binary : Calculations
{
    [String]$Value;
    [int]$Length;

    Binary()
    {}

    Binary([String]$in)
    {
        # $in must be in binary
        if(!$in.Contains('1') -and !$in.Contains('0')){throw "Not a binary value!"}
        else
        {
            $this.Value = $in;
            $this.Length = $in.Length;
        }
    }

    # What happens when $in=1
    # log2(1) = 0 
    Binary([int]$in)
    {
        if($in.GetType().Name.Contains('Int')) # If the type contains the 'int' string then it is an int
        {
            $this.Value = $this.IntToB($in);
            $this.Length = $this.Value.Length;
        }
        else{throw "Not an integer!"}
    }

    hidden [String]IntToB([int16]$int)
    {
        [string]$Binary = $null;
        [Byte]$rem = 0;

        # This is instead a while loop that does the binary conversion
        # Figure out what you are doing wrong with the 255 conversion
        # the online compiler for the c++ works for 255 value
        while($int -gt 0)
        {
            $rem = $int % 2;
            $Binary = ($rem).ToString() + $Binary;
            [double]$d = ([double]$int / 2);
            # this always rounding down.  I need it to round up now from 0.5
            # $int = $($d - 0.5); # Getting the floor, might want to make a whole function on this 
            if($rem -eq 0){$int = $d;}
            else{$int = $d - 0.5;}   
        }

        # Zero pad
        $Binary = $this.ZeroPad($Binary);

        return $Binary;
    }

    hidden [String]ZeroPad([String]$Binary)
    {
        while($true)
        {
            if(($Binary.Length % 4) -eq 0){break;}
            else{$Binary = "0" + $Binary;}
        }
        return $Binary;
    }

    
    [int]ToInt([String]$string)
    {
        return $this.IntValue($string);
    }

    static [int]IntValue([String]$string)
    {
        [int]$res = 0;
        for($i=$string.Length;$i -gt 0;$i--)
        {
            [int]$x = [math]::Pow(2,$i-1);
            [int]$y = ([int]$string.Substring($string.Length-$i,1));
            $res += ($x * $y);
        }
        return $res;
    }

    [Binary]Add([Binary]$in){return $this.Ops([BinOp]::FullAdder,$in);} # ADD
    [Binary]Or([Binary]$in){return $this.Ops([BinOp]::Or,$in);} # OR
    [Binary]Xor([Binary]$in){return $this.Ops([BinOp]::Xor,$in);} # XOR
    [Binary]And([Binary]$in){return $this.Ops([BinOp]::And,$in);} # AND

    # I do not need to check if the $in value has anything but 1
    # It is already checked in the constructor
    hidden [Binary]Ops([int]$Op,[Binary]$in)
    {
        # Make into equal length
        if($this.Value.Length -ne $in.Value.Length){$this.MakeSameLength([ref]$this,[ref]$in);}

        [Binary]$Result = [Binary]::new();
        if($Op -eq [BinOp]::FullAdder){[Byte]$Carry = 0x00;} # If Add, it's going to one
        for([int]$i = $in.Value.Length;$i -gt 0;$i--)
        {
            # Has to be string since it works well with the binary operators
            [String]$a = $in.Value[$i-1];
            [String]$b = $this.Value[$i-1];

            # The xor is only good at determining the add result
            # cannot resolve for the carry because 0 ^ 0 ^ 1 = 1 but does not produce a carry
            # Resolution is implementing Full adder circuit
            # Logical gates count: 5
            #   - 2 Xor, 1 Or, 2 And
            if($Op -eq [BinOp]::FullAdder)
            {
                [Byte]$XorSum = $a -bxor $b;
                $Result.Value = $($XorSum -bxor $Carry).ToString() + $Result.Value; # Get sum
                $Carry = ($a -band $b) -bor ($XorSum -band $Carry); # Get carry flag
            }
            elseif($Op -eq [BinOp]::Or)
            {
                $Result.Value = $($a -bor $b).ToString() + $Result.Value;
            }
            elseif($Op -eq [BinOp]::Xor)
            {
                $Result.Value = $($a -bxor $b).ToString() + $Result.Value;
            }
            elseif($Op -eq [BinOp]::And)
            {
                $Result.Value = $($a -band $b).ToString() + $Result.Value;
            }
        }
        $Result.Value = $this.ZeroPad($Result.Value);
        return $Result;
    }

    hidden [Void]MakeSameLength([ref]$a,[ref]$b)
    {
        if($a.value.Value.Length -gt $b.value.Value.Length){$b.value.Value = $this.ZeroPad("0" + $b.value.Value);}
        elseif($a.value.Value.Length -lt $b.value.Value.Length){$a.value.Value = $this.ZeroPad("0" + $a.value.Value);}
        else{return;}
        
        # Will pass all the tests if they are not equal.  If the tests fail then it will return from the method
        $this.MakeSameLength($a,$b);
    }
}

class BinOp
{
    static [Int]$FullAdder = 1;
    static [int]$Or = 2;
    static [int]$Xor = 3;
    static [int]$And = 4;
    # TODO add more if needed
}