using module ..\Classes\Calendar.psm1;
using module ..\Classes\Math.psm1;
using module ..\Classes\SQL.psm1;
using module ..\Classes\Web.psm1;
using module ..\Classes\Windows.psm1;

function MakeClass
{
    Param($XmlElement)

    switch($val.Class.ClassName)
    {
        "Web"
        {
            $x = [Web]::new();
            return $x;
        }
        "Calculations"
        {
            $x =  [Calculations]::new();
            return $x;
        }
        "SQL" # needs parameters
        {
            $x = [SQL]::new($val.Class.Database, $val.Class.ServerInstance, $val.Class.Tables);
            return $x;
        }
        "Windows"
        {
            $x = [Windows]::new();
            return $x;
        }
        default
        {
            Write-Error "Class $($val.Class.ClassName) was not made."
            return "Class-Not-Made";
        }
    }
}
