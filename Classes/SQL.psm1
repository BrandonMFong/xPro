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
        if($null -eq $this.results){Write-Warning "Nothing returned from query string"; return 0;}
        else {return $this.results;} # display
    }

    hidden [void] QueryNoReturn([string]$querystring) # TODO replace all lines with this method
    {
        Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
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
        $NewIDShouldBe = $this.Query("select max(id)+1 from $($table)");# issue here, what if the table is empty? if count, what if order is wrong

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
    
    [int]GetMax([string]$Table)
    {
        return ($this.Query("select isnull(max(id)+1, 1) as Max from $($Table)")).Max;
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

    [string]GetGuidString()
    {
        $t = @{DATA_TYPE = 'uniqueidentifier'};
        return $this.SQLConvert($t);
    }

    # Creates query string dynamically
    # Just for one insert value
    hidden QueryConstructor($TypeQuery, [ref]$querystring, $table, $values)# Table should be string type
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
        foreach($table in $this.tables.Table)
        {
            if(!$this.DoesTableExist($table.Name)){$this.CreateTable($table);}
            else{$this.CreateColumns($table);}# This internally checks if the columns do exist

            # Insert rows
            $this.InsertRows($table,$table.Name);
        }
    }

    # Reads config for rows config and creates multiple insert queries for each row config
    hidden [void] InsertRows($table,[string]$tablename) 
    {
        [boolean]$RowsInserted = $false;
        foreach($Row in $table.Rows.Row)
        {
            if(!$this.DoesRowExist($Row,$tablename)) # if row does not exist then insert the row
            {
                [string]$querystring = "";
                [int]$ID = $this.GetMax($tablename); # Checks db for new id inc
                $values = $this.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($tablename)'"); # By now the table should be created
                $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value); # add another column
                foreach($val in $values)
                {
                    if($val.COLUMN_NAME -eq "ID"){$val.Value = $ID;}
                    else{$val.Value = $this.GetInnerXMLByAttribute($Row,$val.COLUMN_NAME);}
                }
                $this.QueryConstructor("Insert",[ref]$querystring,$tablename,$values);
                $this.QueryNoReturn($querystring);
                $RowsInserted = $true;
            }
        }
        if($RowsInserted) {Write-Host "Rows are up to date!" -ForegroundColor Yellow -BackgroundColor Black;}
    }

    hidden [string] GetInnerXMLByAttribute($Row,[string]$Attribute)
    {
        [string]$res = "";[boolean]$found = $false;
        foreach($Value in $Row.Value)
        {
            if($Value.ColumnName -eq $Attribute){$res = $Value.InnerXML;$found = $true;break;}
        }
        if(!$found){Throw "Something bad happened";}
        else{return $res;}
    }

    hidden [boolean] DoesRowExist($row,[string]$tablename) # Must have external ID
    {
        $res = $null # reset
        foreach($Value in $row.Value)
        {
            if($Value.ColumnName -eq "ExternalID")
            {
                $querystring = "select * from $($tablename) where ExternalID = '$($Value.InnerXML)'";
                $res = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database -Verbose;
            }
        }
        if($null -eq $res){return $false;}
        else {return $true;} 
    }

    hidden [boolean] DoesTableExist([string]$t)
    {
        $querystring = "select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = '$($t)'";
        $res = $null # reset
        $res = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database -Verbose;
        if($null -eq $res){return $false;}
        else {return $true;} 
    }

    hidden CreateColumns([system.Object[]]$table)
    {
        $i = 0;
        $rep = "|||";
        $querystring = "ALTER TABLE $($table.Name) ADD ($($rep) "; # Using ( to find this part of the string
        foreach ($column in $table.Column)
        {
            $querystring = $querystring.Replace("$($rep)", ", ");
            if(!$this.DoesColumnExist($table.Name,$column.Name))
            {
                $i++;
                $querystring += " $($column.Name) $($column.Type) $($this.IsNull($column)) $($this.IsPK($column)) $($rep) ";
            }
        }
        $querystring = $querystring.Replace("$($rep)", "");
        $querystring = $querystring.Replace("(,", "");

        # else all columns are there
        if($i -gt 0){Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database -Verbose;}
        else {Write-Host "Table is up to date!" -ForegroundColor Yellow -BackgroundColor Black;}
    }

    hidden [boolean] DoesColumnExist([string]$tablename,[string]$columnname)
    {
        $querystring = "select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($tablename)' and COLUMN_NAME = '$($columnname)' ";
        $res = $null;
        $res = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database -Verbose;
        if($null -eq $res){return $false;}
        else {return $true;} 
    }

    hidden [string]IsNull($val)
    {
        if($val.IsNull -eq "true"){return "NULL"}
        else {return "NOT NULL"}
    }

    hidden [string]IsPK($val) 
    {
        if($val.IsPrimaryKey -eq "true"){return "PRIMARY KEY"}
        else {return ""}
    }

    # Creates table and columns
    hidden [void] CreateTable([system.Object[]]$table)
    {
        $rep = "|||";
        $querystring = "CREATE TABLE $($table.Name) ($($rep) "
        foreach ($column in $table.Column)
        {
            $querystring = $querystring.Replace("$($rep)", ", ");
            $querystring += " $($column.Name) $($column.Type) $($this.IsNull($column)) $($this.IsPK($column)) $($rep) ";
        }
        $querystring = $querystring.Replace("$($rep)", ")");
        $querystring = $querystring.Replace("(,", "(");

        Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database -Verbose;
    }
}