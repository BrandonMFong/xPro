<#
.Synopsis
	Keeps time stamps in a .csv file
.Description
	
.Parameter Login
	Creates a row with login timestamp
.Parameter Logout
	Creates a row with logout timestamp
.Parameter View
	Get-Content on timestamp.csv
.Example

.Notes
	The location of User directory is hard coded
#>
Param
(
	[Alias('In')][Switch]$Login, 
	[Alias('Out')][Switch]$Logout, 
	[Alias('V')][Switch]$View, 
	[Alias('C')][Switch]$Clear, 
	[Alias('A')][Switch]$Archive
)
Push-Location C:\Users\brandon.fong\Brandon.Fong\DOCUMENTS\User;
	if(!(Test-Path .\TimeStamp.csv)){New-Item TimeStamp.csv}
	if($Login)
		{
			$i = Get-Date 
			Add-Content C:\Users\brandon.fong\Brandon.Fong\DOCUMENTS\User\TimeStamp.csv "Login, $i"
		}
	if($Logout)
		{
			$i = Get-Date 
			Add-Content C:\Users\brandon.fong\Brandon.Fong\DOCUMENTS\User\TimeStamp.csv "LogOut, $i"
		}
	if($View)
		{
			Get-Content C:\Users\brandon.fong\Brandon.Fong\DOCUMENTS\User\TimeStamp.csv
		}
	if($Clear) # Only call this from within the script
		{
			Clear-Content C:\Users\brandon.fong\Brandon.Fong\DOCUMENTS\User\TimeStamp.csv
		}
	if($Archive)
	{
		if(!(Test-Path .\log_archive\)){mkdir .\log_archive\;}
		$date = Get-Date;
		$file = "Archive_" + $date.Month.ToString() + $date.Day.ToString() + $date.Year.ToString() + ".csv";
		New-Item $file;
		$Temp = Get-Content C:\Users\brandon.fong\Brandon.Fong\DOCUMENTS\User\TimeStamp.csv;
		Add-Content $file $Temp;
		Move-Item $file .\log_archive;
		Time -Clear; #calling itself to clear its contents
	}
Pop-Location
