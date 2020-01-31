# Engineer: Brandon Fong
# TODO
# ...

	<### CLASSES ###>
		using module B:\SCRIPTS\class_CALENDAR.psm1;
		using module B:\SCRIPTS\class_CONVERT.psm1;
		using module B:\SCRIPTS\class_SQL.psm1;
		using module B:\SCRIPTS\class_WEB.psm1;
		
	<### FUNCTIONS ###>
		using module B:\SCRIPTS\function_JUMP.psm1;
		
	<### ALIAS ###> 
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
			Set-Alias Global 'C:\Program Files\Palo Alto Networks\GlobalProtect\GlobalProtect.lnk' 
			Set-Alias WinSCP 'C:\Program Files (x86)\WinSCP\winscp.exe' 
			Set-Alias Python 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\Python37_64\python.exe' 
			Set-Alias VC 'C:\Users\bfwan\AppData\Local\Programs\Microsoft VS Code\Code.exe' 
			Set-Alias PIP 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\Python37_64\Scripts\pip3.7.exe' 
			Set-Alias Subl 'C:\Program Files\Sublime Text 3\subl.exe' 
			Set-Alias sql 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe' 
			Set-Alias VC-Powershell 'B:\SCRIPTS\VCODE_Powershell.code-workspace';
			Set-Alias VC-DualPowerGeneration 'B:\SOURCES\Repos\DualPowerGeneration\VCODE_DualPowerGeneration.code-workspace';
			Set-Alias VC-BrandonFongMusic 'B:\SITES\BrandonFongMusic\VCODE_BrandonFongMusic.code-workspace';
			Set-Alias X-Win 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\X-Win32 19.lnk';
			Set-Alias Xming 'C:\Program Files (x86)\Xming\Xming.exe';
			 
			#Single cmdlet
			Set-Alias SO 'Sort-Object' 
		}
		catch
		{
			Write-Error($error);$error.clear();
			#throw "`nCannot create the alias";
		}

	<### FUNCTIONS ###> # TODO Put all functions in module files, only the ones that you don't change often
		function GO-TO
		{
			Param([String[]] $dir, [Alias('p')][Switch] $push)
		
			if ($push){B:\SCRIPTS\function_GOTO.ps1 -dir $dir -push $push;}
			else {B:\SCRIPTS\function_GOTO.ps1 -dir $dir;}
		}
		Set-Alias goto 'GO-TO'   

		function Archive #archive old unused files that you may refer to later
		{
			Param([Alias('Z')][Switch]$Zip, [Switch]$IncludeZipFiles, [Switch]$OnlyZipFiles, [string]$FileName="Pass")
			if($Zip){B:\SCRIPTS\function_ARCHIVE.ps1 -Zip $Zip;}
			elseif($FileName -ne "Pass"){B:\SCRIPTS\function_ARCHIVE.ps1 -FileName $FileName;}
			else
			{
				if($IncludeZipFiles){B:\SCRIPTS\function_ARCHIVE.ps1 -IncludeZipFiles $IncludeZipFiles;}
				elseif($OnlyZipFiles){B:\SCRIPTS\function_ARCHIVE.ps1 -OnlyZipFiles $OnlyZipFiles;}
				else {B:\SCRIPTS\function_ARCHIVE.ps1;}
			}
		}
		Set-Alias Arc 'Archive' 
	
		function Recycle #alternative to rm but puts the files in user created recycling bin 
		{
			Param($item)
			B:\SCRIPTS\function_RECYCLE.ps1 -item $item;
		}
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
		
		function Clear-and-List
		{
			Clear-Host;Get-ChildItem;
		}
		Set-Alias cl 'Clear-and-List' 

		function Append-Date
		{
			Param([Alias('F')][Switch]$FileDate, [String]$FileName="Pass")
			if ($FileDate){B:\SCRIPTS\function_APPEND_DATE.ps1 -FileDate $FileDate;}
			elseif ($FileName -ne "Pass"){B:\SCRIPTS\function_APPEND_DATE.ps1 -FileName $FileName;}
			else {B:\SCRIPTS\function_APPEND_DATE.ps1;}
		}
		Set-Alias AD 'Append-Date'

		function Setup-GitPush
		{
			B:\SCRIPTS\function_SETUPGIT.ps1;
		}
		Set-Alias SG 'Setup-GitPush'

	<### OBJECTS ###>
		$User = 
		@{
			## Links ##
			Gmail 		= "https://mail.google.com/mail";
			Netflix		= "https://Netflix.com";
			Youtube 	= 'https://Youtube.com';
			Facebook	= "https://facebook.com";	
			LinkedIn 	= "https://www.linkedin.com/nhome/";
			Git			= "https://github.com/BrandonMFong";
			GoogleDrive	= "https://drive.google.com/drive/u/0/my-drive";
			Disney_Plus	= "https://www.disneyplus.com";
			Hulu		= "https://www.hulu.com";
			Slack		= "https://dualpowergeneration.slack.com";
			YES			= "https://dualpowergeneration.sdsu.edu";
			iCloud		= "https://www.icloud.com/";
			GoogleCloud	= "https://console.google.com";

			## Accounts ##
			Email =
			@{
				Personal = 'c4a21f9b-1376-41db-a7a6-4bbaf09e1dd8';
				Professional = '94edc712-0435-4574-80ad-fbb1aab3dc20';
				Music = '2508beb5-3958-48d5-931b-c7b55efa7c92';
				Work = '340861de-d4f9-43a3-badd-d0945e3e392a';
				Old = '21a540d4-4818-404a-8db5-c78443fa1ad1';
				Password = 
				@{
					Professional = '9fd118e5-c785-4b9b-a687-b06c65285e67';
				}
			}
			
			## Some Credentials ##
			cPanel =
			@{
				URL 		= 'https://rohancp.sdsu.edu:2083/cpanel';
				Username 	= 'dualpower';
				Password 	= '960f933f-937f-409e-a9fa-f00d97586fcd';
				SSH_PW 		= '266d3c1e-de41-475b-b169-bdd5d2518440';
			}
			
			Hostinger =
			@{
				URL 		= 'https://www.hostinger.com/cpanel-login';
				Database	= 'https://auth-db221.hostinger.com/';
				SSH_UserName = '05318085-dcfe-485b-9505-b9b1d662bbb9';
				Password 	= '266d3c1e-de41-475b-b169-bdd5d2518440';
			}

			Chase =
			@{
				Username 	= 'd391a359-7973-4592-a6b2-21f568fe966c';
				URL 		= 'https://www.chase.com/';
				Password 	= '9fd118e5-c785-4b9b-a687-b06c65285e67';
			}

			Jason =
			@{
				Username = 'cde45e8a-0092-42b7-8ba9-1c5bee095b76';
				URL = '';
				Password = 'd0a14271-0d83-42f9-98f1-5a90f4c3816a';
			}

			CalApply = 
			@{
				Username = '1853a79c-4a36-437e-a36c-6ec69789d926';
				URL = 'https://www2.calstate.edu/apply';
				Password = '266d3c1e-de41-475b-b169-bdd5d2518440';
			}

			## Local DBs ##
			LocalDB = 
			@{
				serverinstance = 'BRANDONMFONG\SQLEXPRESS';
				database = 
				@{
					BrandonMFong =
					@{
						Name = 'BrandonMFong';
						Tables =
						@{
							PersonalInfo = 'PersonalInfo';
						}
					}
				}
			}

			Passwords 	=
			@{
				Default			= '266d3c1e-de41-475b-b169-bdd5d2518440';
				cPanel 			= '960f933f-937f-409e-a9fa-f00d97586fcd';
				Facebook 		= '266d3c1e-de41-475b-b169-bdd5d2518440';
				Youtube 		= '266d3c1e-de41-475b-b169-bdd5d2518440';
				GitHub  		= '266d3c1e-de41-475b-b169-bdd5d2518440';
				Chase			= '9fd118e5-c785-4b9b-a687-b06c65285e67';
				Netflix 		= 'c8fc577a-d54b-490b-8e0c-3b59cd056f9b';
				Hulu 	 		= 'c8fc577a-d54b-490b-8e0c-3b59cd056f9b';
				Disney_Plus 	= 'c8fc577a-d54b-490b-8e0c-3b59cd056f9b';
				Amazon_shop		= '0ce5d07c-ecfb-4fea-ab4c-544d4c97225d';
				Blackboard		= '9517939f-b925-4a5d-8a95-8f101b6d63af';
				LinkedIn		= '266d3c1e-de41-475b-b169-bdd5d2518440';
				Alliant			= '4f1c0b1f-53d4-40f4-972e-6202accecd43';
				Indeed  		= '266d3c1e-de41-475b-b169-bdd5d2518440';
				Amazon_jobs		= '266d3c1e-de41-475b-b169-bdd5d2518440';
				Global_protect	= '9517939f-b925-4a5d-8a95-8f101b6d63af';
				WebPortal 		= '9517939f-b925-4a5d-8a95-8f101b6d63af';
				Microsoft 		= '9517939f-b925-4a5d-8a95-8f101b6d63af';
				iCloud 			= '266d3c1e-de41-475b-b169-bdd5d2518440';
				SBMI 			= '266d3c1e-de41-475b-b169-bdd5d2518440';
				sunrun 			= '6b9d4ccb-c510-4ca7-939f-1ff069ffe90d';
				UCSD_Health	 	= '266d3c1e-de41-475b-b169-bdd5d2518440';
				ubuntu		 	= '266d3c1e-de41-475b-b169-bdd5d2518440';
				ProfEmail		= '266d3c1e-de41-475b-b169-bdd5d2518440';
				Verint			= 'ca16b2ba-f675-4257-a84f-2107311b43a9';
				Jason			= 'd0a14271-0d83-42f9-98f1-5a90f4c3816a';
				CalApply		= '266d3c1e-de41-475b-b169-bdd5d2518440';
			}

			# Drives
			SDSU_Drive 	= "a2d8af69-54d0-4e33-9a22-bda55c2bf9ca";
			
			# Directories
			this 	= 'B:\';
			ONE = '~\OneDrive'
			CODE =
			@{
				this = 'B:\CODE';
			}
			COLLEGE = 
			@{
				this		= 'B:\COLLEGE';
				Blackboard	= "https://Blackboard.sdsu.edu";
				WebPortal 	= 'https://sunspot.sdsu.edu/AuthenticationService/loginVerifier.html?pc=portal';
				
				_19_20 =
				@{
					this = 'B:\COLLEGE\19_20';
					Fall_19 = 
					@{
						this = 'B:\COLLEGE\19_20\Fall_19';
						CompE_361 =
						@{
							this = 'B:\COLLEGE\19_20\Fall_19\CompE_361';
						}
						Compe_475 = 
						@{
							this = 'B:\COLLEGE\19_20\Fall_19\Compe_475';
						}
						CompE_496A = 
						@{
							this = 'B:\COLLEGE\19_20\Fall_19\CompE_496A';
							Git		= 'https://github.com/BrandonMFong/DualPowerGeneration';
						}
						EE_420 =
						@{
							this = 'B:\COLLEGE\19_20\Fall_19\EE_420';
						}
						EE_450 =
						@{
							this = 'B:\COLLEGE\19_20\Fall_19\EE_450';
						}
						
					}
					Spring_20 = 
					@{
						# TODO figure out new class
						this = 'B:\COLLEGE\19_20\Spring_20';
						CompE_565 =
						@{
							this = 'B:\COLLEGE\19_20\Spring_20\CompE_565';
						}
						EE_600 =
						@{
							this = 'B:\COLLEGE\19_20\Spring_20\EE_600';
						}
						CompE_560 =
						@{
							this = 'B:\COLLEGE\19_20\Spring_20\CompE_560';
						}
						CompE_496B =
						@{
							this = 'B:\COLLEGE\19_20\Spring_20\CompE_496B';
						}
						Class =
						@{
							this = 'B:\COLLEGE\19_20\Spring_20\New_Dir';
						}
					}
				}
			}
			JOB = 
			@{
				LinkedIn_Profile = 'https://www.linkedin.com/in/brandonmfong/';
				GitHub_Profile = 'https://github.com/BrandonMFong';
				this = 'B:\JOB';
			}
			LIFE =
			@{
				House_Portal	= 'http://www.sbmigroup.com';
				Water_Bill		= 'https://customerportal.sandiego.gov/portal/';
				UCSD_Health		= 'https://ucsdhealth.samaritan.com/custom/527/#/volunteer_login';
				this = 'B:\LIFE';
			}
			MUSIC = 
			@{
				this = 'B:\MUSIC';
			}
			PERSONAL =
			@{
				this = 'B:\PERSONAL';
			}
			PICTURES =
			@{
				this = 'B:\PICTURES';
			}
			RECYCLE = 
			@{
				this = 'B:\RECYCLE';
			}
			SCRIPTS =
			@{
				this = 'B:\SCRIPTS';
			}
			SITES =
			@{
				this = 'B:\SITES';
				BrandonFongMusic = 
				@{
					Git = "https://github.com/BrandonMFong/BrandonFongMusic";
					URL = 'https://BrandonFongMusic.com/';
					this = 'B:\SITES\BrandonFongMusic';
				}
			}
			SOURCES = 
			@{
				this = 'B:\SOURCES';
				Repo =
				@{
					this = "B:\SOURCES\Repos";
					YES = "B:\SOURCES\Repos\DualPowerGeneration";
				}
			}
			DOWNLOADS = 
			@{
				this = 'B:\DOWNLOADS';
			}
			DOCUMENTS = 
			@{
				this = 'B:\DOCUMENTS';
			}
		}
		$Web = [Web]::new();
		$Convert = [Convert]::new();
		$Decode = [SQL]::new($user.LocalDB.database.BrandonMFong.Name, $user.LocalDB.serverinstance, $user.LocalDB.database.BrandonMFong.Tables);
		$DB_BF = [SQL]::new($user.LocalDB.database.BrandonMFong.Name, $user.LocalDB.serverinstance, $user.LocalDB.database.BrandonMFong.Tables);

	<### START ###>
		
		Write-Host("`n")

	<# END START #>
	
	
