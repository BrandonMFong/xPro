# Make a calendar function
class Calendar
{
    [DateTime]$Today;
    hidden [string]$TodayString;
    hidden [string]$ParseExactDateStringFormat = "MMddyyyy";
    hidden [Week[]]$Weeks;

    [void] GetCalendarMonth() 
    {
        $this.GetNow();
        $this.Weeks = $this.WriteWeeks();
        $this.GetHeaderString();         
        foreach($w in $this.Weeks)
        {
            $w.ToString();
        }
    }

    [int]GetMaxDayOfMonth($Month) #Of the current year
    {
        #Total days
        $Jan=31;$Feb=28;$FebLeapYear=29;$Mar=31;
        $Apr=30;$May=31;$Jun=30;$Jul=31;$Aug=31;
        $Sep=30;$Oct=31;$Nov=30;$Dec=31;
        $MaxDays = 31;
        switch ($Month)
        {
            "January"{$MaxDays =  $Jan;break;}
            "Febuary"
            {
                if (($this.Today.Year % 4 )){$MaxDays =  $FebLeapYear;break;}
                else{$MaxDays =  $Feb;break;};
            }
            "March"{$MaxDays =  $Mar;break;}
            "April"{$MaxDays =  $Apr;break;}
            "May"{$MaxDays =  $May;break;}
            "June"{$MaxDays =  $Jun;break;}
            "July"{$MaxDays =  $Jul;break;}
            "August"{$MaxDays =  $Aug;break;}
            "September"{$MaxDays =  $Sep;break;}
            "October"{$MaxDays =  $Oct;break;}
            "November"{$MaxDays =  $Nov;break;}
            "December"{$MaxDays =  $Dec;break;}
            default {$MaxDays =  31; break;}
        }
        return $MaxDays;
    }

    hidden [string]MonthToString($MonthNum)
    {
        return (Get-UICulture).DateTimeFormat.GetMonthName($MonthNum);
    }
    hidden GetNow()
    {
        $this.Today = Get-Date;
        $this.TodayString = $this.Today.Month.ToString() + $this.Today.Day.ToString() + $this.Today.Year.ToString();
    }

    hidden GetHeaderString()
    {
        $MonthName = $this.MonthToString($this.Today.Month);
        Write-Host "$($MonthName) $($this.Today.Year)";
        Write-Host "su  mo  tu  we  th  fr  sa";
        Write-Host "--  --  --  --  --  --  --";
    }

    hidden [Week[]]WriteWeeks()
    {
        [Day]$su=[Day]::new(0);
        [Day]$mo=[Day]::new(0);
        [Day]$tu=[Day]::new(0);
        [Day]$we=[Day]::new(0);
        [Day]$th=[Day]::new(0);
        [Day]$fr=[Day]::new(0);
        [Day]$sa=[Day]::new(0);

        [Week[]]$tempweeks = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);
        # $day = $this.Today;
        [Day]$day = [Day]::new($this.GetFirstDayOfMonth($this.Today)); # this is returning a null value
        $MaxDays = $this.GetMaxDayOfMonth($this.MonthToString($this.Today.Month));
        $IsFirstWeek = $true;

        while($true)
        {
            switch ($day.DayOfWeek)
            {
                "Sunday"{$su = $day;}
                "Monday"{$mo = $day;}
                "Tuesday"{$tu = $day;}
                "Wednesday"{$we = $day;}
                "Thursday"{$th = $day;}
                "Friday"{$fr = $day;}
                "Saturday"{$sa = $day;}
                default{Write-Error "something bad happened";}
            }
            if($day.DayOfWeek -eq "Saturday")
            {
                if($IsFirstWeek){$tempweeks = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);$IsFirstWeek=$false;}
                else{$tempweeks += [week]::new($su,$mo,$tu,$we,$th,$fr,$sa)}
            }

            if($day.Day -eq $MaxDays)
            {
                while($true)
                {
                    $day = $day.AddDays(1);
                    switch ($day.DayOfWeek)
                    {
                        "Sunday"{$su = $day;}
                        "Monday"{$mo = $day;}
                        "Tuesday"{$tu = $day;}
                        "Wednesday"{$we = $day;}
                        "Thursday"{$th = $day;}
                        "Friday"{$fr = $day;}
                        "Saturday"{$sa = $day;}
                        default{Write-Error "something bad happened";}
                    }
                    if($day.DayOfWeek -eq "Saturday"){break;}
                }
                $tempweeks += [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);
                break;
            }
            $day.AddDays(1);
        }
        return $tempweeks;
    }

    hidden [DateTime]GetFirstDayOfMonth([DateTime]$Date)
    {
        while($true)
        {
            if($Date.Day -eq 1){break;}
            $Date = $Date.AddDays(-1);
        }
        return $Date;
    }

    
}
class Week
{
    #Probably have to make these datetime data type
    [Day]$su;
    [Day]$mo;
    [Day]$tu;
    [Day]$we;
    [Day]$th;
    [Day]$fr;
    [Day]$sa;

    Week([Day]$su, 
        [Day]$mo, 
        [Day]$tu, 
        [Day]$we, 
        [Day]$th, 
        [Day]$fr, 
        [Day]$sa)
    {
        $this.su = $su;
        $this.mo = $mo;
        $this.tu = $tu;
        $this.we = $we;
        $this.th = $th;
        $this.fr = $fr;
        $this.sa = $sa;
    }

    ToString()
    {
        [string]$week = "";
        $this.Evaluate_Days($this.su,[ref]$week);
        $this.Evaluate_Days($this.mo,[ref]$week);
        $this.Evaluate_Days($this.tu,[ref]$week);
        $this.Evaluate_Days($this.we,[ref]$week);
        $this.Evaluate_Days($this.th,[ref]$week);
        $this.Evaluate_Days($this.fr,[ref]$week);
        $this.Evaluate_Days($this.su,[ref]$week);
        Write-Host "$($week)"
    }

    hidden Evaluate_Days([Day]$day,[ref]$week)
    {   
        [Day]$today = [Day]::new($(Get-Date));
        if(($day.Day -ge 10) -and $day.IsEqual($today)){$week.Value += "$($day.DayNum)* ";}
        elseif(($day.Day -lt 10) -and $day.IsEqual($today)){$week.Value += "$($day.DayNum)*  ";}
        elseif(($day.Day -ge 10) -and !($day.IsEqual($today))){$week.Value += "$($day.DayNum)  ";}
        else{$week.Value += "$($day.DayNum)   ";}
    }

}

# https://stackoverflow.com/questions/50203695/powershell-icomparable-with-subclasses
class Day
{ # TODO make day object
    hidden [datetime]$Date;
    [int]$DayNum;
    [string]$DayOfWeek

    Day([DateTime]$Date)
    {
        $this.Date = $Date;
        $this.DayNum = $Date.Day;
        $this.DayOfWeek = $Date.DayOfWeek.ToString();
    }

    [boolean]IsEqual([Day]$d)
    {
        return $d -eq $this.Day;
    }

    # This is not the same as the [Datetime] AddDays() method because the fields I defined are not static.  Should I make it static?
    AddDays([int]$x)
    {
        $this.Date = $this.Date.AddDays($x);
        $this.DayNum = $this.Date.Day;
        $this.DayOfWeek = $this.Date.DayOfWeek.ToString();
    }
}