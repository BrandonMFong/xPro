# GlobalScripts

Have everything on the command line

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
    [@date - @user] @currdir> 

    [03/28/2020 - BrandonMFong] Powershell>
    ```
* **Weather Report**
    ```
    Sample Configuration
    <Weather>
        <Area>San Diego</Area>
    </Weather>

    [03/28/2020 - BrandonMFong] Powershell> get-weather -RightNow  
    Weather report: Spring Valley, United States

     \   /     Sunny
      .-.      44..46 °F
   ― (   ) ―   ↖ 3 mph
      `-’      9 mi
     /   \     0.0 in

    ```
* **Create multiple lists (i.e. To Do Lists)**
    ```
    <Lists>
        <!-- Monday -->
        <List Title="Monday To Do List">
        <Item ID="A" rank="1" name="CompE 565" Completed="true">
            <Item ID="A" rank="2" name="Study" Completed="true" />
            <Item ID="B" rank="2" name="Study" Completed="true" />
        </Item>
        <Item ID="A" rank="1" name="CompE 496B" Completed="true">
            <Item ID="A" rank="2" name="Study" Completed="true" />
            <Item ID="B" rank="2" name="Study" Completed="true" />
        </Item>
        <Item ID="A" rank="1" name="CompE 560" Completed="true">
            <Item ID="A" rank="2" name="Study" Completed="true" />
            <Item ID="B" rank="2" name="Study" Completed="true" />
        </Item>
        <Item ID="A" rank="1" name="EE 600" Completed="true">
            <Item ID="A" rank="2" name="Study" Completed="true" />
            <Item ID="B" rank="2" name="Study" Completed="true" />
        </Item>
        </List>
    </Lists>

    [09:22 PM, Saturday 04/18 - BrandonMFong] Powershell>_ $MonList.ListOut()                                                                            
    [Monday To Do List]

    1 - CompE 565
        2 - Study
        2 - Study
    1 - CompE 496B
        2 - Study
        2 - Study
    1 - CompE 560
        2 - Study
        2 - Study
    1 - EE 600
        2 - Study
        2 - Study

    ```
* **Set multiple aliases at initial start of powershell**
    *Public*
    ```
    <Program Alias="Chrome" SecurityType="public">C:\Program Files (x86)\Google\Chrome\Application\chrome.exe</Program>
    ```
    *Private*
    ```
    <Program Alias="Chrome" SecurityType="private">9b137307-5bf9-4344-9d61-2aef23bba9fa</Program>
    ```
* **Quickly hop over to a directory using *goto* function**

### Prerequisites

* [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7) - Powershell Version 5
* [SQL](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) - SQL Server
    * *Must have two tables defined (PersonalInfo & TypeContent)*
* [Posh-Git](https://github.com/dahlbyk/posh-git) - Git for Powershell

## Structure

*Following is a discription of the repository's folder's purposes*

* bin: Log files and other misc files
* Classes: Class Definitions
* Config: User configuration 
* Functions: Powershell Scripts
* Modules: Essential functions for core scripts 
* Schema: Schema for XML files
* SQLQueries: Example queries for required database tables
* StartScripts: User scripts at profile load

## Developed With

* [Visual Studio Code](https://code.visualstudio.com/)

## Versioning

MAJOR.MINOR.PATCH

## Authors

**Brandon Fong** - [Github](https://github.com/BrandonMFong)
