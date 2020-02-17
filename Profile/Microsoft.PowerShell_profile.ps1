# Engineer: Brandon Fong
# TODO
# ...

	<### CONFIG ###>
	Push-Location $($PROFILE |Split-Path -Parent);
		[XML]$x = Get-Content Profile.xml;
	Pop-Location;
	$ConfigFile = $x.Machine.GitRepoDir + "\Config\" + $x.Machine.ConfigFile;
	[XML]$XMLReader = Get-Content $ConfigFile;

	<### MODULES ###>
		# using module B:\Powershell\Classes\CALENDAR.psm1;
		# using module B:\Powershell\Classes\MATH.psm1;
		# using module B:\Powershell\Classes\SQL.psm1;
		# using module B:\Powershell\Classes\WEB.psm1;
		# using module B:\Powershell\Classes\Windows.psm1;
	<### Classes ###>
	foreach($val in $XMLReader.Machine.Classes.Class)
	{
		$ClassPath = $x.Machine.GitRepoDir + $val;
		$ClassPath
		Import-Module $ClassPath; # this does not load the classes
	}

	<### START ###>
		
		Write-Host("`n")
		# TODO How to dynamically connect your powershell repo to this ps1 script

	<# END START #>

		
	<### ALIASES ###> 
		foreach($val in $XMLReader.Machine.Aliases.Alias)
		{
			Set-Alias $val.Name "$($val.InnerXML)";
		}

	<### FUNCTIONS ###> 
		foreach($val in $XMLReader.Machine.Functions.Function)
		{
			$FunctionPath = $x.Machine.GitRepoDir + "\Functions\" + $val.InnerXML;
			Set-Alias $val.Name "$($FunctionPath)";
		}
	<### OBJECTS ###>
		$i=0;
		foreach($val in $XMLReader.Machine.Objects.Object)
		{
			New-Variable -Name "$($val.VarName)" -Value $val -Force;
			$i++;
		}
	
		
		
		$Web = [Web]::new();
		$Math = [Calculations]::new();
		$Decode = [SQL]::new($Database.Database.DatabaseName, $Database.ServerInstance  , $Database.Database.Tables);
		$Windows = [Windows]::new();

	
	
	
