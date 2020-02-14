& "C:\Program Files (x86)\WinSCP\winscp.com" `
  /log="B:\COLLEGE\19_20\Spring_20\EE_600\WinSCP.log" /ini=nul `
  /command `
    "open sftp://fong:RhrrfLwE@volta.sdsu.edu/ -hostkey=`"`"ssh-rsa 2048 rmqvDzfYNo4D9zvYi9b9N1hdBMQz0esVAJbHUY+qJQc=`"`"" `
    "cd /home/fong/EE600" `
    "lcd B:\COLLEGE\19_20\Spring_20\EE_600\FTPFromVolta" `
    "get *" `
    "exit"

$winscpResult = $LastExitCode
if ($winscpResult -eq 0)
{
  Write-Host "Success"
}
else
{
  Write-Host "Error"
}

exit $winscpResult
