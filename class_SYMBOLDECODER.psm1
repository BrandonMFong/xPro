
class ArithmeticCoder
{
    $Symbols = [System.Collections.ArrayList]::new();
    $interval = 
    @{
        $ExclusiveMax = 0;
        $InclusiveMin = 0;
    }

    [void]DefineSymbols()
    {
        Write-Warning "The order you input symbols is the sequence of the message`n";
        $val1 = 0; $val2 = 0;
        while($true)
        {
            Write-Host "Defining symbols.`n";
            $val1 = Read-Host -Prompt "Symbol";
            $val2 = Read-Host -Prompt "Its entropy";
            $this.Symbols.Add($val1, $val2);
            $prompt = Read-Host -Prompt "Continue defining symbols? (Y/N)";
            if($prompt -eq "N")
            {
                Write-Host "There are $($this.Symbols.count) symbols: $($this.Symbols)";
                return;
            }
            else
            {
                $this.Symbols.Add([Symbol]::new($val1, $val2));
            }
        }
    }

    [void]GetInterval()
    {
        if ($this.Symbols.count -eq 0)
        {
            Write-Warning "`$Symbols not defined, calling DefineSymbols() method";
            $this.DefineSymbols();
        }

        # TODO for loops to do method
    }
    
}

class Symbol
{
    [string]$Symbol;
    [string]$Entropy;

    Symbol([String]$Symbol, [string]$Entropy)
    {
        $this.Symbol = $Symbol;
        $this.Entropy = $Entropy;
    }
}