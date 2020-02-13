# A way for me to query my local db through powershell
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
    [System.Object[]]Insert_Into_PersonalInfo()
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

    Input([string]$value) # Decodes guid 
    {
        $querystring = "select Value from [PersonalInfo] where Guid = '" + $Value + "'";
        $result = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        Set-Clipboard $result.Item("Value");
    }
}