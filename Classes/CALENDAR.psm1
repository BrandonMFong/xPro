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
        [DateTime]$su=0;
        [DateTime]$mo=0;
        [DateTime]$tu=0;
        [DateTime]$we=0;
        [DateTime]$th=0;
        [DateTime]$fr=0;
        [DateTime]$sa=0;

        [Week[]]$tempweeks = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);
        # $day = $this.Today;
        $day = $this.GetFirstDayOfMonth($this.Today);
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
            $day = $day.AddDays(1);
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
    [DateTime]$su;
    [DateTime]$mo;
    [DateTime]$tu;
    [DateTime]$we;
    [DateTime]$th;
    [DateTime]$fr;
    [DateTime]$sa;

    Week([DateTime]$su, 
        [DateTime]$mo, 
        [DateTime]$tu, 
        [DateTime]$we, 
        [DateTime]$th, 
        [DateTime]$fr, 
        [DateTime]$sa)
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

        if(($this.su.Day -ge 10) -and ($this.su.Day -eq (Get-Date).Day)){$week += "$($this.su.Day)* ";}
        elseif(($this.su.Day -lt 10) -and ($this.su.Day -eq (Get-Date).Day)){$week += "$($this.su.Day)*  ";}
        elseif(($this.su.Day -ge 10) -and ($this.su.Day -ne (Get-Date).Day)){$week += "$($this.su.Day)  ";}
        else{$week += "$($this.su.Day)   ";}

        if(($this.mo.Day -ge 10) -and ($this.mo.Day -eq (Get-Date).Day)){$week += "$($this.mo.Day)* ";}
        elseif(($this.mo.Day -lt 10) -and ($this.mo.Day -eq (Get-Date).Day)){$week += "$($this.mo.Day)*  ";}
        elseif(($this.mo.Day -ge 10) -and ($this.mo.Day -ne (Get-Date).Day)){$week += "$($this.mo.Day)  ";}
        else{$week += "$($this.mo.Day)   ";}

        if(($this.tu.Day -ge 10) -and ($this.tu.Day -eq (Get-Date).Day)){$week += "$($this.tu.Day)* ";}
        elseif(($this.tu.Day -lt 10) -and ($this.tu.Day -eq (Get-Date).Day)){$week += "$($this.tu.Day)*  ";}
        elseif(($this.tu.Day -ge 10) -and ($this.tu.Day -ne (Get-Date).Day)){$week += "$($this.tu.Day)  ";}
        else{$week += "$($this.tu.Day)   ";}

        if(($this.we.Day -ge 10) -and ($this.we.Day -eq (Get-Date).Day)){$week += "$($this.we.Day)* ";}
        elseif(($this.we.Day -lt 10) -and ($this.we.Day -eq (Get-Date).Day)){$week += "$($this.we.Day)*  ";}
        elseif(($this.we.Day -ge 10) -and ($this.we.Day -ne (Get-Date).Day)){$week += "$($this.we.Day)  ";}
        else{$week += "$($this.we.Day)   ";}

        if(($this.th.Day -ge 10) -and ($this.th.Day -eq (Get-Date).Day)){$week += "$($this.th.Day)* ";}
        elseif(($this.th.Day -lt 10) -and ($this.th.Day -eq (Get-Date).Day)){$week += "$($this.th.Day)*  ";}
        elseif(($this.th.Day -ge 10) -and ($this.th.Day -ne (Get-Date).Day)){$week += "$($this.th.Day)  ";}
        else{$week += "$($this.th.Day)   ";}

        if(($this.fr.Day -ge 10) -and ($this.fr.Day -eq (Get-Date).Day)){$week += "$($this.fr.Day)* ";}
        elseif(($this.fr.Day -lt 10) -and ($this.fr.Day -eq (Get-Date).Day)){$week += "$($this.fr.Day)*  ";}
        elseif(($this.fr.Day -ge 10) -and ($this.fr.Day -ne (Get-Date).Day)){$week += "$($this.fr.Day)  ";}
        else{$week += "$($this.fr.Day)   ";}

        if(($this.sa.Day -ge 10) -and ($this.sa.Day -eq (Get-Date).Day)){$week += "$($this.sa.Day)* ";}
        elseif(($this.sa.Day -lt 10) -and ($this.sa.Day -eq (Get-Date).Day)){$week += "$($this.sa.Day)*  ";}
        elseif(($this.sa.Day -ge 10) -and ($this.sa.Day -ne (Get-Date).Day)){$week += "$($this.sa.Day)  ";}
        else{$week += "$($this.sa.Day)   ";}

        Write-Host "$($week)"
    }

}

# https://stackoverflow.com/questions/50203695/powershell-icomparable-with-subclasses
class Day
{ # TODO make day object
    [int]$Day;
    [string]$DayOfWeek
    hidden [datetime]$val;

    Day([DateTime]$Date)
    {
        $this.Day = $Date.Day;
        $this.DayOfWeek = $Date.DayOfWeek.ToString();
    }
}