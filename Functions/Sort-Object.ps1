<#
.Synopsis
    Sorts datetime variables
.Notes
    Made for the update scripts
#>
Param
(
    [System.Object[]]$Object, # Assuming that the array arriving is the base name of the files
    [ValidateSet('SelectionSort')][string]$Method
)

if($Method.Equals('SelectionSort'))
{
    [System.Object[]]$FinalObject;
    for($i=0;$i -lt $Object.Length;$i++) # Over all window to sort, should be shrinking the inner loop
    {
        [int]$index;
        [System.Object[]]$IntervalObject = $Object[$i..$Object.Length];

        # Looking through the object $IntervalObject
        for($j=$i;$j -lt $IntervalObject.Length;$j++) # Scan interval, bounded by $i
        {
            if(![string]::IsNullOrEmpty($IntervalObject[$j+1])) # If I am not at the end of the object array
            {
                # If second is greater than first, put it first
                if([DateTime]::ParseExact($IntervalObject[$j+1],"MMddyyyy",$null) -gt [DateTime]::ParseExact($IntervalObject[$j],"MMddyyyy",$null))
                {
                    $index = $j+1;
                }
            }
        }

        # Rearrange
        [System.Object[]]$Former = $IntervalObject[$index];
        [System.Object[]]$Latter;
        for($k=$i;$k -lt $IntervalObject.Length;$k++)
        {
            if($IntervalObject[$k] -ne $Former)
            {
                $Latter += $IntervalObject[$k];
            }
        }
    }
}