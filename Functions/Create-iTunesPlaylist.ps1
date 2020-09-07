<#
.Synopsis
    Creates an iTunes playlist based on a folder
.Notes
    Prereqs:
        - Playlist must be externally organized into a folder outside of iTunes
        - The .mp3 files should already have been imported 
.Example
    B:\SOURCE\Repo\XmlPSProfile\Functions\Create-iTunesPlaylist.ps1 -BaseXml 'B:\CODE\Xml\iTunes Lib\Library.xml' -PlaylistFolder 'K:\MUSIC\Playlists\Welcome Back My Friend\'
#>
Param
(
    [Parameter(Mandatory)][String]$BaseXml, # Export the library from iTunes 
    [Parameter(Mandatory)][String]$PlaylistFolder # The folder the playlist is already organized in
)

[System.Xml.XmlDocument]$LibXmlReader = Get-Content $BaseXml; # Read the library playlist 

[String[]]$SongNames = (Get-ChildItem $PlaylistFolder).BaseName; # get all the basenames from the folder 
# Recall the basenames of the files are the names that iTunes set by default 

[System.Xml.XmlElement]$o =  $LibXmlReader.CreateElement("dict"); # Create new 

# Setting header START

# Name
# key
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("key");
$j.InnerText = "Name"; $o.AppendChild($j);
# string
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("string");
$j.InnerText = $($PlaylistFolder |Split-Path -Leaf); $o.AppendChild($j);

# Description
# key
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("key");
$j.InnerText = "Description"; $o.AppendChild($j);
# string
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("string");
$o.AppendChild($j);

# Playlist ID
# key
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("key");
$j.InnerText = "Playlist ID"; $o.AppendChild($j);
# integer
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("integer");
$j.InnerText = $(Get-Random -Minimum 0000 -Maximum 9999); $o.AppendChild($j);

# Playlist Persistent ID
# key
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("key");
$j.InnerText = "Playlist Persistent ID"; $o.AppendChild($j);
# string
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("string");
$j.InnerText = $(New-Guid).ToString().ToUpper().Replace("-","").Substring(0,16); $o.AppendChild($j);

# All Items
# key
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("key");
$j.InnerText = "All Items"; $o.AppendChild($j);
# integer
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("true");
$o.AppendChild($j);

# Playlist Items
# key
[System.Xml.XmlElement]$j = $LibXmlReader.CreateElement("key");
$j.InnerText = "Playlist Items"; $o.AppendChild($j);

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
        }
    }
}
$o.AppendChild($TrackArray); # format nodes 

# now create new playlist file 
# using the basexml as the template for the new playlist xml 
$LibXmlReader.plist.dict.array.innerxml = $null # clear 
[System.Xml.XmlElement]$array = $LibXmlReader.SelectSingleNode("//array");
$array.AppendChild($o); # set new playlist data

[string]$SavePath = $($PlaylistFolder | Split-Path -Parent) + "\Exports\Export.xml";
New-Item $SavePath -Force | Out-Null;
$LibXmlReader.Save($SavePath);

