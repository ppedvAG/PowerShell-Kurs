function New-TestFiles
{
<#
.SYNOPSIS
    Skript zum erstellen eines TestFiles Verzeichnisses
.DESCRIPTION
    Skript zum erstellen eine Verzeichnisses welches eine angegebene Anzahl von Dateien und Ordnern beeinhaltet für TestZwecke
.PARAMETER DirCount
    Der Parameter DirCount gibt an wie viele Unterordner unterhalb des angegebenen Pfades erstellt werden sollen
.PARAMETER FileCount
    Der Parameter FileCount gibt an wie viele Dateien im Root Verzeichnis und in jedem Unterverzeichniss erstellt werden sollen.
.PARAMETER Path
    Gibt an unter welchem Pfad die Dateien und Ordner erstellt werden sollen. 
.PARAMETER force
    Wird der Force Parameter angegeben wird ein vorhandenes Verzeichniss komplett gelöscht um es anschließend neu zu erstelltn.
.EXAMPLE
    .\New-TestFilesdir.ps1 -Path C:\TestFiles

    Erstellt unter dem angegebenen Pfad (C:\TestFiles) 5 Ordner mit jeweilig 9 Dateien.
#>
[cmdletBinding()]
param(
    [ValidateRange(1,999)]
    [int]$DirCount = 5,
    [ValidateRange(1,999)]
    [int]$FileCount = 9,
    [Parameter(Mandatory=$true)]
    [ValidateScript({(Test-Path -IsValid -Path $_) -and ($_.Contains("C:\Windows") -eq $false)})]
    [string]$Path,
    [ValidateSet("None","ipconfig","RandomNumber","RandomProcess")]
    [string]$Content = "None",
    [switch]$force
)
Write-Progress -Activity "Erstelle TestFiles Ordner" -Status "Prüfung auf vorhandene Dateien" -PercentComplete 25
if((Test-Path -Path $Path) -and $force)
{
    Write-Verbose -Message "vorhandene Ordner und Dateien werden gelöscht"
    Remove-Item -Path $Path -Recurse -Force | Out-Null
}
if((Test-Path -Path $Path) -and $force -eq $false)
{
    Write-Host -ForegroundColor Red "Ordner bereits vorhanden, löschen sie das Verzeichnis manuell oder rufen Sie das Skript erneut mit dem Parameter -force aus zum automatischen vorherigen löschen des Verzeichnisses inklusive aller Dateien und Unterordner"
}
else
{
Write-Progress -Activity "Erstelle TestFiles Ordner" -Status "Ordnererstellung" -PercentComplete 50
    for($i=1;$i -le $DirCount;$i++)
    {
        Write-Progress -Activity "Erstelle TestFiles Ordner" -Status "Erstelle ordner $i von $DirCount" -Id 1 -PercentComplete (100/$DirCount * $i)
        Write-Verbose -Message "Ordner $i wird erstellt"
        $DirNumber = "{0:D3}" -f $i
        New-Item -Path "$Path\Ordner$DirNumber" -ItemType Directory | Out-Null
    }

    $Ordner = Get-ChildItem -Path "$Path" -Directory 
    [string[]]$Ordnerpfade = $Ordner[0].Parent.FullName
    foreach($Dir in $Ordner)
    {
        $Ordnerpfade += $Dir.FullName
    }
    Write-Progress -Activity "Erstelle TestFiles Ordner" -Status "Dateierstellung" -PercentComplete 75

    $targetcounter = 0
    foreach($targetdir in $Ordnerpfade)
    {
        $targetcounter ++
        Write-Progress -Activity "Erstelle TestFiles Ordner" -Id 1 -Status "Dateierstellung für Ordner: $targetdir" -PercentComplete (100/$Ordnerpfade.Count * $targetcounter)
        for($i = 1;$i -le $FileCount;$i++)
        {
            
            switch($Content)
            {
                "None" {Write-Debug -Message "SwitchCase None";$Value = " "}
                "ipconfig" {$Value = ipconfig | Out-String}
                "RandomNumber" {$Value = Get-Random}
                "RandomProcess" {$Value = Get-Process | Get-Random | Format-List -Property * | Out-String}
            }
            Write-Progress -Activity "Erstelle TestFiles Ordner" -Status "Erstelle Datei $i von $FileCount" -ParentId 1 -Id 2 -PercentComplete (100/$Filecount * $i)

            Write-Verbose -Message "Datei $i in ordner $targetdir wird erstellt"
            $FileNumber = "{0:D3}" -f $i
            New-Item -Path "$targetdir\File$FileNumber.txt" -ItemType File -Value $Value | Out-Null
        }
    }
}
}

function Get-LogonEvents
{
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
}

function Test-Validates
{
    [cmdletBinding()]
    param(
    [ValidatePattern("[a-z][0-9][A-Z][0-9]")]
    [string]$Pattern,
    [ValidateRange(1,5)]
    [int]$Range,
    [ValidateLength(2,5)]
    [string]$Length,
    [ValidateScript({Test-Path -IsValid -Path $_})]
    [string]$Script,
    [ValidateSet("Wert1","Wert2")]
    [string]$Set
    )
}