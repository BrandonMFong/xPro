<#
.Synopsis
    Sorts datetime variables
.Notes
    Made for the update scripts
#>
Param
(
    [String[]]$Object, # Assuming that the array arriving is the base name of the files
    [ValidateSet('SelectionSort')][string]$Method,
    [String]$ParseString="MMddyyyy"
)

if($Method.Equals('SelectionSort'))
{
    [String[]]$Output = @();
    # [String[]]$FinalObject = @();
    [String[]]$Latter = @();
    for($i=0;$i -lt $Object.Length;$i++) # Over all window to sort, should be shrinking the inner loop
    {
        [int]$index = 0;
        if([string]::IsNullOrEmpty($Latter)){[String[]]$IntervalObject = $Object;}
        else{[String[]]$IntervalObject = $Latter;}

        # Looking through the object $IntervalObject to find the smallest amount
        for($j=0;$j -lt $IntervalObject.Length;$j++) # Scan interval, bounded by $i
        {
            if(![string]::IsNullOrEmpty($IntervalObject[$j+1])) # If I am not at the end of the object array
            {
                # If second is less than first, put it first
                if([DateTime]::ParseExact($IntervalObject[$j+1],$ParseString,$null) -lt [DateTime]::ParseExact($IntervalObject[$j],$ParseString,$null))
                {
                    $index = $j+1;
                }
            }
        }

        # Rearrange
        [String[]]$Former = $IntervalObject[$index];
        [String[]]$Latter = @();
        for($k=$i;$k -lt $IntervalObject.Length;$k++)
        {
            if($IntervalObject[$k] -ne $Former)
            {
                $Latter += $IntervalObject[$k];
            }
        }
        # $FinalObject = $Former + $Latter; # Combine all together
        $Output += $Former; # Combine all together
    }
    return $Output;
}