<#
.Synopsis
    Retrieves HTML document with a definition 
.Notes
    this code is dependent on the position of data-share-description attribute
#>
Param(
    [Parameter(Mandatory=$true)][String]$Word,
    [String]$CachePath=$($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Files.DictionaryCache)
)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
[String]$Url = "https://www.merriam-webster.com/dictionary/$($Word)";
New-Item $CachePath -Force | Out-Null;
Invoke-WebRequest $Url -OutFile $CachePath;
[string]$UniqueID1 = 'data-share-description';
$(Get-Content $CachePath) -replace "$($UniqueID1)","`r`n$($UniqueID1)" | Set-Content $CachePath;
[string]$string = (findstr.exe "data-share-description" $CachePath);
$string = $string.Substring($string.IndexOf($UniqueID1),$string.IndexOf(">")-$string.IndexOf($UniqueID1)).Replace("$($UniqueID1+'="')","").Replace("See the full definition`"","");
$string = $string.Substring(0,$string.Length - 4);
Write-Host "`n$($Word) : $($string)`n";