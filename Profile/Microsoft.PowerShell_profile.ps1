# Engineer: Brandon Fong
# TODO
# ...

	<### MODULES ###>
		using module B:\Powershell\class_CALENDAR.psm1;
		using module B:\Powershell\class_MATH.psm1;
		using module B:\Powershell\class_SQL.psm1;
		using module B:\Powershell\class_WEB.psm1;
		using module B:\Powershell\class_Windows.psm1;
		using module B:\Powershell\function_JUMP.psm1;

	<### START ###>
		
	Write-Host("`n")
	# TODO How to dynamically connect your powershell repo to this ps1 script

	<# END START #>
	$ConfigPath = 'B:\Powershell\Config\BRANDONMFONG.xml'
	[XML]$XMLReader = Get-Content $ConfigPath
		
	<### ALIASES ###> 
		# Program calls
		try
		{
			set-alias Vim 'C:\Program Files (x86)\vim\vim80\vim.exe' 
			set-alias Vs 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe' 
			set-alias Chrome 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' 
			set-alias Matlab 'C:\Program Files\MATLAB\R2019a\bin\matlab.exe' 
			set-alias Word 'C:\Users\bfwan\AppData\Local\Microsoft\WindowsApps\Microsoft.Office.Desktop_8wekyb3d8bbwe\winword.exe' 
			set-alias Outlook 'C:\Users\bfwan\AppData\Local\Microsoft\WindowsApps\Microsoft.Office.Desktop_8wekyb3d8bbwe\outlook.exe' 
			set-alias Spotify 'C:\Users\bfwan\AppData\Local\Microsoft\WindowsApps\SpotifyAB.SpotifyMusic_zpdnekdrzrea0\Spotify.exe' 
			set-alias Npad 'C:\Program Files (x86)\Notepad++\notepad++.exe' 
			set-alias QtSpim 'C:\Program Files (x86)\QtSpim\QtSpim.exe' 
			Set-Alias GitHub 'C:\Users\bfwan\AppData\Local\GitHubDesktop\GitHubDesktop.exe'                                                                    
			Set-Alias Wmplayer 'C:\Program Files (x86)\Windows Media Player\wmplayer.exe'                                                                  
			Set-Alias SDK 'C:\Xilinx.1\SDK\2018.3\bin\xsdk.bat'    
			Set-Alias Putty 'C:\Program Files\PuTTY\putty.exe' 
			Set-Alias Atmel 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Atmel Studio 7.0\Atmel Studio 7.0.lnk' 
			Set-Alias Gitbash 'C:\Program Files\Git\git-bash.exe' 
			Set-Alias 7z 'C:\Program Files\7-Zip\7z.exe' 
			Set-Alias Xampp 'C:\xampp\xampp-control.exe' 
			#Set-Alias Global 'C:\Program Files\Palo Alto Networks\GlobalProtect\GlobalProtect.lnk' 
			Set-Alias WinSCP 'C:\Program Files (x86)\WinSCP\winscp.exe' 
			Set-Alias Python 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\Python37_64\python.exe' 
			Set-Alias VC 'C:\Users\bfwan\AppData\Local\Programs\Microsoft VS Code\Code.exe' 
			Set-Alias PIP 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\Python37_64\Powershell\pip3.7.exe' 
			Set-Alias Subl 'C:\Program Files\Sublime Text 3\subl.exe' 
			Set-Alias sql 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe' 
			Set-Alias VC-Powershell 'B:\Powershell\VCODE_Powershell.code-workspace';
			Set-Alias VC-DualPowerGeneration 'B:\SOURCES\Repos\DualPowerGeneration\VCODE_DualPowerGeneration.code-workspace';
			Set-Alias VC-BrandonFongMusic 'B:\SITES\BrandonFongMusic\VCODE_BrandonFongMusic.code-workspace';
			Set-Alias X-Win 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\X-Win32 19.lnk';
			Set-Alias Xming 'C:\Program Files (x86)\Xming\Xming.exe';
			Set-Alias Modeler 'C:\Program Files\Riverbed EDU\17.5.A\sys\pc_intel_win32\bin\modeler.exe';
			 
			#Single cmdlet
			Set-Alias SO 'Sort-Object' 
		}
		catch
		{
			Write-Error($error);$error.clear();
			#throw "`nCannot create the alias";
		}

	<### FUNCTIONS ###>
		function GO-TO
		{
			Param([String[]] $dir, [Alias('p')][Switch] $push)
		
			if ($push){B:\Powershell\function_GOTO.ps1 -dir $dir -push $push;}
			else {B:\Powershell\function_GOTO.ps1 -dir $dir;}
		}
		Set-Alias goto 'GO-TO'   

		function Archive #archive old unused files that you may refer to later
		{
			Param([Alias('Z')][Switch]$Zip, [Switch]$IncludeZipFiles, [Switch]$OnlyZipFiles, [string]$FileName="Pass")
			if($Zip){B:\Powershell\function_ARCHIVE.ps1 -Zip $Zip;}
			elseif($FileName -ne "Pass"){B:\Powershell\function_ARCHIVE.ps1 -FileName $FileName;}
			else
			{
				if($IncludeZipFiles){B:\Powershell\function_ARCHIVE.ps1 -IncludeZipFiles $IncludeZipFiles;}
				elseif($OnlyZipFiles){B:\Powershell\function_ARCHIVE.ps1 -OnlyZipFiles $OnlyZipFiles;}
				else {B:\Powershell\function_ARCHIVE.ps1;}
			}
		}
		Set-Alias Arc 'Archive' 
	
		function Recycle #alternative to rm but puts the files in user created recycling bin 
		{Param($item);B:\Powershell\function_RECYCLE.ps1 -item $item;}
		Set-Alias rec 'Recycle'  
		
		function Is-Prime
		{
			Param([int]$num)
			$composite_flag = $False;
			for($i = 2; $i -lt $num; $i++)
			{
				if(($num % $i) -eq 0){$composite_flag = $True}
			}
			
			if($composite_flag){Write-Host "$i is composite"}
			else {Write-Host "$i is prime"}
		}
		
		function Clear-and-List{Clear-Host;Get-ChildItem;}
		Set-Alias cl 'Clear-and-List' 

		function Append-Date
		{
			Param([Alias('F')][Switch]$FileDate, [String]$FileName="Pass")
			if ($FileDate){B:\Powershell\function_APPEND_DATE.ps1 -FileDate $FileDate;}
			elseif ($FileName -ne "Pass"){B:\Powershell\function_APPEND_DATE.ps1 -FileName $FileName;}
			else {B:\Powershell\function_APPEND_DATE.ps1;}
		}
		Set-Alias AD 'Append-Date'

		function Setup-GitPush{B:\Powershell\function_SETUPGIT.ps1;}
		Set-Alias SG 'Setup-GitPush'

		function Modify-Modules{B:\Powershell\function_MODIFYMODULE.PS1;}

	<### OBJECTS ###>
		$i=0;
		foreach($val in $XMLReader.BrandonMFong.Objects.Object)
		{
			New-Variable -Name "$($val.VarName)" -Value $val -Force;
			$i++;
		}
	
		
		
		$Web = [Web]::new();
		$Math = [Calculations]::new();
		$Decode = [SQL]::new($Database.Database.DatabaseName, $Database.ServerInstance  , $Database.Database.Tables);
		$Windows = [Windows]::new();

	
	
	
