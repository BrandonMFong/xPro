using module .\Calendar.psm1;
using module .\Math.psm1;
using module .\SQL.psm1;
using module .\Web.psm1;
using module .\Windows.psm1;

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
        default
        {
            Write-Error "Class $($val.Class.ClassName) was not made."
            return "Class-Not-Made";
        }
    }
}
