class Calendar
{
    [Day]$Today = [Day]::new($(Get-Date),$null);
    hidden [Week[]]$Weeks;
    hidden [boolean]$WeeksLoaded = $false;
    hidden $SQL;
    # hidden $SQL = [SQL]::new('TestDB','BRANDONMFONG\SQLEXPRESS', $null, $false, $false, 'ID EventDate'); # This needs to be unique per config
    hidden [string]$PathToImportFile;
    hidden [string]$EventConfig = "XML";
    [string]$TimeStampFilePath; # this is for timestamp.csv, if I do not have database
    hidden [string]$ResourceDir = $($PSScriptRoot + "\..\Resources\Calendar\");  
    [Week]$ThisWeek;
    [string]$FirstDayString = "Sunday";

    Calendar([String]$PathToImportFile,[string]$EventConfig,[string]$TimeStampFilePath,[string]$FirstDayOfWeek)
    {
        $this.PathToImportFile = $PathToImportFile;
        if(![string]::IsNullOrEmpty($FirstDayOfWeek)){$this.FirstDayString = $FirstDayOfWeek;}
        if(![string]::IsNullOrEmpty($EventConfig))
        {
            $this.EventConfig = $EventConfig;
            if($EventConfig -eq "Database"){$this.SQL = $(GetObjectByClass('SQL'));}
            else{$this.SQL = $null;}
        }
        $this.TimeStampFilePath = $TimeStampFilePath;
        $this.MakeNecessaryDirectories();
        $this.LoadThisWeek();
    }

    hidden [void]LoadThisWeek()
    {
        # This can potential better the WriteWeek algorithm
        [DateTime]$Day = $this.GetFirstDayOfWeek();
        [Day]$su=[Day]::new($Day.AddDays(0),$this.EventConfig);
        [Day]$mo=[Day]::new($Day.AddDays(1),$this.EventConfig);
        [Day]$tu=[Day]::new($Day.AddDays(2),$this.EventConfig);
        [Day]$we=[Day]::new($Day.AddDays(3),$this.EventConfig);
        [Day]$th=[Day]::new($Day.AddDays(4),$this.EventConfig);
        [Day]$fr=[Day]::new($Day.AddDays(5),$this.EventConfig);
        [Day]$sa=[Day]::new($Day.AddDays(6),$this.EventConfig);
        $this.ThisWeek = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa,$this.WeekNum($this.FirstDayString));
    }

    hidden [DateTime]GetFirstDayOfWeek()
    {
        [DateTime]$hold = $this.Today.Date;
        while($true)
        {
            # Need to be Sunday because it is the default first day of the week
            if($hold.DayOfWeek -eq "Sunday"){break;}
            else{$hold = $hold.AddDays(-1);}
        }
        return $hold;
    }
    
    hidden [void]MakeNecessaryDirectories(){if(!(Test-Path $this.ResourceDir)){mkdir $this.ResourceDir;}}

    hidden [void] Reset(){$this.WeeksLoaded = $false;}

    [void] GetCalendarMonth() 
    {
        $this.GetNow();
        if(!$this.WeeksLoaded){$this.Weeks = $this.WriteWeeks();}
        $this.GetHeaderString();
        foreach($w in $this.Weeks){$w.ToString();}
    }

    [void] GetCalendarMonth([string]$MonthString) 
    {
        $this.GetNow($this.GetMonthNum($MonthString));
        if(!$this.WeeksLoaded){$this.Weeks = $this.WriteWeeks();}
        $this.GetHeaderString();
        foreach($w in $this.Weeks){$w.ToString();}
    }

