<#
.Synopsis
    Script to get all the computer info
.Notes
    From my knowledge this works perfectly on pwsh Windows
#>

Write-Host "Computer Name: $($env:computername)";
[double]$sum = 0;
for([int]$i=0;$i -lt $(Get-CimInstance win32_physicalmemory).Capacity.Length;$i++)
{
    $sum += $(Get-CimInstance win32_physicalmemory)[$i].Capacity;
}
Write-Host "RAM: $($sum/1gb) GB";
for([int]$i = 0;$i -lt ($(Get-CimInstance CIM_LogicalDisk).Length);$i++)
{
    if(![string]::IsNullOrEmpty($(Get-CimInstance CIM_LogicalDisk)[$i].FreeSpace))
    {
        Write-Host "Drive $($(Get-CimInstance CIM_LogicalDisk)[$i].DeviceID) =>" -NoNewLine;
        Write-Host "$($(Get-CimInstance CIM_LogicalDisk)[$i].FreeSpace/1gb) GB free";
    }
}