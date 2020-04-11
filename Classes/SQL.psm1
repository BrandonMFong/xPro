# A way for me to query my local db through powershell
# Object for each database
class SQL 
{
    # Object fields
    [string]$serverinstance;
    [string]$database;
    [System.Object[]]$results;
    [System.Object[]]$tables;

    # Constructor
    SQL([string]$database, [string]$serverinstance, [System.Object[]]$tables)
    {
        $this.database = $database;
        $this.serverinstance = $serverinstance;
        $this.tables = $tables
        $this.SyncConfig();
    }

    # Standard queries
    [System.Object[]]Query([string]$querystring)
    {
        $this.results = $null # reset
        $this.results = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        if($null -eq $this.results){throw "Nothing returned from query string"}
        else {return $this.results;} # display
    }

    # This function can insert into all different tables in a database
    [System.Object[]]InsertInto()
    {
        $querystring = $null;

        [system.object[]]$tablestochoosefrom = $this.Query('select table_name from Information_schema.tables');

        Write-Host "`nWhich Table are you inserting into?" -ForegroundColor Red -BackgroundColor Yellow;
        $i = 0;
        foreach ($t in $tablestochoosefrom){$i++;Write-host "$($i) - $($t.ItemArray)";} 
        $index = Read-Host -Prompt "So?";
        if($index -gt $i){throw "Index out of range";break;}
        
        # If you are inserting into personalinfo then print type content table
        if([string]($tablestochoosefrom[$index-1].ItemArray) -eq "PersonalInfo")
        {
            [System.Object[]]$Table = $this.Query("select * from typecontent");
            Write-Host "`nType Content Table:";
            Write-Host "ID" -ForegroundColor Red -NoNewline;
            Write-Host " - " -NoNewline;
            Write-Host "Description" -ForegroundColor Red;
            foreach($t in $Table)
            {
                foreach($item in $t)
                {
                    Write-Host "$($item.ID)" -ForegroundColor Green -NoNewline;
                    Write-Host " - " -NoNewline;
                    Write-Host "$($item.Description)" -ForegroundColor Green;
                }
            }
            Write-Host `n;
        }
        
        $table = $tablestochoosefrom[$index - 1].ItemArray;
        $NewIDShouldBe = $this.Query("select max(id)+1 from $($table)");

        Write-Warning "The new id should be: $($NewIDShouldBe.ItemArray)`n`n";


        $values = $this.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($table)'");
        $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value); # add another column

        # Prompt user what values they want to insert per column
        foreach($val in $values)
        {
            if($val.DATA_TYPE -ne 'uniqueidentifier') # you do not need to provide a guid since it's already being provided
            {
                Write-Warning "For $($val.COLUMN_NAME)";
                $val.Value = Read-Host -Prompt "Value?";
            }
        }

        $this.QueryConstructor("Insert", [ref]$querystring, $table, $values);

        Write-Host "Query: $($querystring)"

        try{Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;}
        catch
        {
            Write-Warning "$($_)";
            break;
        }

        Write-Host "`nNew Data inserted successfully" -ForegroundColor Green;
        $ColumnName = $values[0].COLUMN_NAME;
        $NewValueForID = $values[0].Value;
        $this.Query("select * from $($table) where $($ColumnName) = $($NewValueForID)");
        return $this.results; # display
    }

    [System.Object[]]Select()
    {
        $querystring = $null;

        [system.object[]]$tablestochoosefrom = $this.Query('select table_name from Information_schema.tables');

        Write-Host "`nWhich Table are you selecting from?" -ForegroundColor Red -BackgroundColor Yellow;
        $i = 1;
        foreach ($t in $tablestochoosefrom){Write-host "$($i) - $($t.ItemArray)";$i++;} 
        $index = Read-Host -Prompt "So?";

        $table = $tablestochoosefrom[$index - 1].ItemArray;

        $values = $this.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($table)'");
        $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value, WantToSee); # add another column

        # Prompt user what values they want to insert per column
        foreach($val in $values)
        {
            Write-Warning "Do you want to see $($val.COLUMN_NAME)";
            $val.WantToSee = Read-Host -Prompt "(y/n)?";
            $val.Value = $val.COLUMN_NAME;
        }

        $this.QueryConstructor("Select", [ref]$querystring, $table, $values);

        Write-Host "Query: $($querystring)"

        try{$this.Query($querystring);}
        catch
        {
            Write-Warning "$($_)";
            break;
        }

        return $this.results; # display
    }

