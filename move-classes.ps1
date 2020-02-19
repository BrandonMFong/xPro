# This copies the git repo to xampp to run the php scripts
# Assumptions:
#   - There is an alias Chrome -> C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
#   - xampp exists on machine 
#   - running in powershell
#   - scripts is in the base folder of your repo (should be)

############################## I M P O R T A N T ############################################

### VARIABLES ###
try 
{
    # Where you are copying to
    $destination_parent_dir = $($profile | Split-Path -Parent | Split-Path -Parent);
    $destination_dir = $($profile | Split-Path -Parent ); 
    $PSScriptRoot| Split-Path -Parent | Split-Path -Leaf | ForEach-Object{ $repo_name = $_};# the directory you are debugging
    $PSScriptRoot| Split-Path -Parent | Split-Path -Parent | ForEach-Object{ $base_dir = $_ + '\'}; # file path before the public_html directory
    $replace = $base_dir -replace '\\', '\\'; # file path before the public_html directory
    $PSScriptRoot| Split-Path -Parent | ForEach-Object{ $git_repo_dir = $_ + '\'}; # entire path to public_html
    $site_in_destination_folder = $destination_dir + $repo_name; # This is where the current public_html is at in the htdocs
    $log = $git_repo_dir + "logs\"; # making log dir
    $logfile = $log + "debug.log"; # debug log, TODO add some content
    $local_flag = $log + ".is_local"; # flag to tell site that we are doing some things locally
    if (!(Test-Path $log)){mkdir $log;}
    if (!(Test-Path $logfile)){New-Item $logfile;} # Creates a log file, might not use
    if (!(Test-Path $local_flag)){New-Item $local_flag;} # Creates a local flag to tell php we are running locally.  IE never run this on the server. This script is only for local testing
}
catch
{
    Write-Warning $_;
    Write-Warning "Variables in setup-env.ps1";
    Write-Host "`n Exiting program...";
    exit;
}
############################## I M P O R T A N T ############################################

Write-Warning "It's going to ask if you want to overwrite the current: "; $site_in_destination_folder;
Write-Warning "Just say yes to all of if you are okay with it.";

Push-Location $PSScriptRoot; 

    if(!(Test-Path $destination_parent_dir))
    {
        Write-Warning "Xampp is not downloaded on this machine or it is located somewhere different.";
        Write-Host "Making directory but need the program to run local website.";
        Write-Host "Download link: https://www.apachefriends.org/download.html";
        try{write-host "Opening download link..."; chrome "https://www.apachefriends.org/download.html";}
        catch{Write-Host "Could not open link."; Write-Host $_;}
        mkdir $destination_parent_dir;
        mkdir $destination_dir;
        Write-Host "Successfully made " $destination_dir " & " $destination_parent_dir;
    }
    # Removes files
    if(Test-Path $site_in_destination_folder)
    {
        Write-Host "`n`nThere are files here, going to clear out directory...";
        Write-Warning "Deleting folder:";
        Write-Host $site_in_destination_folder;
        try 
        {
            Remove-Item $site_in_destination_folder -Force -Confirm; # Just say "Yes to All"
        }
        catch 
        {
            Write-Warning "Something bad happened";
            Write-Error $_;
            Write-Warning "Exiting program...";   
            exit;
        }
        Write-Host "Deletion successful";
    }

    # Copies files
    Push-Location $base_dir;
        # This command showed me that I needed this script
        #Copy-Item .\BrandonFongMusic\* $dir; 

        # Gets all the directory names in the repo
        $directory = [System.Collections.ArrayList]::new(); 
        $base_directory = [System.Collections.ArrayList]::new(); 
        
        # recurse through the repo
        # filters only directory type
        # adds directory path to an arraylist
        Get-ChildItem $git_repo_dir -r | 
            Where-Object{$_.Attributes -eq "Directory"}|
                ForEach-Object{$directory.Add($_.fullName)};
        
        # This get's the trailing directoory name of the file path
        # Using this to compare for the copy function
        Get-ChildItem $git_repo_dir -r | 
            Where-Object{$_.Attributes -eq "Directory"} | 
                ForEach-Object{$base_directory.Add($_.BaseName)}
                
        $directory.Add($git_repo_dir);
        $base_directory.Add($repo_name);
        
        Write-Host "Obtained all directories in git repo " $git_repo_dir;

        Write-Host "Stripping file paths...";
        
        $new_directory = [System.Collections.ArrayList]::new(); 
        for($j = 0; $j -lt $directory.Count; $j++)
        {
            $new_directory.Add($directory[$j] -replace $replace); # takes all items in the array list, replaces b:\site with nothing and adds it into new array list
            Write-Host $directory[$j] " --> " $new_directory[$j]; 
        }

        Write-Host "Appending " $destination_dir " and making directory";
        
        $destination = [System.Collections.ArrayList]::new(); 
        for($j = 0; $j -lt $new_directory.Count; $j++)
        {
            $destination.Add($destination_dir.ToString() + $new_directory[$j].ToString());
            Write-Host $new_directory[$j] " --> " $destination[$j];
            try # in the case if the directory already exists
            {
                if(!(Test-Path $destination[$j])){mkdir $destination[$j]; Write-Host "Made directory.";}
                else{Write-Host "Directory already exists.";}
            }
            catch
            {
                Write-Host "Something went wrong";
                Write-Error $_;
                Write-Host "Exiting program...";
                exit;
            }
        }
        Write-Host "Appending and making directory successful";

        Write-Host "`nLooking for Files";

        $files = [System.Collections.ArrayList]::new();
        $files_base_dir = [System.Collections.ArrayList]::new();

        # Gets files full path
        Get-ChildItem $git_repo_dir -r |Where-Object{$_.Attributes -eq "Archive"}|ForEach-Object{$files.Add($_.FullName)};
        
        # Gets the trailing component of the file path to the directories
        # Going to use this to compare
        Get-ChildItem $git_repo_dir -r | Where-Object{$_.Attributes -eq "Archive"} | ForEach-Object{ $_.Directory}|ForEach-Object{$files_base_dir.Add($_.BaseName)}
        
        Write-Host "Found " $files.Count " files in " $git_repo_dir;

        Write-Host "Start copies...";
        for($k = 0; $k -lt $files.Count; $k++)
        {
            for($d = 0; $d -lt $directory.Count; $d++)
            {
                # if the folder in your current directory matches the folder for xampp/htdocs
                # copy all the files in the that directory to the directory iin xampp/htdocs
                if($files_base_dir[$k] -eq $base_directory[$d]) 
                {
                    Copy-Item $files[$k] $destination[$d];
                    Write-Host "Copied" $files[$k] " to " $destination[$d];
                }
                Write-Progress -Activity 'Copying Files' -Status 'Progress:' -PercentComplete $d; 
            }
        }

        Write-Progress -Activity 'Success.  Finishing final steps.';
        Write-Host "`nSuccessfully copied files`n";
        
        Write-Host "Copied Items from " $repo_name " to " $destination_dir;
        Write-Host "`nOpening browser @ localhost in 3 seconds...";
        Start-Sleep -s 3;

        # Start Site
        try 
        {
            #xampp; # Openning xampp to start the localhost server
            chrome "localhost"; # Opening chrome to see the site
        }
        catch
        {
            Write-Host "Something went wrong.";
            Write-Host "Alias probably doesn't exist";
            Write-Error $_;
            Write-Host "Exiting program.";
            exit;
        }
    Pop-Location;
Pop-Location;