    [int]GetMaxDayOfMonth([string]$Month) #Of the current year
    {
        #Total days
        $Jan=31;$Feb=28;$FebLeapYear=29;$Mar=31;
        $Apr=30;$May=31;$Jun=30;$Jul=31;$Aug=31;
        $Sep=30;$Oct=31;$Nov=30;$Dec=31;
        $MaxDays = 31;
        switch ($Month)
        {
            "January"{$MaxDays =  $Jan;break;}
            "February"
            {
                if (($this.Today.Date.Year % 4 )){$MaxDays =  $FebLeapYear;break;}
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

    [byte]GetMonthNum([string]$x)
    {
        [byte]$i = 0x00;
        switch ($x)
        {
            "January"{$i = 0x01;break;}
            "February"{$i = 0x02;break;}
            "March"{$i = 0x03;break;}
            "April"{$i = 0x04;break;}
            "May"{$i = 0x05;break;}
            "June"{$i = 0x06;break;}
            "July"{$i = 0x07;break;}
            "August"{$i = 0x08;break;}
            "September"{$i = 0x09;break;}
            "October"{$i = 0x0a;break;}
            "November"{$i = 0x0b;break;}
            "December"{$i = 0x0c;break;}
            default {$i = 0xff;break;}
        }
        return $i;
    }

    [void]Events()
    {
        if($this.EventConfig -eq "Database")
        {
            [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\GetAllEvents.sql)";
            [System.Object[]]$Events = $this.SQL.Query($querystring);
            for([int]$i=0;$i -lt $Events.Length;$i++)
            {
                $this.EventToString([Day]::new((Get-Date $Events[$i].EventDate.ToString("MM/dd/yyyy")),$this.EventConfig),$Events[$i].Subject);
            }
        }
        else
        {
            [xml]$x = GetXMLContent;
            foreach($Event in $x.Machine.Calendar.SpecialDays.SpecialDay)
            {
                $this.EventToString($Event.InnerXML,$Event.Name);
            }
        }
    }

    hidden [void]EventToString([Day]$EventDate,[string]$Subject)
    {
        if($this.Today.IsEqual($EventDate)){Write-Host "***" -NoNewline;}
        Write-Host "$($Subject)" -ForegroundColor Yellow -NoNewline;
        Write-Host " - " -NoNewline;
        Write-Host "$($EventDate.Date.ToString("MM/dd/yyyy"))" -ForegroundColor Cyan -NoNewline;
        if($this.Today.IsEqual($EventDate)){Write-Host "***";}
        else{Write-Host "";}
    }

    hidden [string]MonthToString([int]$MonthNum){return (Get-UICulture).DateTimeFormat.GetMonthName($MonthNum);}

    hidden [Void]UpdateDay(){$this.Today = [Day]::new($(Get-Date),$this.EventConfig)}

    hidden GetNow(){$this.UpdateDay();}

    hidden GetNow([byte]$m)
    {
        if($(Get-Date).Month -ne $m){$this.WeeksLoaded = $false;} # for the case m is for a different month
        $this.Today = Get-Date $($m.ToString() + "/1/" + (Get-Date).Year.ToString());
    }

    hidden GetHeaderString()
    {   
        Write-Host "$($this.MonthToString($this.Today.Month)) $($this.Today.Year)";
        # Write-Host "su  mo  tu  we  th  fr  sa";
        $this.ThisWeek.ToHeader();
        Write-Host "--  --  --  --  --  --  --";
    }

    hidden [Week[]]WriteWeeks()
    {
        [Day]$su=[Day]::new(0,$this.EventConfig);
        [Day]$mo=[Day]::new(0,$this.EventConfig);
        [Day]$tu=[Day]::new(0,$this.EventConfig);
        [Day]$we=[Day]::new(0,$this.EventConfig);
        [Day]$th=[Day]::new(0,$this.EventConfig);
        [Day]$fr=[Day]::new(0,$this.EventConfig);
        [Day]$sa=[Day]::new(0,$this.EventConfig);

        [Week[]]$tempweeks = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa,$this.WeekNum($this.FirstDayString));
        [Day]$day = [Day]::new($this.GetFirstDayOfMonth($this.Today.Date),$this.EventConfig); # this is returning a null value
        [int]$MaxDays = $this.GetMaxDayOfMonth($this.MonthToString($this.Today.Month));
        [bool]$IsFirstWeek = $true;

        while($true)
        {
            switch ($day.DayOfWeek)
            {
                "Sunday"{$su = $day;break;}
                "Monday"{$mo = $day;break;}
                "Tuesday"{$tu = $day;break;}
                "Wednesday"{$we = $day;break;}
                "Thursday"{$th = $day;break;}
                "Friday"{$fr = $day;break;}
                "Saturday"{$sa = $day;break;}
                default{Write-Error "something bad happened";}
            }
            if($day.DayOfWeek -eq "Saturday")
            {
                if($IsFirstWeek)
                {
                    $tempweeks = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa,$this.WeekNum($this.FirstDayString));$IsFirstWeek=$false;
                    $tempweeks.FillWeek();
                }
                else{$tempweeks += [week]::new($su,$mo,$tu,$we,$th,$fr,$sa,$this.WeekNum($this.FirstDayString))}
            }

            #Fills up the rest of the month
            if($day.Number -eq $MaxDays)
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
                $tempweeks += [week]::new($su,$mo,$tu,$we,$th,$fr,$sa,$this.WeekNum($this.FirstDayString));
                break;
            }
            $day = $day.AddDays(1);
        }
        $this.WeeksLoaded = $true;
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
    
    # I can probably consolodate Insert & TimeStamp
    [void]InsertEvents()
    {
        [System.Object[]]$CSVReader = Get-Content $this.PathToImportFile | ConvertFrom-Csv;
        for([int]$i=0;$i -lt $CSVReader.Length;$i++)
        {
            [string]$insertquery = $null;
            [string]$tablename = "Calendar"; # hard coding table name
            [System.Object[]]$values = $this.SQL.GetTableSchema($tablename);
            
            # Adds the actual values to use for the insert query
            # There are also checks for other types of 
            foreach($val in $values)
            {
                # goes through rows in csv and loads the value
                if($val.COLUMN_NAME -eq "TypeContentID"){$val.Value = ($this.SQL.Query("select id from typecontent where externalid = 'Event'")).ID;} #Typecontent externalid is 'Event'
                if($val.COLUMN_NAME -eq "ExternalID"){$val.Value = $CSVReader[$i].ExternalID;}
                if($val.COLUMN_NAME -eq "Subject"){$val.Value = $CSVReader[$i].Subject.Replace("'","''");}
                if($val.COLUMN_NAME -eq "EventDate"){$val.Value = $CSVReader[$i].EventDate;}
                if($val.COLUMN_NAME -eq "IsAnnual"){$val.Value = $CSVReader[$i].IsAnnual;}
            }
            $this.SQL.QueryConstructor("Insert",[ref]$insertquery,$tablename,$values); # constucts
            [string]$extid = $CSVReader[$i].ExternalID; # extracts external id
            [string]$querystring = "if not exists (select * from $($tablename) where ExternalID = '$($extid)') begin @insertquery end" # If exists query
            $this.SQL.QueryNoReturn($querystring.Replace("@insertquery", $insertquery));
        }
    }

    hidden [void]TimeStamp([string]$TypeContentExternalID,[string]$TypeString)
    {
        [string]$insertquery = $null;
        [string]$tablename = "Calendar"; # hard coding table name
        [System.Object[]]$values = $this.SQL.GetTableSchema($tablename);
        
        [string]$CalendarExtID = $((Get-Date -Format "MMddyyyy").ToString()); # DateTime ExternalID (format MMddyyyy)

        # Adds the actual values to use for the insert query
        # There are also checks for other types of 
        foreach($val in $values)
        {
            # goes through rows in csv and loads the value
            if($val.COLUMN_NAME -eq "TypeContentID"){$val.Value = ($this.SQL.Query("select id from typecontent where externalid = '$($TypeContentExternalID)'")).ID;} #Typecontent externalid is 'Event'
            if($val.COLUMN_NAME -eq "ExternalID"){$val.Value = $CalendarExtID;}
            if($val.COLUMN_NAME -eq "Subject"){$val.Value = "[$($TypeString)] $(Get-Date -Format "MM/dd, hh:mm:ss tt")" ;}
            if($val.COLUMN_NAME -eq "EventDate"){$val.Value = "$(Get-Date)";}
            if($val.COLUMN_NAME -eq "IsAnnual"){$val.Value = "0";}
        }

        # There can be more than one row for time in/out
        # It the matter of how to organize it
        # in the query I rank them from young to old records and join them
        # But what if I never time out and there is always one more time in record
        # I can handle this in the query
        $this.SQL.QueryConstructor("Insert",[ref]$insertquery,$tablename,$values); # constucts
        [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\TimeStamp.sql)";
        $querystring = $querystring.Replace("@insertquery",$insertquery);
        $querystring = $querystring.Replace("@CalendarExtID",$CalendarExtID);
        $querystring = $querystring.Replace("@TCExterID",$TypeContentExternalID);
        $this.SQL.QueryNoReturn($querystring);
    }

    [void]TimeIn(){$this.TimeStamp('TimeStampIn','TIME IN')}
    [void]TimeOut(){$this.TimeStamp('TimeStampOut','TIME OUT')}
    [string]GetTimeStampDuration()
    {
        [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\GetTimeStampDuration.sql)";
        [string]$time = $($this.SQL.Query($querystring)).Time;
        if($time -eq "0:0:"){return $null;} # when you haven't timed in yet
        else{return "$($(Get-Date $time).ToString('HH:mm:ss'))";}
    }

    [void]Report(){$this.GetTime("Select");}

    [void]Report([string]$MinDate,[string]$MaxDate){$this.GetTime("Select",[string]$MinDate,[string]$MaxDate);}

    [void]Export(){$this.GetTime("Export");}

    [void]Export([string]$MinDate,[string]$MaxDate){$this.GetTime("Export",[string]$MinDate,[string]$MaxDate);}

    hidden [Void]GetTime([string]$Method)
    {
        [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\FullTimeStampReport.sql)";
        $querystring = $querystring.Replace("@MinDateExt","'1/1/2000 00:00:00.0000000'"); # Default range for full report
        $querystring = $querystring.Replace("@MaxDateExt","'12/31/9999 00:00:00.0000000'");
        $this.FinalStep($Method,$querystring);
    }
    hidden [Void]GetTime([string]$Method,[string]$MinDate,[string]$MaxDate)
    {
        [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\FullTimeStampReport.sql)";
        $querystring = $querystring.Replace("@MinDateExt","'$($MinDate)'");
        $querystring = $querystring.Replace("@MaxDateExt","'$($MaxDate)'");
        $this.FinalStep($Method,$querystring);
    }

    # Two different methods
    # Select: prints full time stamp report
    hidden [Void]FinalStep([string]$Method,[string]$querystring)
    {
        if($Method -eq "Select"){$this.WriteTimeReport($this.SQL.Query($querystring));}
        if($Method -eq "Export")
        {
            $this.GetNow();
            [System.Object[]]$ExportCSV = $this.SQL.Query($querystring);
            [string]$ExportName = $($this.ResourceDir + "\Time_" + $this.Today.DateString + ".csv");
            $ExportCSV | Export-Csv $ExportName -Force;
        }
    }

    hidden [void]WriteTimeReport([System.Object[]]$results)
    {
        try
        {
            if($null -ne $results)
            {
                Write-Host "`n ------------------------------------------------------ ";
                Write-Host "|                    TIME REPORT                       |";
                Write-Host " ------------------------------------------------------ ";
                Write-Host "|    Date    |      Time In       |      Time Out      |"
            }
            for([int]$i = 0;$i -lt $results.Length;$i++)
            {
                [string]$TimeIn =  $(Get-Date $results[$i].TimeIn -Format "hh:mm:ss tt");
                if($results[$i].TimeOut -ne "--:--:-- --"){[string]$TimeOut =  $(Get-Date $results[$i].TimeOut -Format "hh:mm:ss tt");}
                else{[string]$TimeOut = $results[$i].TimeOut;}
                Write-Host "| $($results[$i].Date) |     $($TimeIn)    |     $($TimeOut)    |"
            }
            if($null -ne $results)
            {
                Write-Host " ------------------------------------------------------ `n";
            }
        }
        catch [System.Management.Automation.ParameterBindingException]
        {
            throw "You might have not timed out.  Run Fix Time Stamp query, but please check!";
        }
    }

    [void]FixTimeStamp()
    {
        Write-Warning "This will insert a time out stamp based on the last null pair.";
        if('y' -eq $(Read-Host -Prompt 'Do you want to continue?'))
        {
            [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\FixTimeStamp.sql)";
            $this.SQL.QueryNoReturn($querystring);
            Write-Host "Query executed.";
        }
        else{Write-Host "Not executing.";}
    }

    # I can implement the calendar to adjust first day of week using these indexes
    hidden [int]WeekNum([string]$DayOfWeek)
    {
        [int]$WeekNum = 0;
        switch($DayOfWeek)
        {
            "Sunday"{$WeekNum = 1;}
            "Monday"{$WeekNum = 2;}
            "Tuesday"{$WeekNum = 3;}
            "Wednesday"{$WeekNum = 4;}
            "Thursday"{$WeekNum = 5;}
            "Friday"{$WeekNum = 6;}
            "Saturday"{$WeekNum = 7;}
            Default{$WeekNum = 1;} # Default Sunday
        }
        return $WeekNum;
    }
}

# The idea of ordering the week by the first day of the week is adding 7 to the days depending on which day that is offset
class Week
{
    [Day]$su;[Day]$mo;[Day]$tu;[Day]$we;
    [Day]$th;[Day]$fr;[Day]$sa;
    [int]$FirstDayIndex;
    hidden [int]$IndexCheck = 0;

