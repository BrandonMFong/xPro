function Search 
{
    <#
    .Synopsis
        Have users call a website on their default browser and append search parameters
    .Notes
        Configurable, just need to provide the search URL with the search parameters 
    #>
    param(
        [Parameter(Mandatory=$true)][String]$Type
    )
    Import-Module $($PSScriptRoot + "\..\Modules\xProUtilities.psm1") -Scope Local;

    [String]$UrlString = $null;
    foreach($Search in $Global:XMLReader.Machine.Searches.Search)
    {
        if($Type -eq $Search.Type) # if it matches config 
        {
            [string]$Value = Read-Host -Prompt "$($Type)";
            [string]$PreString = $Search.InnerText;
            $UrlString = $PreString.Replace($Search.Placeholder,$Value);
        }
    }
    if(![string]::IsNullOrEmpty($UrlString)){Start-Process $UrlString;} # If the above algorithm found the correct one
}