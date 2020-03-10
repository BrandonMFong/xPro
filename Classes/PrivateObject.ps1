# This is so that I can publish a config without given personal info
# Goal is to create an object by reading local database to load fields and methods
# Config will tell the MakeClassObject function to look through local db
using module .\.\SQL.psm1;
class PrivateObject
{

    PrivateObject()
    {
        # How to dynamically name a property?
        # I want to declare fields so that I can use later
        $val = 'test'
        $var = [SQL]::new('BrandonMFong', 'BRANDONMFONG\SQLEXPRESS', $val);
        $i = $var.Query('select * from typecontent');
        foreach ($val in $i)
        {
            New-Variable -Name $val.Description -Value $val.ExternalID
        }
    }
}

$test = [PrivateObject]::new();