    Week([Day]$su,[Day]$mo,[Day]$tu,[Day]$we,[Day]$th,[Day]$fr,[Day]$sa,[int]$FirstDayIndex)
    {
        $this.su = $su;$this.mo = $mo;$this.tu = $tu;
        $this.we = $we;$this.th = $th;$this.fr = $fr;
        $this.sa = $sa;
        $this.FirstDayIndex = $FirstDayIndex;
    }

    [void]ToHeader()
    {
        [string]$header = "";
        $this.InOrderHeader($this.FirstDayIndex,[ref]$header);
        Write-Host "$($header)"
    }
    
    hidden InOrderHeader([int]$index,[ref]$header)
    {
        if($index -eq 8){$index = 1;}
        if($this.IndexCheck -lt 7){$this.IndexCheck++;}
        else{break;}
        switch($index)
        {
            1{$header.Value += $this.su.GetAbbreviation();$this.InOrderHeader(($index+1),$header);}
            2{$header.Value += $this.mo.GetAbbreviation();$this.InOrderHeader(($index+1),$header);}
            3{$header.Value += $this.tu.GetAbbreviation();$this.InOrderHeader(($index+1),$header);}
            4{$header.Value += $this.we.GetAbbreviation();$this.InOrderHeader(($index+1),$header);}
            5{$header.Value += $this.th.GetAbbreviation();$this.InOrderHeader(($index+1),$header);}
            6{$header.Value += $this.fr.GetAbbreviation();$this.InOrderHeader(($index+1),$header);}
            7{$header.Value += $this.sa.GetAbbreviation();$this.InOrderHeader(($index+1),$header);}
        }
    }

