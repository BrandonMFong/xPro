<#
.Synopsis
    Retrieves HTML document with a definition 
.Notes
    this code is dependent on the position of data-share-description attribute
#>
Param(
    [Parameter(Mandatory=$true)][String]$Word,
    [String]$HtmlCache=$($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Files.DictionaryCache)
)
[string]$WordCache = $($HtmlCache | Split-Path -Parent) + "\$($Word).txt";

if(!(Test-Path $WordCache))
{
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; # Set protocol 
    [String]$Url = "https://www.merriam-webster.com/dictionary/$($Word)"; # construct urlstring
    New-Item $HtmlCache -Force | Out-Null;
    Invoke-WebRequest $Url -OutFile $HtmlCache;

    # extract definition
    [string]$UniqueID1 = 'data-share-description';
    $(Get-Content $HtmlCache) -replace "$($UniqueID1)","`r`n$($UniqueID1)" | Set-Content $HtmlCache;
    [string]$string = (findstr.exe "data-share-description" $HtmlCache);
    $string = $string.Substring($string.IndexOf($UniqueID1),$string.IndexOf(">")-$string.IndexOf($UniqueID1)).Replace("$($UniqueID1+'="')","").Replace("See the full definition`"","");
    $string = $string.Substring(0,$string.Length - 4);
    
    # Cache the definition
    [string]$DefinitionString = "`n[$($Word)]`n`n   : $($string)`n";
    Set-Content -Value $DefinitionString -Path $WordCache;
}

Get-Content $WordCache;
return;