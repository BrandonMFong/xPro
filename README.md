# GlobalScripts

Allows user's powershell scripts to adapt to any computer

## Features 

* **Calendar**
    * *Print Calendar month*
        * *Marks current day*
        * *Marks special day defined by config*
    ```
    Sample Configuration
    <Calendar>
        <SpecialDays>
            <SpecialDay name="EE Project Due">3/31/2020</SpecialDay>
            <SpecialDay name="Tom's Bday">3/27/2020</SpecialDay>
        </SpecialDays>
    </Calendar>

    Sample Output
    [03/28/2020 - BrandonMFong] Powershell> Get-Calendar
    March 2020
    su  mo  tu  we  th  fr  sa
    --  --  --  --  --  --  --
    1   2   3   4   5   6   7
    8   9   10  11  12  13  14
    15  16  17  18  19  20  21
    22  23  24  25  26  27^ 28*
    29  30  31^ 1   2   3   4
    ```
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
* **Weather Report**
    ```
    [03/28/2020 - BrandonMFong] Powershell> get-weather -RightNow  
    Weather report: Spring Valley, United States

     \   /     Sunny
      .-.      44..46 °F
   ― (   ) ―   ↖ 3 mph
      `-’      9 mi
     /   \     0.0 in

    ```
* **Create multiple lists (i.e. To Do Lists)**
* **Set multiple aliases at initial start of powershell**
* **Quickly hop over to a directory using *goto* function**

### Prerequisites

* [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7) - Powershell Version 5
* [SQL](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) - SQL Server
    * *Must have two tables defined (PersonalInfo & TypeContent)*
* [Posh-Git](https://github.com/dahlbyk/posh-git) - Git for Powershell

## Structure

*Following is a discription of the repository's folder's purposes*

* bin: Contains log files and other misc files
* Classes: Repository's Core Functions
* Config: Contains User configuration 
    * Config files describes the environement the user is on.  Essentially should have one config for every computer 
* Functions: Repository's Core Functions
* Modules: Contains essential functions for core scripts 
* Schema: Schema for xml files
* SQLQueries: Example queries for required database tables
* StartScripts: User scripts at profile load
    * Also can contain modules for personal functions

## Developed With

* [Visual Studio Code](https://code.visualstudio.com/)

## Versioning

MAJOR.MINOR.PATCH

## Authors

**Brandon Fong** - [Github](https://github.com/BrandonMFong)
