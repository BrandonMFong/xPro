# xPro

This repository allows an .XML file to be the Microsoft Powershell Profile (i.e. PROFILE.ps1), allowing adaptability of the profile on different machines. Using xPro, you are opening up your entire Powershell experience to this repository.

## Applications
- If you are like me and like using the terminal more than Window's File Explorer, using xPro enhances the terminal flow with quick cd (Set-Location) to directories configured under \<Directories\>
- Putting private information in your PROFILE.ps1 may not be ideal.  xPro connects to local SQL Server and with a GUID you can reference your password or email at Profile LOAD and store it in a HashTable configured under \<Objects\>
- OpenSSH integration

## Before xPro
![Before](https://github.com/BrandonMFong/xPro/blob/release-dev-Version4/docs/B4xPro.PNG)

## After xPro
![After](https://github.com/BrandonMFong/xPro/blob/release-dev-Version4/docs/AfterxPro.PNG)

## Developed With

* [Visual Studio Code](https://code.visualstudio.com/)

### Prerequisites

* [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7) - Powershell Version 5
* [SQL](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) - SQL Server

## Versioning

* MAJOR.MINOR.PATCH
    * Version Types
        * MAJOR: upgrade
        * MINOR: update, feature
        * PATCH: bug, patch
    * Merge workflow
        * ![git diagram](https://github.com/BrandonMFong/xPro/blob/release-dev-Version4/docs/simplegitdiagram.png)
    * Branch Name
        {VersionType}-{BranchToMergeBackInto}-{DescriptionOfBranch}

## Versions

* Version 4 
    - Allow other repositories to use git auto tagging
        - Tag is independent from rest of xPro
    - Better Documentation
    - Log Network failures
    - Improve definition performance
    - BUGS/PATCHES:
        - Start-Admin Saves directory
        - Set-Location sets to ~ if ShellSettings config isn't configured
        - Adding Config file name to config file name

* Version 3
    - Network Capabilities
        - SSH
        - Network Drives
        - Wifi
    - Search URLs Configurable
    - Test scripts   
    - Cache
        - Git repository information for terminal prompt and header
        - Greetings http retrieval 
        - Calendar calculcations
        - Terminal sessions
    - Generation of iTunes playlist xml
    - Logging
        
## Authors

**Brandon Fong** - [Github](https://github.com/BrandonMFong)
