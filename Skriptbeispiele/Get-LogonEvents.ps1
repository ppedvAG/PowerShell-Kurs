[cmdletBinding()]
Param(
$Logname = "Security",
$Computername = "localhost",
[Parameter(Mandatory=$true)]
[int]$EventId,
$NewestEvents = 5
)
#Ausführliche Ausgabe wenn Skript mit -Verbose aufgerufen wird
Write-Verbose -Message "Es wurden vom user folgende Werte übergeben: EventId = $EventId"

#Debug "Haltepunkt" Wenn Skrupt mit -Debug aufgerufen wird
Write-Debug -Message "Vor Eventlogabfrage"

Get-EventLog -LogName $Logname -ComputerName $Computername | Where-Object -FilterScript {$_.EventID -eq $EventId} | Select-Object -First $NewestEvents