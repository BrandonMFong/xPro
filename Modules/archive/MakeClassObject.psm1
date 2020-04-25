using module .\..\Classes\Calendar.psm1;
using module .\..\Classes\Math.psm1;
using module .\..\Classes\SQL.psm1;
using module .\..\Classes\Web.psm1;
using module .\..\Classes\Windows.psm1;
using module .\..\Classes\ToDoList.psm1;
# using module .\..\Classes\PrivateObject.psm1;

function MakeClass
{
    Param($XmlElement)

    switch($val.Class.ClassName)
    {
        "Calendar" {$x = [Calendar]::new();return $x;}
        "Web" {$x = [Web]::new();return $x;}
        "Calculations" {$x = [Calculations]::new();return $x;}
        "SQL" {$x = [SQL]::new($val.Class.Database, $val.Class.ServerInstance, $val.Class.Tables);return $x;}
        "Windows" {$x = [Windows]::new();return $x;}
        "ToDoList"{$x = [ToDoList]::new($val.Class.filename);return $x;}
        default
        {
            throw [GlobalScriptsException] "Class $($val.Class.ClassName) was not made.";
        }
    }
}
