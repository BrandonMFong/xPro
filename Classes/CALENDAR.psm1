# Make a calendar function
class Calendar
{
    # Undefined Variables
    [DateTime]$Today;

    [string]$TodayString;
    [string]$ParseExactDateStringFormat = "MMddyyyy";

    [Week[]]$Weeks;


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
        Write-Host "$($MonthName)";
        Write-Host "su  mo  tu  we  th  fr  sa";
        Write-Host "--  --  --  --  --  --  --";
    }

    hidden [Week[]]WriteWeeks()
    {
        $su=$null;$mo=$null;$tu=$null;$we=$null;$th=$null;$fr=$null;$sa=$null;
        [Week[]]$tempweeks = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);
        $day = $this.Today;
        $MaxDays = $this.GetMaxDayOfMonth($this.MonthToString($this.Today.Month));
        $IsFirstWeek = $true;

        while($true)
        {
            switch ($day.DayOfWeek)
            {
                "Sunday"{$su = $day.Day;}
                "Monday"{$mo = $day.Day;}
                "Tuesday"{$tu = $day.Day;}
                "Wednesday"{$we = $day.Day;}
                "Thursday"{$th = $day.Day;}
                "Friday"{$fr = $day.Day;}
                "Saturday"{$sa = $day.Day;}
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
                        "Sunday"{$su = $day.Day;}
                        "Monday"{$mo = $day.Day;}
                        "Tuesday"{$tu = $day.Day;}
                        "Wednesday"{$we = $day.Day;}
                        "Thursday"{$th = $day.Day;}
                        "Friday"{$fr = $day.Day;}
                        "Saturday"{$sa = $day.Day;}
                        default{Write-Error "something bad happened";}
                    }
                    if($day.DayOfWeek -eq "Saturday"){break;}
                }
                $tempweeks += [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);
                break;
            }
            $day = $day.AddDays(1);
        }
        return $tempweeks;
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

    ToString()
    {
        [string]$week = "";
        if($this.su -ge 10){$week += "$($this.su)  ";}
        else{$week += "$($this.su)   ";}
        if($this.mo -ge 10){$week += "$($this.mo)  ";}
        else{$week += "$($this.mo)   ";}
        if($this.tu -ge 10){$week += "$($this.tu)  ";}
        else{$week += "$($this.tu)   ";}
        if($this.we -ge 10){$week += "$($this.we)  ";}
        else{$week += "$($this.we)   ";}
        if($this.th -ge 10){$week += "$($this.th)  ";}
        else{$week += "$($this.th)   ";}
        if($this.fr -ge 10){$week += "$($this.fr)  ";}
        else{$week += "$($this.fr)   ";}
        if($this.sa -ge 10){$week += "$($this.sa)  ";}
        else{$week += "$($this.sa)   ";}
        Write-Host "$($week)"
    }

}