    StartServer()# Run as Admin
    {
        net start "SQL Server Agent(SQLEXPRESS)";
    }

    hidden [string]SQLConvert($val)
    {
        [string]$string = $null;
        switch($val.DATA_TYPE)
        {
            "int"{$string = "$($val.Value)";break;}
            "uniqueidentifier"{$string = "(select convert(uniqueidentifier, '$((New-Guid).ToString().ToUpper())'))";break;}
            "varchar"{$string = "'$($val.Value)'";break;}
            default{$string = "$($val.Value)";break;}
        }
        return $string;
    }

    # Creates query string dynamically
    hidden QueryConstructor($TypeQuery, [ref]$querystring, $table, $values)
    {

        switch($TypeQuery)
        {
            "Insert"
            {
                $rep = "|||";

                # Start query string
                $querystring.Value = "insert into $($table) values ($($rep)";

                # add to query string
                foreach($val in $values)
                {
                    $querystring.Value = $querystring.Value.Replace("$($rep)", ", ");
                    $querystring.Value += $this.SQLConvert($val) + "$($rep)";
                }

                $querystring.Value = $querystring.Value.Replace("$($rep)", ")");
                $querystring.Value = $querystring.Value.Replace("(,", "(");
                break;
            }
            "Select" # TODO finish
            {
                $rep = "|||";

                # Start query string
                $querystring.Value = "select ";

                # add to query string
                foreach($val in $values)
                {
                    if($val.WantToSee -eq "y")
                    {
                        $querystring.Value = $querystring.Value.Replace("$($rep)", ", ");
                        $querystring.Value += $val.COLUMN_NAME + "$($rep)";
                    }
                }

                $querystring.Value = $querystring.Value.Replace("$($rep)", "  ");
                $querystring.Value = $querystring.Value.Replace("select ,", "select ");
                $querystring.Value += " from $($table)";
                break;
            }
            default {throw "Not a valid query type."}
        }
    } 

    InputCopy([string]$value) # Decodes guid in personalinfo table
    {
        # $this.results = $null # reset
        $querystring = "select Value from [PersonalInfo] where Guid = '" + $Value + "'";
        $result = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        Set-Clipboard $result.Item("Value");
    }

    [string]InputReturn([string]$value) # Decodes guid and returns the value from personalinfo table
    {
        $querystring = "select Value from [PersonalInfo] where Guid = '" + $Value + "'";
        $result = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        return $result.Item("Value");
    }

    SyncConfig()
    {
        foreach($table in $this.tables)
        {
            if(!$this.DoesTableExist($table.Name)){$this.CreateTable($table.Name);$this.CreateColumns($table);}
            else{$this.CreateColumns($table);}
        }
    }

    hidden [boolean] DoesTableExist([string]$t)
    {
        $querystring = "select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = '$($t)'";
        $this.results = $null # reset
        $this.results = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        if($null -eq $this.results){return $false;}
        else {return $true;} 
    }

    hidden CreateColumns([system.Object[]]$table)
    {
        $querystring = "ALTER TABLE $($table.Name) ADD ";
        $rep = "|||";
        foreach($column in $table.Column)
        {   
            #column_b VARCHAR(20) NULL, column_c INT NULL ;";
            $querystring = $querystring + "$($column.Name) $($column.Type) $($this.IsNull) $($rep)";
        }
    }
    # TODO make isnull, createtable, and finish createcolumns methods
}