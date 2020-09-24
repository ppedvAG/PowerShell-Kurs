Param(
$Logname = "Security",
$Computername = "localhost",
[Parameter(Mandatory=$true)]
[int]$EventId,
$NewestEvents = 5
)
Get-EventLog -LogName $Logname -ComputerName $Computername | Where-Object -FilterScript {$_.EventID -eq $EventId} | Select-Object -First $NewestEvents