    [void]ToString()
    {
        [string]$week = "";
        $this.InOrderWeek($this.FirstDayIndex,[ref]$week);
        Write-Host "$($week)"
    }

    hidden [void]InOrderWeek([int]$index,[ref]$week)
    {
        if($index -eq 8){$index = 1;}
        if($this.IndexCheck -lt 7){$this.IndexCheck++;}
        else{break;}
        switch($index)
        {
            # How do I offset a week if the first day of the week is n
            # There needs to be a method
            1{$this.Evaluate_Days($this.su.AddDays($this.GetOffset($this.FirstDayIndex,1)),$week);$this.InOrderWeek(($index+1),$week);}
            2{$this.Evaluate_Days($this.mo.AddDays($this.GetOffset($this.FirstDayIndex,2)),$week);$this.InOrderWeek(($index+1),$week);}
            3{$this.Evaluate_Days($this.tu.AddDays($this.GetOffset($this.FirstDayIndex,3)),$week);$this.InOrderWeek(($index+1),$week);}
            4{$this.Evaluate_Days($this.we.AddDays($this.GetOffset($this.FirstDayIndex,4)),$week);$this.InOrderWeek(($index+1),$week);}
            5{$this.Evaluate_Days($this.th.AddDays($this.GetOffset($this.FirstDayIndex,5)),$week);$this.InOrderWeek(($index+1),$week);}
            6{$this.Evaluate_Days($this.fr.AddDays($this.GetOffset($this.FirstDayIndex,6)),$week);$this.InOrderWeek(($index+1),$week);}
            7{$this.Evaluate_Days($this.sa.AddDays($this.GetOffset($this.FirstDayIndex,7)),$week);$this.InOrderWeek(($index+1),$week);}
        }
    }

