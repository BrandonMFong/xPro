# using module .\SQL.psm1;
# Import-Module $PSScriptRoot\..\Modules\FunctionModules.psm1;
# Make a calendar function

class Calendar
{
    [DateTime]$Today;
    hidden [string]$TodayString;
    hidden [string]$ParseExactDateStringFormat = "MMddyyyy";
    hidden [Week[]]$Weeks;
    hidden [boolean]$WeeksLoaded = $false;
    hidden $SQL;
    # hidden $SQL = [SQL]::new('TestDB','BRANDONMFONG\SQLEXPRESS', $null, $false, $false, 'ID EventDate'); # This needs to be unique per config
    hidden [string]$PathToImportFile;
    hidden [string]$EventConfig = "XML";
    [string]$TimeStampFilePath;

    Calendar([String]$PathToImportFile,[string]$EventConfig,[string]$TimeStampFilePath)
    {
        $this.PathToImportFile = $PathToImportFile;
        if(![string]::IsNullOrEmpty($EventConfig))
        {
            $this.EventConfig = $EventConfig;
            if($EventConfig -eq "Database"){$this.SQL = $(GetObjectByClass('SQL'));}
            else{$this.SQL = $null;}
        }
        $this.TimeStampFilePath = $TimeStampFilePath;
        $this.MakeNecessaryDirectories();
    }
    
    hidden [void]MakeNecessaryDirectories()
    {
        if(!(Test-Path $PSScriptRoot\..\Resources\CalendarImports\)){mkdir $PSScriptRoot\..\Resources\CalendarImports\;}
    }

    [void] Reset()
    {
        $this.WeeksLoaded = $false;
    }

    [void] GetCalendarMonth() 
    {
        $this.GetNow();
        if(!$this.WeeksLoaded){$this.Weeks = $this.WriteWeeks();}
        $this.GetHeaderString();         
        foreach($w in $this.Weeks)
        {
            $w.ToString();
        }
    }

    [void] GetCalendarMonth([string]$MonthString) 
    {
        $this.GetNow($this.GetMonthNum($MonthString));
        if(!$this.WeeksLoaded){$this.Weeks = $this.WriteWeeks();}
        $this.GetHeaderString();         
        foreach($w in $this.Weeks)
        {
            $w.ToString();
        }
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

    [void]SpecialDays()
    {
        if($this.EventConfig -eq "Database")
        {
            [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\GetAllEvents.sql)";
            [System.Object[]]$Events = $this.SQL.Query($querystring);
            for([int]$i=0;$i -lt $Events.Length;$i++)
            {
                $this.EventToString($Events[$i].EventDate.ToString("MM/dd/yyyy"),$Events[$i].Subject);
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

    hidden [void]EventToString([string]$EventDate,[string]$Subject)
    {
        if($this.IsSpecialDay([Day]::new((Get-Date $EventDate),$null))){Write-Host "***" -NoNewline;}
        Write-Host "$($Subject)" -ForegroundColor Yellow -NoNewline;
        Write-Host " - " -NoNewline;
        Write-Host "$($EventDate)" -ForegroundColor Cyan -NoNewline;
        if($this.IsSpecialDay([Day]::new((Get-Date $EventDate),$null))){Write-Host "***";}
        else{Write-Host "";}
    }

    hidden [boolean]IsSpecialDay([Day]$Day)
    {
        [Day]$ThisDay = [Day]::new($(Get-Date),$null);
        return $ThisDay.IsEqual($Day);
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

    hidden GetNow([byte]$m)
    {
        if($(Get-Date).Month -ne $m){$this.WeeksLoaded = $false;} # for the case m is for a different month
        $this.Today = Get-Date $($m.ToString() + "/1/" + (Get-Date).Year.ToString());
        $this.TodayString = $this.Today.Month.ToString() + $this.Today.Day.ToString() + $this.Today.Year.ToString();
    }

    hidden GetHeaderString()
    {   
        Write-Host "$($this.MonthToString($this.Today.Month)) $($this.Today.Year)";
        Write-Host "su  mo  tu  we  th  fr  sa";
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

        [Week[]]$tempweeks = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);
        [Day]$day = [Day]::new($this.GetFirstDayOfMonth($this.Today),$this.EventConfig); # this is returning a null value
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
                    $tempweeks = [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);$IsFirstWeek=$false;
                    $tempweeks.FillWeek();
                }
                else{$tempweeks += [week]::new($su,$mo,$tu,$we,$th,$fr,$sa)}
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
                $tempweeks += [week]::new($su,$mo,$tu,$we,$th,$fr,$sa);
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
    
    [void]InsertEvents()
    {
        [System.Object[]]$CSVReader = Get-Content $this.PathToImportFile | ConvertFrom-Csv;
        for([int]$i=0;$i -lt $CSVReader.Length;$i++)
        {
            [string]$insertquery = $null;
            [string]$tablename = "Calendar"; # hard coding table name
            $values = $this.SQL.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($tablename)'"); # By now the table should be created
            $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value); # add another column, this makes sure that columns/data is in order
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
        $values = $this.SQL.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($tablename)'"); # By now the table should be created
        $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value); # add another column, this makes sure that columns/data is in order
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
        $this.SQL.QueryConstructor("Insert",[ref]$insertquery,$tablename,$values); # constucts
        [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\TimeStamp.sql)";
        $querystring = $querystring.Replace("@tablename",$tablename);
        $querystring = $querystring.Replace("@CalendarExtID",$CalendarExtID);
        $querystring = $querystring.Replace("@TCExterID",$TypeContentExternalID);
        $this.SQL.QueryNoReturn($querystring.Replace("@insertquery", $insertquery));
        # $this.SQL.QueryNoReturn($insertquery);
    }

    [void]TimeIn(){$this.TimeStamp('TimeStampIn','TIME IN')}
    [void]TimeOut(){$this.TimeStamp('TimeStampOut','TIME OUT')}
    [void]GetTimeStampDuration()
    {
        [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\GetTimeStampDuration.sql)";
        [string]$time = $($this.SQL.Query($querystring)).Time;
        Write-Host "Log Time: $($(Get-Date $time).ToString('HH:mm:ss'))";
    }
}
class Week
{
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
        $this.Evaluate_Days($this.sa,[ref]$week);
        Write-Host "$($week)"
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
    hidden [datetime]$Date;
    [int]$Number;
    [int]$Month;
    [int]$Year;
    [string]$DayOfWeek
    [string]$DayString;
    hidden $SQL = $(GetObjectByClass('SQL'));
    [string]$EventConfig;

    Day([DateTime]$Date,$EventConfig)
    {
        $this.Date = $Date;
        $this.Number = $Date.Day;
        $this.Month = $Date.Month;
        $this.Year = $Date.Year;
        $this.DayString = $Date.ToString("MMddyyyy"); # following externalid format in calendar table
        $this.DayOfWeek = $Date.DayOfWeek.ToString();
        $this.EventConfig = $EventConfig;
    }

    [boolean]IsEqual([Day]$d) # Not comparing time
    {
        return ($d.Number -eq $this.Number) -and ($d.Month -eq $this.Month) -and ($d.Year -eq $this.Year);
    }

    [Day]AddDays([int]$x)
    {
        return [Day]::new($this.Date.AddDays($x),$this.EventConfig)
    }

    [boolean]IsSpecialDay()
    {
        [boolean]$IsSpecialDay = $false;
        if($this.EventConfig -eq "Database")
        {
            [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQLQueries\IsEvent.sql)";
            $querystring = $querystring.Replace('@DayString',$this.DayString);
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