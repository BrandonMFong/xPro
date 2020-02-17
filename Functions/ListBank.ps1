foreach($val in $XMLReader.Machine.Aliases.Alias)
{
    Set-Alias $val.Name "$($val.InnerXML)";
}