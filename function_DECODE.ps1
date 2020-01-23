# All my passwords and important information is replaced with guids.  This script queries my local database and returns a value that matches the guid
	Param
	(
		[Alias('V')][String]$Value
	)

        $querystring = "select Value from [PersonalInfo] where Guid = '" + $Value + "'";
        $serverinstance = 'BRANDONMFONG\SQLEXPRESS';
        $database = 'BrandonMFong';
	
        # Query 
        $result = Invoke-Sqlcmd -Query $querystring -ServerInstance $serverinstance -database $database;
        Set-Clipboard $result.Item("Value");