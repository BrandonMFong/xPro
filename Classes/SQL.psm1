# A way for me to query my local db through powershell
# TODO Maybe find a way to this for all tables in database
class SQL 
{
    # Object fields
    [string]$serverinstance;
    [string]$database;
    [System.Object[]]$results;
    [System.Object[]]$tables;
    hidden [System.Object[]] $ErrorMessage =
    @{
        InvokeSqlcmd = "Something went wrong with Invoke-Sqlcmd";
    }

    # Constructor
    SQL([string]$database, [string]$serverinstance, [System.Object[]] $tables)
    {
        $this.database = $database;
        $this.serverinstance = $serverinstance;
        $this.tables = $tables
    }

    # Object method

    # Standard queries
    [System.Object[]]Query([string]$querystring)
    {
        $this.results = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        return $this.results; # display
    }

    # Insert Data into BrandonMFong.PersonalInfo table
    [System.Object[]]InsertIntoPersonalInfo()
    {
        $error.Clear();
        [string]$NewGuid = Read-Host -Prompt 'Provide new guid';
        [string]$NewValue = Read-Host -Prompt 'Provide new value that ties to the guid';
        [string]$NewSubject = Read-Host -Prompt 'Provide Subject'

        # TODO insert type content id
        [System.Object[]]$TypeContentIDs = $this.Query('select * from TypeContent');
        
        foreach ($row in $TypeContentIDs)
        {
            Write-Host $row.ItemArray;
        }

        [System.String]$NewTypeContentIDString = Read-Host -Prompt "Choose ID";
        [int]$NewTypeContentIDInt = ($this.Query('select ID from ' + $this.tables.TypeContent + ' where ID = ' + $NewTypeContentIDString)).ItemArray;
        [int]$NewID = ($this.Query('select max(id)+1 from ' + $this.tables.PersonalInfo)).ItemArray;

        # https://stackoverflow.com/questions/27095829/powershell-convert-value-to-type-system32-error build strings
        [string]$querystring = "insert into $($this.tables.personalinfo.ToString()) values ( $($NewID.ToString()), "
            + "'$($NewGuid)', '$($NewValue)', '$($NewSubject)', $($NewTypeContentIDInt.ToString()))"; # this has invalid cast from string to int
       
        try 
        {
            Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        } 
        catch 
        {
            Write-Host $this.ErrorMessage.InvokeSqlcmd +"`n";
            throw($error);
        }
        Finally 
        {
            $error.clear();
        }

        $this.results = $this.Query('select * from ' + $this.tables.PersonalInfo + ' where id = ' + $NewID);
        
        Write-Host "`n New data successfully inserted";

        return $this.results;
    }

    [System.Object[]]InsertIntoTypeContent()
    {
        $error.Clear();
        # make method to insert into type content
        return $this.results;
    }

    InsertInto(<#[string]$table="null"#>)
    {
        $querystring = $null;
        $rep = "|||";
        # if($table -eq "null")
        # {
            [system.object[]]$tablestochoosefrom = $this.Query('select table_name from Information_schema.tables');
    
            Write-Host "Which Table are you inserting into?" -ForegroundColor Green;
            $i = 1;
            foreach ($t in $tablestochoosefrom){Write-host "$($i) - $($t.ItemArray)";$i++;} 
            $index = Read-Host -Prompt "So?";

            $table = $tablestochoosefrom[$index - 1].ItemArray;
        # }
        $NewIDShouldBe = $this.Query("select max(id)+1 from $($table)");

        Write-Warning "`nThe new id should be: $($NewIDShouldBe.ItemArray)`n";


        $values = $this.Query("select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$($table)'");
        $values = $($values|Select-Object COLUMN_NAME, DATA_TYPE, Value); # add another column

        foreach($val in $values)
        {
            Write-Warning "For $($val.COLUMN_NAME)";
            $val.Value = Read-Host -Prompt "Value?";
        }

        #Make query string
        $querystring = "insert into $($table) values ($($rep)";

        # add to query string
        foreach($val in $values)
        {
            $querystring = $querystring.Replace("$($rep)", ", ");
            $querystring += $this.SQLConvert($val) + "$($rep)";
        }

        $querystring = $querystring.Replace("$($rep)", ")");
        $querystring = $querystring.Replace("(,", "(");
        Write-Host "$($querystring)"
        try
        {
            # Invoke-Sqlcmd : Conversion failed when converting from a character string to uniqueidentifier.
            # At B:\Powershell\Classes\SQL.psm1:128 char:13
            # +             Invoke-Sqlcmd -Query $querystring -ServerInstance $this.s ...
            # +             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # + CategoryInfo          : InvalidOperation: (:) [Invoke-Sqlcmd], SqlPowerShellSqlExecutionException
            # + FullyQualifiedErrorId : SqlError,Microsoft.SqlServer.Management.PowerShell.GetScriptCommand
            Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        }
        catch
        {
            Write-Warning "$($_)";
            return;
        }

        Write-Host "New Data" -ForegroundColor Green;
        $ColumnName = $values[0].COLUMN_NAME;
        $NewValueForID = $values[0].Value;
        $this.Query("select * from $($table) where $($ColumnName) = $($NewValueForID)");
    }

    [string]SQLConvert($val)
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

    InputCopy([string]$value) # Decodes guid 
    {
        $querystring = "select Value from [PersonalInfo] where Guid = '" + $Value + "'";
        $result = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        Set-Clipboard $result.Item("Value");
    }

    [string]InputReturn([string]$value) # Decodes guid and returns the value
    {
        $querystring = "select Value from [PersonalInfo] where Guid = '" + $Value + "'";
        $result = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        return $result.Item("Value");
    }
}