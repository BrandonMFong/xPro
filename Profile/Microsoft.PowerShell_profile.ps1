# Engineer: Brandon Fong
# TODO
# ...

	<### MODULES ###>
		using module B:\Powershell\Classes\CALENDAR.psm1;
		using module B:\Powershell\Classes\MATH.psm1;
		using module B:\Powershell\Classes\SQL.psm1;
		using module B:\Powershell\Classes\WEB.psm1;
		using module B:\Powershell\Classes\Windows.psm1;

	<### START ###>
		
		Write-Host("`n")
		# TODO How to dynamically connect your powershell repo to this ps1 script

	<# END START #>

	<### CONFIG ###>
		$ConfigPath = 'B:\Powershell\Config\BRANDONMFONG.xml'
		[XML]$XMLReader = Get-Content $ConfigPath
		
	<### ALIASES ###> 
		foreach($val in $XMLReader.Machine.Aliases.Alias)
		{
			Set-Alias $val.Name "$($val.InnerXML)";
		}

	<### FUNCTIONS ###> 
		foreach($val in $XMLReader.Machine.Functions.Function)
		{
			Set-Alias $val.Name "$($val.InnerXML)";
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

	
	
	
