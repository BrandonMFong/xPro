# Make a calendar function
class Calendar
{
    # Undefined Variables
    [DateTime]$Today;

    # Constructor
    Calendar([DateTime]$Today)
    {
        $this.Today = $Today;
    }    

    # Defined Variables
    $Months = 
    @{
        January = 
        @{
            TotalDays = 31;
        }
        Febuary = 
        @{
            TotalDays =
            @{
                LeapYear = 29;
                OtherYears = 28;
            } 
        }
        March = 
        @{
            TotalDays = 31;
        }
        April =
        @{
            TotalDays = 30;
        }
        May =
        @{
            TotalDays = 31;
        }
        June = 
        @{
            TotalDays = 30;
        }
        July = 
        @{
            TotalDays = 31;
        }
        August = 
        @{
            TotalDays = 31;
        }
        September = 
        @{
            TotalDays = 30;
        }
        October =
        @{
            TotalDays = 31
        }
        November = 
        @{
            TotalDays = 30;
        }
        December =
        @{
            TotalDays = 31;
        }
    }

    # Method
    [void] GetCalendarMonth() # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7
    {
        $DayValue = $this.Today.day;
        while($DayValue -gt 1){$DayValue--;} # getting first day of month
        $DateString = $this.Today.Month.ToString() + "/" # Getting the whole date string
            + $DayValue + "/"
            + $this.Today.Year.ToString();
        $DateString = Get-Date $DateString;
        $DayOfWeek = $DayValue.DayOfWeek;
        switch($DayOfWeek.ToString)
        {
            "Monday"
            {
                # fill out the first week with 0's until this day specified, then increment until you hit total days of month
            }
            "Tuesday"
            {
            
            }
            "Wednesday"
            {

            }
            "Thursday"
            {

            }
            "Friday"
            {

            }
            "Saturday"
            {

            }
            "Sunday"
            {

            }
        }
    }
}