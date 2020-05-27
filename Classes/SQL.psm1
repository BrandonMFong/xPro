# A way for me to query my local sql server db through powershell
# Object for each database
class SQL 
{
    # Object fields
    [string]$serverinstance;
    [string]$database;
    hidden [System.Object[]]$results;
    [System.Object[]]$tables;
    hidden [Boolean]$UpdateVerbose;
    hidden [string]$SQLConvertFlags;

    # Constructor
    SQL([string]$database, [string]$serverinstance, [System.Object[]]$tables, [boolean]$SyncConfiguration, [boolean]$UpdateVerbose, [string]$SQLConvertFlags)
    {
        $this.database = $database;
        $this.serverinstance = $serverinstance;
        $this.tables = $tables
        $this.UpdateVerbose = $UpdateVerbose;
        $this.SQLConvertFlags = $SQLConvertFlags;
        if($SyncConfiguration){$this.SyncConfig();}
    }

    # Standard queries
    [System.Object[]]Query([string]$querystring)
    {
        $this.results = $null # reset
        $this.results = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        return $this.results; # display or return value
    }

    hidden [void] QueryNoReturn([string]$querystring) # TODO replace all lines with this method
    {
        Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
    }

    [system.object[]]ShowTables()
    {
        return $this.Query('select table_name from Information_schema.tables');
    }

    # This function can insert into all different tables in a database
    [System.Object[]]InsertInto()
    {
        $querystring = $null;

        [system.object[]]$tablestochoosefrom = $this.ShowTables();

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
        $values = $this.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($table)'");
        $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value); # add another column

        # Prompt user what values they want to insert per column
        foreach($val in $values)
        {
            if(!$this.IsIgnoredTypes($val)) # you do not need to provide a guid since it's already being provided
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

        $res = $this.Query("select top 1 * from $($table) order by id desc");
        if($res -ne 0){Write-Host "`nLatest Date from $($table):" -ForegroundColor Green;}
        return $res; # display
    }

    hidden [boolean] IsIgnoredTypes($val)
    {
        return (($val.DATA_TYPE -eq 'uniqueidentifier') -or ($val.DATA_TYPE -eq 'datetime') -or ($val.COLUMN_NAME -eq 'ID'));
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

    hidden [string]SQLConvert($val,$table)
    {
        [string]$string = $null;
        switch($val.DATA_TYPE)
        {
            "int"
            {
                if($this.SQLConvertFlags.Contains($val.COLUMN_NAME)){ $string = "$($this.GetMax($table))";} # if it is ID, get max id inc
                else{$string = "$($val.Value)";}
                break;
            }
            "uniqueidentifier"{$string = "(select convert(uniqueidentifier, '$((New-Guid).ToString().ToUpper())'))";break;}
            "varchar"{$string = "'$($val.Value)'";break;}
            "datetime"
            {
                if($this.SQLConvertFlags.Contains($val.COLUMN_NAME)){$string = "'$($val.Value)'"; } # for EventDate, use what is provided
                else{$string = "GETDATE()";}
                break;
            }
            default{$string = "$($val.Value)";break;}
        }
        return $string;
    }

    [string]GetGuidString()
    {
        $t = @{DATA_TYPE = 'uniqueidentifier'};
        return $this.SQLConvert($t,$null);
    }

    # Creates query string dynamically
    # Just for one insert value
    QueryConstructor([string]$TypeQuery, [ref]$querystring, [string]$table, [system.object[]]$values)# Table should be string type
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
                    $querystring.Value = $querystring.Value.Replace("$($rep)", ", "); # replaces with , to match syntax
                    $querystring.Value += $this.SQLConvert($val,$table) + "$($rep)";
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
        $this.UpdateLastAccessByGuid($value);  # Updates access date, good for tracking
        return $result.Item("Value");
    }