    hidden [int]GetOffset([int]$Offset,[int]$DayNum)
    {
        if($Offset -gt $DayNum){return 7;}
        else{return 0;}
    }

    FillWeek()
    {
        if($this.sa.Number -eq 1)
        {
            $this.fr = $this.sa.AddDays(-1);
            $this.th = $this.sa.AddDays(-2);
            $this.we = $this.sa.AddDays(-3);
            $this.tu = $this.sa.AddDays(-4);
            $this.mo = $this.sa.AddDays(-5);
            $this.su = $this.sa.AddDays(-6);
        }
        elseif($this.fr.Number -eq 1)
        {
            $this.th = $this.fr.AddDays(-1);
            $this.we = $this.fr.AddDays(-2);
            $this.tu = $this.fr.AddDays(-3);
            $this.mo = $this.fr.AddDays(-4);
            $this.su = $this.fr.AddDays(-5);
        }
        elseif($this.th.Number -eq 1)
        {
            $this.we = $this.th.AddDays(-1);
            $this.tu = $this.th.AddDays(-2);
            $this.mo = $this.th.AddDays(-3);
            $this.su = $this.th.AddDays(-4);
        }
        elseif($this.we.Number -eq 1)
        {
            $this.tu = $this.we.AddDays(-1);
            $this.mo = $this.we.AddDays(-2);
            $this.su = $this.we.AddDays(-3);
        }
        elseif($this.tu.Number -eq 1)
        {
            $this.mo = $this.tu.AddDays(-1);
            $this.su = $this.tu.AddDays(-2);
        }
        else
        {
            $this.su = $this.mo.AddDays(-1);
        }
    }

