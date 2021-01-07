# xPro

This repository allows an .XML file to be your shell Profile (i.e. PROFILE.ps1 or .zshrc), allowing adaptability of the profile on different machines. 

xPro provides the ease of defining aliases, functions, and objects inside an .XML file.  Using the .XML format allows easy readibility and central location for your command line needs.  xPro also allows the user to customize their terminal such as terminal title or terminal prompt.

Incorporating a SQL database to your shell profile can provide security to your sensitive information such as passwords or secure websites.  

## Setup

Currently xPro supports Powershell and z shell. 

### Powershell

- Run Setup.ps1

### Z shell and Bash shell

- Run Setup.sh

## Developed With

* [Visual Studio Code](https://code.visualstudio.com/)

### Prerequisites

* [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7)
* [z Shell](https://ohmyz.sh/)
* [SQL](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)

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
