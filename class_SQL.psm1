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

        [int]$NewID = ($this.Query('select max(id)+1 from ' + $this.tables.PersonalInfo)).ItemArray;
        [string]$querystring = "insert into $($this.tables.personalinfo.ToString()) values ( $($NewID.ToString()), '$($NewGuid)', '$($NewValue)', '$($NewSubject)')";
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

    Input([string]$value)
    {
        $querystring = "select Value from [PersonalInfo] where Guid = '" + $Value + "'";
        $result = Invoke-Sqlcmd -Query $querystring -ServerInstance $this.serverinstance -database $this.database;
        Set-Clipboard $result.Item("Value");
    }
}