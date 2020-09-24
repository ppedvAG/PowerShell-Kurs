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
    [int]$DirCount = 5,
    [int]$FileCount = 9,
    [Parameter(Mandatory=$true)]
    [string]$Path,
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
            Write-Progress -Activity "Erstelle TestFiles Ordner" -Status "Erstelle Datei $i von $FileCount" -ParentId 1 -Id 2 -PercentComplete (100/$Filecount * $i)

            Write-Verbose -Message "Datei $i in ordner $targetdir wird erstellt"
            $FileNumber = "{0:D3}" -f $i
            New-Item -Path "$targetdir\File$FileNumber.txt" -ItemType File | Out-Null
        }
    }
}