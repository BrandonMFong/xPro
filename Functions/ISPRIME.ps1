
Param([int]$num)
    	$composite_flag = $False;
    	for($i = 2; $i -lt $num; $i++)
    	{
    		if(($num % $i) -eq 0){$composite_flag = $True}
    	}
        
    	if($composite_flag){Write-Host "$i is composite"}
    	else {Write-Host "$i is prime"}