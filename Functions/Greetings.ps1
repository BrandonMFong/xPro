<#
.Synopsis
    Retrieves the javascript results from the http://patorjk.com/software/taag/ site using Internet Explorer
.Notes
    This is not dependent on other files so this can be a gist
    This script will check if the file exists by default to display content
    But it will by default call the URL to get the html content
#>
Param
(
    [Parameter(Mandatory)][String]$string,
    [String]$Type=$null,
    [switch]$SaveToFile=$false
)

# [string]$DirectoryPath = $PSScriptRoot + "\..\Resources\Greetings\"; # Folder to save
[string]$DirectoryPath = $PSScriptRoot + "\..\Cache\Greetings\"; # Folder to save
[String]$FilePath = $DirectoryPath + $string + ".txt"; # Make path to save


# How do I create the file regardless and still output the data
if(Test-Path $FilePath){Get-Content $FilePath;return;}
else
{
    # Get IE object and get content from the link
    $global:ie=new-object -com "internetexplorer.application";
    $ie.navigate("http://patorjk.com/software/taag/#p=display&f=" + $Type + "&t=" + $string); # Get html content
    
    while ($ie.busy -or $ie.readystate -lt 4){start-sleep -milliseconds 200} # Wait until $ie object is done processing

    # This directory is unique for XmlPsProfile repo
    # should change if user wants
    if(!(Test-Path $($DirectoryPath))){mkdir $($DirectoryPath) | Out-Null;} # Make the directory 

    # By default the file will not save to the file
    if($SaveToFile)
    {
        # Save to file 
        $ie.document.getElementById('taag_output_text').OuterText | Out-File $FilePath -Force | Out-Null;
        Get-Content $FilePath; # Get the content
    }
    else{$ie.document.getElementById('taag_output_text').OuterText;}
    return;
}