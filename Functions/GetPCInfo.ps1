<#
.Synopsis
    Script to get all the computer info
.Notes
    From my knowledge this works perfectly on pwsh Windows
#>

Write-Host "Computer Name: $($env:computername)";
[system.object[]]$o = $(Get-CimInstance -ClassName CIM_ComputerSystem)
Write-Host "Model: $($o.Model)";
Write-Host "Manufacturer: $($o.Manufacturer)";
Write-Host "Product ID: $($(Get-CimInstance -ClassName CIM_OperatingSystem).SerialNumber)";

[system.object[]]$o = $(Get-CimInstance -ClassName CIM_BIOSElement);
Write-Host "[BIOS] Computer Version: $($o.Version)";
Write-Host "[BIOS] Serial Number: $($o.SerialNumber)";

[system.object[]]$o = $(Get-CimInstance -ClassName CIM_Battery);
Write-Host "Battery: $($o.EstimatedChargeRemaining)%";

[system.object[]]$o = $(Get-CimInstance -ClassName CIM_CoolingDevice);
Write-Host "Cooling Device " -NoNewline;
if($o.Status -eq "OK"){Write-Host "[GOOD]" -ForegroundColor DarkGreen;}
else{Write-Host "[WARNING] => Status: $o.Status" -ForegroundColor DarkYellow;}
Write-Host "    Active Cooling: $($o.ActiveCooling)";

[system.object[]]$o = $(Get-CimInstance -ClassName CIM_OperatingSystem);
Write-Host "OS: $($o.SystemDirectory)";
Write-Host "    Version: $($o.Version)"; # build num is on BugPatch tag

# Ram
[double]$sum = 0;
for([int]$i=0;$i -lt $(Get-CimInstance win32_physicalmemory).Capacity.Length;$i++)
{
    $sum += $(Get-CimInstance win32_physicalmemory)[$i].Capacity;
}
Write-Host "RAM: $($sum/1gb) GB";

# Device disk
[system.object[]]$o = $(Get-CimInstance -ClassName CIM_DiskDrive);
Write-Host "Disk:";
Write-Host "    $($o.Partitions) Partitions";
Write-Host "    Device ID: $($o.DeviceID)";
Write-Host "    Model: $($o.Model)";
Write-Host "    Total Disk Capacity: $($o.Size/1gb) GB";
for([int]$i = 0;$i -lt ($(Get-CimInstance CIM_LogicalDisk).Length);$i++)
{
    if(![string]::IsNullOrEmpty($(Get-CimInstance CIM_LogicalDisk)[$i].FreeSpace))
    {
        Write-Host "        Drive $($(Get-CimInstance CIM_LogicalDisk)[$i].DeviceID) => " -NoNewLine;
        Write-Host "        $($(Get-CimInstance CIM_LogicalDisk)[$i].FreeSpace/1gb) GB free";
    }
}

Write-Host "Cache:";
[System.Object[]]$o = $(Get-CimInstance -ClassName CIM_CacheMemory);
for([int16]$i=0;$i -lt $o.Count;$i++)
{
    Write-Host "    Cache Block: $($o[$i].DeviceID) " -NoNewline;
    if($o[$i].Status -eq "OK"){Write-Host "[GOOD]" -ForegroundColor DarkGreen;}
    else{Write-Host "[WARNING] => Status: $o[$i].Status" -ForegroundColor DarkYellow;}
    Write-Host "        Size: $($o[$i].BlockSize)";
    Write-Host "        Type: $($o[$i].CacheType)";
    Write-Host "        Level: $($o[$i].Level)";
}