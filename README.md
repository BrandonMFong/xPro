# xPro

This repository allows an .XML file to be your shell Profile (i.e. PROFILE.ps1 or .zshrc), allowing adaptability of the profile on different machines. 

## Applications
- If you are like me and like using the terminal more than Window's File Explorer, using xPro enhances the terminal flow with quick cd (Set-Location) to directories configured under \<Directories\>
- Putting private information in your PROFILE.ps1 may not be ideal.  xPro connects to local SQL Server and with a GUID you can reference your password or email at Profile LOAD and store it in a HashTable configured under \<Objects\>
- OpenSSH integration

## Setup

### Powershell

- Run Setup.ps1

### Z shell

- Run Setup.zsh

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
        * ![git diagram](https://github.com/BrandonMFong/xPro/blob/dev/docs/simplegitdiagram.png)
    * Branch Name
        {VersionType}-{BranchToMergeBackInto}-{DescriptionOfBranch}
        
## Authors

**Brandon Fong** - [Github](https://github.com/BrandonMFong)
