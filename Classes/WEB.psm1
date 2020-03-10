
class Web
{
    # Object method
    Google([string]$Value)
    {
        $Search = "google.com/search?q= $Value";
        Chrome $Search;
    }
    
    Youtube([string]$Value)
    {
        $YT_Search = "youtube.com/results?search_query= $Value";
        Chrome $YT_Search;
    }

    Dictionary([string]$Value)
    {
        $Search = "https://www.dictionary.com/browse/" + $Value;
        Chrome $Search;
    }

    Sharepoint([string]$x)
    {
        [string]$string = "https://verint.sharepoint.com/_layouts/15/sharepoint.aspx?q="+ $x + "&v=search";
        chrome $string;
    }

    Jira([string]$x)
    {
        [string]$string = "https://cloudcords.atlassian.net/secure/QuickSearch.jspa?searchString=" + $x;
        chrome $string;
    }

}