    hidden Evaluate_Days([Day]$day,[ref]$week)
    {   
        [Day]$today = [Day]::new($(Get-Date),$null);
        if(($day.Number -ge 10) -and $day.IsEqual($today)){$week.Value += "$($day.Number)* ";} # For Current Day
        elseif(($day.Number -lt 10) -and $day.IsEqual($today)){$week.Value += "$($day.Number)*  ";} # For Current Day
        elseif(($day.Number -ge 10) -and $day.IsSpecialDay()){$week.Value += "$($day.Number)^ ";} # For Special Day
        elseif(($day.Number -lt 10) -and $day.IsSpecialDay()){$week.Value += "$($day.Number)^  ";} # For Special Day
        elseif(($day.Number -ge 10) -and !($day.IsEqual($today))){$week.Value += "$($day.Number)  ";} # For Normal Day
        else{$week.Value += "$($day.Number)   ";} # For Normal Day
    }
}

class Day
{ 
    [DateTime]$Date;
    [int]$Number;
    [int]$Month;
    [int]$Year;
    [string]$DayOfWeek
    [string]$DateString;
    hidden $SQL;
    [string]$EventConfig;

    Day([DateTime]$Date,$EventConfig)
    {
        $this.Date = $Date;
        $this.Number = $Date.Day;
        $this.Month = $Date.Month;
        $this.Year = $Date.Year;
        $this.DateString = $Date.ToString("MMddyyyy"); # following externalid format in calendar table
        $this.DayOfWeek = $Date.DayOfWeek.ToString();
        if(![string]::IsNullOrEmpty($EventConfig))
        {
            $this.EventConfig = $EventConfig;
            if($EventConfig -eq "Database"){$this.SQL = $(GetObjectByClass('SQL'));}
            else{$this.SQL = $null;}
        }
    }

    [string]GetAbbreviation(){return "$($this.DayOfWeek.ToLower().SubString(0,2))  ";}

    [boolean]IsEqual([Day]$d) # Not comparing time
    {
        return ($d.Number -eq $this.Number) -and ($d.Month -eq $this.Month) -and ($d.Year -eq $this.Year);
    }

    [Day]AddDays([int]$x){return [Day]::new($this.Date.AddDays($x),$this.EventConfig);}

    [boolean]IsSpecialDay()
    {
        [boolean]$IsSpecialDay = $false;
        if($this.EventConfig -eq "Database")
        {
            [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\IsEvent.sql)";
            $querystring = $querystring.Replace('@DayString',$this.DateString);
            if(($this.SQL.Query($querystring)).Exists)
            {$IsSpecialDay = $true;}
        }
        else
        {
            Push-Location $PSScriptRoot;
                [xml]$xml = Get-Content $("..\Config\" + $env:COMPUTERNAME.ToString() + ".xml");
            Pop-Location;
            foreach($x in $xml.Machine.Calendar.SpecialDays.SpecialDay)
            {
                [Day]$d = [Day]::new($(Get-Date $x.InnerXML),$null);
                if(($d.Number -eq $this.Number) -and ($d.Month -eq $this.Month) -and ($d.Year -eq $this.Year))
                {
                    $IsSpecialDay = $true;
                    break;
                }
            }
        }
        return $IsSpecialDay;
    }
}


# [Calendar]$test = [Calendar]::new('B:\Powershell\Resources\CalendarImports\ImportEvents.csv');
# $test.InsertEvents();
# $test.GetCalendarMonth();
# $test.GetCalendarMonth("June");