<#
.Synopsis
   Puts specified directory objects into an 'archive' folder
.Notes
#>
Param([Switch]$Verbose)

if(!(Test-Path .\archive\)){ mkdir archive;}
Get-ChildItem * |
Where-Object{$_.Name -ne 'archive'} | 
ForEach-Object{
   [string]$regex = $('.\archive\' + $_.BaseName + "*" + $_.Extension);
   if(Test-Path $regex){ # must take into account if there is more than 2 files
      [string]$NewName = $_.BaseName + " (" + $((Get-ChildItem $regex).Count + 1).ToString() + ")" + $_.Extension;
      Rename-Item $_.Name $NewName;
      Move-Item $NewName .\archive\ -Force -Verbose:$Verbose;
   }
   else{
      Move-Item $_ .\archive\ -Force -Verbose:$Verbose;
   }
}
