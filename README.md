# GlobalScripts

GlobalScripts utilizes the Microsoft.PowerShell_profile.ps1 to create a virtual environment defined by an .xml file.  Rather than having your aliases, modules, hashtables, variables, etc. defined in the profile script you can have it defined in the .xml file.  The .xml file serves as a configuration point, allowing the user to use the same scripts on different computers.

## Features 

* **Calendar**
    * *Print Calendar month*
        * *Marks current day*
        * *Marks event defined by config or import file (must have a SQL Server Database)*
    ```
    Sample Configuration:
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

    OR

    Sample Import File Content:
        ExternalID,Subject,EventDate,IsAnnual
        06212020,Run,6/21/2020,0
        05302020,Get Groceries,5/30/2020,0
        06032020,Meet with Prof. Ken,6/3/2020,0

    Sample Output
    [Kiran Analytics] Powershell (master*) >_ Get-Calendar                                                                                      

    June 2020
    su  mo  tu  we  th  fr  sa
    --  --  --  --  --  --  --
    31  1   2*  3^  4   5   6
    7   8   9   10  11  12  13
    14  15  16  17  18  19  20
    21^ 22  23  24  25  26  27
    28  29  30  1   2   3   4
    ```

* **Query Local Database**
    * *Dynamically Insert into database for any table*
    ```
    [Kiran Analytics] Powershell (master*) >_ $Query.Query('select * from updatelog')                                                           

    ID            : 1
    TypeContentID : 18
    Topic         : Extend varchar data type length
    ScriptID      : 35ca7191-384e-449d-b722-5afa3d4c0bef
    DateExecuted  : 5/29/2020 3:01:55 PM

    ID            : 2
    TypeContentID : 18
    Topic         : Put EventDate to Not Null
    ScriptID      : f33dea5e-636d-421e-ba8f-e0b6e705853b
    DateExecuted  : 5/29/2020 3:01:55 PM

    ID            : 3
    TypeContentID : 18
    Topic         : Dropping StartTime and EndTime
    ScriptID      : 3f2e643b-fb08-48ed-b8fc-85e02335b94e
    DateExecuted  : 5/29/2020 3:01:55 PM

    ID            : 4
    TypeContentID : 18
    Topic         : Delete TimeStamp from TypeContent
    ScriptID      : beaca3bd-a9ae-4428-b50f-1c48146293c8
    DateExecuted  : 5/29/2020 3:01:55 PM

    ID            : 5
    TypeContentID : 18
    Topic         : Delete Toke, MobileNumber, and HomeAddress from TypeContent
    ScriptID      : 095d5f9e-4733-49f1-bf07-90dc28cb8a8b
    DateExecuted  : 5/29/2020 3:01:55 PM

    ID            : 6
    TypeContentID : 18
    Topic         : Put value for new TypeContent column (StartDate)
    ScriptID      : f752aa07-3ac3-43e8-a4ee-6033c380b595
    DateExecuted  : 6/1/2020 8:19:25 AM
    ```

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
    <!-- $MonList -->
    <Object Type="PowerShellClass">
      <VarName SecType="public">MonList</VarName>
      <Class ClassName="List" HasParams="true">
        <List>
          <Title>Monday To Do List</Title>
          <Redirect>B:\Powershell\Config\List\List.xml</Redirect>
        </List>
      </Class>
    </Object>
    
    <Lists>
        <List Title="Monday To Do List">
        <Item ID="A" rank="1" name="CompE 565" Completed="false">
            <Item ID="A" rank="2" name="Study" Completed="false" />
            <Item ID="B" rank="2" name="Study" Completed="false" />
        </Item>
        <Item ID="B" rank="1" name="CompE 496B" Completed="false">
            <Item ID="A" rank="2" name="Study" Completed="false" />
            <Item ID="B" rank="2" name="Study" Completed="false" />
        </Item>
        <Item ID="C" rank="1" name="CompE 560" Completed="false">
            <Item ID="A" rank="2" name="Study for Workshop" Completed="false" />
            <Item ID="B" rank="2" name="Study for Workshop" Completed="false" />
        </Item>
        <Item ID="D" rank="1" name="EE 600" Completed="false">
            <Item ID="A" rank="2" name="Study" Completed="True" />
            <Item ID="B" rank="2" name="Study" Completed="false" />
        </Item>
        </List>
    </Lists>

    [09:22 PM, Saturday 04/18 - BrandonMFong] Powershell>_ $MonList.ListOut()                                                                            

    [Monday To Do List]

        [O]A - CompE 565
            [O]A - Study
            [O]B - Study
        [O]B - CompE 496B
            [O]A - Study
            [O]B - Study
        [O]C - CompE 560
            [O]A - Study for Workshop
            [O]B - Study for Workshop
        [O]D - EE 600
            [X]A - Study
            [O]B - Study
    ```

* **Set multiple aliases at initial start of powershell**
    *Public*
    ```
    <Program Alias="Chrome" SecType="public">C:\Program Files (x86)\Google\Chrome\Application\chrome.exe</Program>
    ```
    *Private*
    ```
    <Program Alias="Chrome" SecType="private">9b137307-5bf9-4344-9d61-2aef23bba9fa</Program>
    ```

* **Set Volume**
    User can set the volume level on the Command line
    ```
    [12:57 PM, Sunday 04/19 - BrandonMFong] Powershell>_ Volume 68 # provide an integer after cmdlet and it will set the volume
    [12:58 PM, Sunday 04/19 - BrandonMFong] Powershell>_ Volume # Gets volume level
    Volume Level: 68%
    ```

* **Read Emails**
    User can read emails using Get-Email (Must have Outlook app installed)
    ```
    [Kiran Analytics] Powershell (master*) >_ Get-Email                                                                                         {1} [Visual Studio Dev Essentials - 01/13/2020 10:32 AM] New developer resources for the new year
    {2} [GitHub - 06/02/2020 11:02 AM] [GitHub] A third-party OAuth application has been added to your account
    [Kiran Analytics] Powershell (master*) >_ Get-Email -index 2                                                                                

    ----------------------------------------------Start Message--------------------------------------------
    To: Brandon Fong
    CC:
    From: GitHub
    Subject: [GitHub] A third-party OAuth application has been added to your account
    Body:
    Hey BrandonMFong!

    A third-party OAuth application (Stack Overflow) with user:email scope was recently authorized to access your account.

    To see this and other security events for your account, visit https://github.com/settings/security

    If you run into problems, please contact support by visiting https://github.com/contact

    Thanks,
    The GitHub Team
    ----------------------------------------------End Message-----------------------------------------------
    ```

* **Quickly hop over to a directory using *goto* function**
    Cmd Line
    ```
    [Kiran Analytics] Powershell (master*) >_ goto main                                                                                         
    [Kiran Analytics] Brandon.Fong>_ (pwd).Path                                                                                                 
    C:\Users\brandon.fong\Brandon.Fong

    ```
    Config
    ```
    <Directory Alias="main" SecType="public">C:\Users\brandon.fong\Brandon.Fong</Directory>
    ```

* **GitHub Indicator**
    Enabled to determined branch and uncommitted change
    ```
    [Kiran Analytics] Powershell (master*) >_ git status                                                                                        On branch master
    Your branch is up to date with 'origin/master'.

    Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
            modified:   README.md

    no changes added to commit (use "git add" and/or "git commit -a")
    ```

### Prerequisites

* [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7) - Powershell Version 5
* [SQL](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) - SQL Server
    * *Must have two tables defined (PersonalInfo & TypeContent)*

## Developed With

* [Visual Studio Code](https://code.visualstudio.com/)

## Versioning

MAJOR.MINOR.PATCH

## Authors

**Brandon Fong** - [Github](https://github.com/BrandonMFong)
