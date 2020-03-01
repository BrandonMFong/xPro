# Make a calendar function
class Calendar
{
    # Undefined Variables
    [DateTime]$Today;
    [DateTime]$Day;
    [datetime]$Month;
    [datetime]$Year;
    [datetime]$Hour;
    [datetime]$Minute;
    [datetime]$Seconds;

    [string]$TodayString;
    [string]$ParseExactDateStringFormat = "MMddyyyy";

    [Week[]]$Weeks;
    

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

    hidden GetNow()
    {
        $this.Today = Get-Date;
        $this.Day = (Get-Date).Day;
        $this.Month = (Get-Date).Month;
        $this.Year = (Get-Date).Year;
        $this.Hour = (Get-Date).Hour;
        $this.Minute = (Get-Date).Minute;
        $this.Seconds = (Get-Date).Second;

        $this.TodayString = $this.Month.ToString() + $this.Day.ToString() + $this.Year.ToString();
    }

    

    # Method
    [void] GetCalendarMonth() # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7
    {
        $this.GetNow();              
    }

    
}
class Week
{
    [int]$su;
    [int]$mo;
    [int]$tu;
    [int]$we;
    [int]$th;
    [int]$fr;
    [int]$sa;

    Week($su, $mo, $tu, $we, $th, $fr, $sa)
    {
        $this.su = $su;
        $this.mo = $mo;
        $this.tu = $tu;
        $this.we = $we;
        $this.th = $th;
        $this.fr = $fr;
        $this.sa = $sa;
    }

}