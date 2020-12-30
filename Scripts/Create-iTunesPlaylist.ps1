<#
.Synopsis
    Creates an iTunes playlist based on a folder
.Notes
    Prereqs:
        - Playlist must be externally organized into a folder outside of iTunes
        - The .mp3 files should already have been imported 
.Example
    B:\SOURCE\Repo\XmlPSProfile\Scripts\Create-iTunesPlaylist.ps1 -BaseXml 'B:\CODE\Xml\iTunes Lib\Library.xml' -PlaylistFolder 'K:\MUSIC\Playlists\Welcome Back My Friend\'
#>
Param
(
    [Parameter(Mandatory)][String]$BaseXml, # Export the library from iTunes 
    [Parameter(Mandatory)][String]$PlaylistFolder # The full path to the folder the playlist is already organized in (must already be imported into itunes)
)

[System.Xml.XmlDocument]$LibXmlReader = Get-Content $BaseXml; # Read the library playlist 

[String[]]$SongNames = (Get-ChildItem $PlaylistFolder).BaseName; # get all the basenames from the folder 
# Recall the basenames of the files are the names that iTunes set by default 

[System.Xml.XmlElement]$o =  $LibXmlReader.CreateElement("dict"); # Create new 

# Setting header START

# Using .json to create the base plist config 

[System.Object[]]$plistReader = Get-Content $($global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Files.plistConfig) -Force|ConvertFrom-Json;# Assuming you are using this with this repo

for([int16]$i = 0;$i -lt $plistReader.Nodes.Node.count;$i++)
{
    [System.Xml.XmlElement]$j = $LibXmlReader.CreateElement($plistReader.Nodes.Node[$i].Key);
    if(![string]::IsNullOrEmpty($plistReader.Nodes.Node[$i].Value))
    {
        if($plistReader.Nodes.Node[$i].ValIsCmd)
        {$j.InnerText = $(Invoke-Expression $plistReader.Nodes.Node[$i].Value);}
        else{$j.InnerText = $plistReader.Nodes.Node[$i].Value;}
    }
    $o.AppendChild($j);
}

# Setting header END

# IMPORTANT
[System.Xml.XmlElement]$TrackArray = $LibXmlReader.CreateElement("array");

[system.object[]]$m = $LibXmlReader.plist.dict.dict.dict # Get the list of songs from lib xml

# Find song 
for([int16]$i = 0;$i -lt $SongNames.Count;$i++)
{
    for([int16]$k = 0;$k -lt $m.Length;$k++)
    {
        # Go through the songs in the lib and see if it matches the currernt basename of the mp3 file
        # if so, let's make the node
        if($m[$k].String[0] -eq $SongNames[$i])
        {
            [System.Xml.XmlElement]$Track = $LibXmlReader.CreateElement("dict"); # Create track node 
        
            [System.Xml.XmlElement]$key = $LibXmlReader.CreateElement("key"); $key.InnerText = "Track ID";
            [System.Xml.XmlElement]$integer = $LibXmlReader.CreateElement("integer"); $integer.InnerText = $($m[$k].integer[0]).ToString(); # TRACK ID
        
            $Track.AppendChild($key);$Track.AppendChild($integer);

            $TrackArray.AppendChild($Track); # Add to the Playlist Items
            Write-Host "Added $($SongNames[$i]) to playlist"
        }
    }
}
$o.AppendChild($TrackArray); # format nodes 

# now create new playlist file 
# using the basexml as the template for the new playlist xml 
$LibXmlReader.plist.dict.array.innerxml = $null # clear 
[System.Xml.XmlElement]$array = $LibXmlReader.SelectSingleNode("//array");
$array.AppendChild($o); # set new playlist data

# Only using a standard name because I don't think you would need to keep it automatically
[string]$SavePath = $($PlaylistFolder | Split-Path -Parent) + "\Exports\Export.xml";
New-Item $SavePath -Force | Out-Null;
$LibXmlReader.Save($SavePath);
Write-Host "Saved in $($SavePath)" -ForegroundColor Gray;

