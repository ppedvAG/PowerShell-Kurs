
#installiere etwas auf remote system 
Restart-Computer -ComputerName Member1 -Force

#Warte bis System offline
do
{
    Start-Sleep -Seconds 10
}while(Test-NetConnection -ComputerName Member1 -CommonTCPPort WINRM -InformationLevel Quiet)

#Warte bis System wieder online
do
{
    Write-Host -ForegroundColor DarkYellow "Warte"
    Start-Sleep -Seconds 1
    
}until(Test-NetConnection -ComputerName Member1 -CommonTCPPort WINRM -InformationLevel Quiet)