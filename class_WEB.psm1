
class Web
{
    # Object method
    Search([string]$Value)
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

}