    SyncConfig()
    {
        # Update Scripts
        Push-Location $PSScriptRoot\..\SQLQueries
            [Xml]$Update = Get-Content Update.xml;
            Write-Host "`n";
            Write-Verbose "UPDATING DATABASE START" -Verbose:$this.UpdateVerbose;
            foreach($Script in $Update.Machine.ScriptBlock)
            {
                try
                {
                    $this.QueryNoReturn($Script.'#cdata-section');
                    Write-Verbose "Executing : {$($Script.'#cdata-section')}" -Verbose:$this.UpdateVerbose;
                }
                catch 
                {
                    throw "Something bad happened!";
                }
            }
            Write-Verbose "UPDATING DATABASE END" -Verbose:$this.UpdateVerbose;
            Write-Host "`n";
        Pop-Location;

        foreach($table in $this.tables.Table)
        {

            if(!$this.DoesTableExist($table.Name)){$this.CreateTable($table);}
            else{$this.CreateColumns($table);}# This internally checks if the columns do exist

            # Insert rows
            # Allows you to add rows into the table 
            # Cannot remove rows, must do that in the xml file provided under the sql directory
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
                [string]$querystring = $null;
                $values = $this.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($tablename)'"); # By now the table should be created
                $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value); # add another column, this makes sure that columns/data is in order
                # Adds the actual values to use for the insert query
                # There are also checks for other types of 
                foreach($val in $values)
                {
                    # if column in ID or a datetime, the value will be handled by SQLConvert
                    if(($val.COLUMN_NAME -ne "ID") -and ($val.DATA_TYPE -ne "datetime"))
                    {$val.Value = $this.GetInnerXMLByAttribute($Row,$val.COLUMN_NAME);}
                }
                $this.QueryConstructor("Insert",[ref]$querystring,$tablename,$values);
                $this.QueryNoReturn($querystring);
                $RowsInserted = $true;
            }
            # I update the date when the row is created
            # will put this as an else
            # I.e. if the row does exist, update the lastaccess column
            # else, leave it to the above algorithm to do the job
            else{$this.UpdateLastAccessByExternalID($this.GetExternalIDFromRowConfig($Row));}
        }
        if($RowsInserted) {Write-Host "$($tablename)'s rows are up to date!" -ForegroundColor Yellow -BackgroundColor Black;}
    }

    hidden [string] GetExternalIDFromRowConfig($row)
    {
        [string]$extid = "";
        [bool]$FoundExternalID = $false;
        foreach($Value in $row.Value)
        {
            if($Value.ColumnName -eq "ExternalID"){$extid = $Value.InnerXML;$FoundExternalID = $true;}
        }

        if(!$FoundExternalID){throw "Something bad happened.  Check config if there is an externalid column for the row."}
        return $extid;
    }

    # Runs the the config of the row and gets the innerxml if it is for the right column
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
        $querystring = "select * from $($tablename) where ExternalID = '$($this.GetExternalIDFromRowConfig($row))'";
        $res = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database -Verbose;
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
        [boolean]$TableCreated = $false;
        foreach ($column in $table.Column)
        {
            $querystring = $querystring.Replace("$($rep)", ", ");
            if(!$this.DoesColumnExist($table.Name,$column.Name))
            {
                $i++;
                $querystring += " $($column.Name) $($column.Type) $($this.IsNull($column)) $($this.IsPK($column)) $($this.IsFK($column)) $($rep) "; # TODO make a method
            }
        }
        $querystring = $querystring.Replace("$($rep)", "");
        $querystring = $querystring.Replace("(,", "");

        # else all columns are there
        if($i -gt 0){Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database -Verbose;$TableCreated = $true;}
        if($TableCreated){Write-Host "$($table.Name) is up to date!" -ForegroundColor Yellow -BackgroundColor Black;}
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
    hidden [string]IsFK($val) 
    {
        if($val.IsForeignKey -eq "true"){return "PRIMARY KEY"}
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
            $querystring += " $($column.Name) $($column.Type) $($this.IsNull($column)) $($this.IsPK($column)) $($this.IsFK($column)) $($rep) ";
        }
        $querystring = $querystring.Replace("$($rep)", ")");
        $querystring = $querystring.Replace("(,", "(");

        Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database -Verbose;
    }

    hidden [void] UpdateLastAccessByGuid([string]$Guid) # Personalinfo
    {
        [string]$querystring = "update PersonalInfo set LastAccessDate = GETDATE() where Guid = '$($Guid)'";
        $this.QueryNoReturn($querystring);
    }

    # Keeps track of the last time this externalid was referenced by the config
    # Helps auditing so I know when to remove it
    # To remove use Alter.xml (name might change [4/23/2020])
    hidden [void] UpdateLastAccessByExternalID([string]$ExternalID) # Type Content
    {
        [string]$querystring = "update TypeContent set LastAccessDate = GETDATE() where ExternalID = '$($ExternalID)'";
        $this.QueryNoReturn($querystring);
    }
}

# [XML]$xml = Get-Content $PSScriptRoot\..\Config\BRANDONMFONG.xml;
# [SQL]$query = [SQL]::new($xml.Machine.Objects.Object[0].Class.SQL.Database, $xml.Machine.Objects.Object[0].Class.SQL.ServerInstance, $xml.Machine.Objects.Object[0].Class.SQL.Tables);