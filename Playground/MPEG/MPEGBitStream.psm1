class MPEGBitStream
{
    [Sequence[]]$Sequences = $null;

    
}

class Sequence
{
    # Header
    [SquareSize]$PictureSize;
    [int]$BitsPerPixel;
    [double]$FramesPerSecond;
    [int]$ColorComponent;

    [GOP[]]$GOPS;
}

class GOP # Group of Pictures
{
    # Header
    [SquareSize]$GOPSize;
    [int]$SequenceNumber;
    [string]$TimeCode;

    [Picture[]]$Pictures;
}

class Picture
{
    # Header
    [picture_coding_type]$PictureCodingType; # I, P, or B

    [Slice[]]$Slices;
}

class Slice 
{
    # Header
    [int]$SliceSize = $null;

    [MacroBlock[]]$MacroBlocks;

    Slice($slicesize)
    {
        $this.SliceSize = $slicesize;
    }
}

class MacroBlock
{
    [SubSampleType]$SubSampleType = $null;

    [Block[]]$Blocks;
    MacroBlock([SubSampleType]$subsampletype)
    {

    }
}


class Block 
{
    [Pixel[]]$Pixels
}

class Pixel 
{
    
    Pixel($Dimension)
    {

    }
}

############################  OFF BITSTREAM TYPES ##############################
class SquareSize
{
    [double]$Length = $null;
    [double]$Width = $null;
    SquareSize($w, $l)
    {
        $this.Length = $l;
        $this.Width = $w;
    }
}
enum picture_coding_type
{
    I = 0 # Intra Coded Pictures
    P = 1 # Predictive Coded Pictures
    B = 2 # Bi-directionally Coded Pictures
}
enum SubSampleType
{
    fourtwozero = 0
    fourtwotwo = 1
}