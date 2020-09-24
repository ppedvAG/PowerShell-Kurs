<#
.SYNOPSIS 
   Frägt Anmelde bezogene Events vom System ab
.DESCRIPTION
   Lange Beschreibung
.EXAMPLE
   .\Get-LogonEvents.ps1 -EventId 4624

   Frägt alle Anmeldeevents vom Standard Log Security ab.

   Ausgabe:
   Index Time          EntryType   Source                 InstanceID Message
   ----- ----          ---------   ------                 ---------- -------
   17449 Sep 24 10:48  SuccessA... Microsoft-Windows...         4624 Ein Konto wurde erfolgreich angemeldet....
   17446 Sep 24 10:48  SuccessA... Microsoft-Windows...         4624 Ein Konto wurde erfolgreich angemeldet....
   17443 Sep 24 10:48  SuccessA... Microsoft-Windows...         4624 Ein Konto wurde erfolgreich angemeldet....
   17440 Sep 24 10:48  SuccessA... Microsoft-Windows...         4624 Ein Konto wurde erfolgreich angemeldet....
   17436 Sep 24 10:47  SuccessA... Microsoft-Windows...         4624 Ein Konto wurde erfolgreich angemeldet....

.EXAMPLE
   Ein weiteres Beispiel für die Verwendung dieses Cmdlets
#>
[cmdletBinding()]
Param(
[string]$Logname = "Security",
[string]$Computername = "localhost",
[Parameter(Mandatory=$true)]
[int]$EventId,
[int]$NewestEvents = 5
)
#Ausführliche Ausgabe wenn Skript mit -Verbose aufgerufen wird
Write-Verbose -Message "Es wurden vom user folgende Werte übergeben: EventId = $EventId"

#Debug "Haltepunkt" Wenn Skrupt mit -Debug aufgerufen wird
Write-Debug -Message "Vor Eventlogabfrage"

Get-EventLog -LogName $Logname -ComputerName $Computername | Where-Object -FilterScript {$_.EventID -eq $EventId} | Select-Object -First $NewestEvents