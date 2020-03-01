# A way for me to query my local db through powershell

class SQL 
{
    # Object fields
    [string]$serverinstance;
    [string]$database;
    [System.Object[]]$results;
    [System.Object[]]$tables;

    # Constructor
    SQL([string]$database, [string]$serverinstance, [System.Object[]] $tables)
    {
        $this.database = $database;
        $this.serverinstance = $serverinstance;
        $this.tables = $tables
    }

    # Standard queries
    [System.Object[]]Query([string]$querystring)
    {
        $this.results = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        return $this.results; # display
    }

    # This function can insert into all different tables in a database
    [System.Object[]]InsertInto()
    {
        $querystring = $null;

        [system.object[]]$tablestochoosefrom = $this.Query('select table_name from Information_schema.tables');

        Write-Host "`nWhich Table are you inserting into?" -ForegroundColor Read -BackgroundColor Yellow;
        $i = 1;
        foreach ($t in $tablestochoosefrom){Write-host "$($i) - $($t.ItemArray)";$i++;} 
        $index = Read-Host -Prompt "So?";

        $table = $tablestochoosefrom[$index - 1].ItemArray;
        $NewIDShouldBe = $this.Query("select max(id)+1 from $($table)");

        Write-Warning "The new id should be: $($NewIDShouldBe.ItemArray)`n`n";


        $values = $this.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($table)'");
        $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value); # add another column

        # Prompt user what values they want to insert per column
        foreach($val in $values)
        {
            Write-Warning "For $($val.COLUMN_NAME)";
            $val.Value = Read-Host -Prompt "Value?";
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

    hidden [string]SQLConvert($val)
    {
        [string]$string = $null;
        switch($val.DATA_TYPE)
        {
            "int"{$string = "$($val.Value)";break;}
            "uniqueidentifier"{$string = "(select convert(uniqueidentifier, '$($val.Value)'))"}
            default{$string = "'$($val.Value)'";break;}
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
            default {throw "Not a valid query type."}
        }
    }

    ## These are static methods ## 

    InputCopy([string]$value) # Decodes guid in personalinfo table
    {
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
}