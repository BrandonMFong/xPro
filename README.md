# GlobalScripts

Allows user's powershell scripts to adapt to any computer

## Features (Version 1)

*Configurable*

* **Calendar**
    * *Print Calendar month*
        * *Marks current day*
        * *Marks special day defined by config*
* **Query Local Database**
    * *Dynamically Insert into database for any table*
* **Google Search from Powershell**
    ```
    Search -Google
    Google: How to cook an egg
    ```
* **Edit Prompt**
    ```
    [@date - @user] @fulldir>
    ```
* **Create multiple lists (i.e. To Do Lists)**
* **Set multiple aliases at initial start of powershell**
* **Quickly hop over to a directory using *goto* function**

### Prerequisites

* [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7) - Powershell Version 5
* [SQL](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) - SQL Server
    * *Must have two tables defined (PersonalInfo & TypeContent)*
* [Posh-Git](https://github.com/dahlbyk/posh-git) - Git for Powershell

## Built With

* [Visual Studio Code](https://code.visualstudio.com/)

## Versioning

MAJOR.MINOR.PATCH

*Configuration changes are not tagged*

## Authors

**Brandon Fong** - [Github](https://github.com/BrandonMFong)
