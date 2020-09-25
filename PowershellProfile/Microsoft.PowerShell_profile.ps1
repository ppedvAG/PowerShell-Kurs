#Powershell Profil für Host Shell. Andere Pfade unter der $Profile Variable . 
function Set-ConsoleColors
{
    [cmdletBinding()]
    param()

    $ReadlineVersion = (Get-Module -Name PSReadline -ListAvailable).Version
    if($ReadlineVersion.Major -lt 2)
    {
        Write-Verbose -Message "PSReadlineVersion $ReadlineVersion"

        $Host.UI.RawUI.BackgroundColor = "White"
        $Host.UI.RawUI.ForegroundColor = "Black"

        Set-PSReadlineOption -TokenKind Command -ForegroundColor DarkBlue
        Set-PSReadlineOption -TokenKind Parameter -ForegroundColor Blue
        Set-PSReadlineOption -TokenKind Number -ForegroundColor DarkRed
        Set-PSReadlineOption -TokenKind Member -ForegroundColor DarkGray
        Set-PSReadlineOption -TokenKind Variable -ForegroundColor Green
        
        Clear-Host 
    }
    else
    {
        Write-Verbose -Message "PSReadlineVersion $ReadlineVersion"

        $Host.UI.RawUI.BackgroundColor = "White"
        $Host.UI.RawUI.ForegroundColor = "Black"

        Set-PSReadlineOption -Colors @{"Command" = [ConsoleColor]::DarkBlue
                                       "Parameter" = [ConsoleColor]::Blue
                                       "Number" = [ConsoleColor]::DarkRed
                                       "Member" = [ConsoleColor]::DarkGray
                                       "Variable" = [ConsoleColor]::Green
                                        }
    }
}

function Set-WindowTitle
{
    [cmdletBinding()]
    param(
        [string]$Newtitle = "Default"
    )
    if($Newtitle -eq "Default")
    {
        $Newtitle = "$($env:COMPUTERNAME) | $env:USERNAME"
    }
    $Host.UI.RawUI.WindowTitle = $Newtitle
}

function Prompt
{
    #PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) " Default
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
    {
        $UserState = "Elevated"
    }
    else
    {
        $UserState = "User"
    }
    #Write-Host -ForegroundColor (Get-Random -Maximum 15 -Minimum 1)  "[$((Get-Date).ToShortTimeString())][$($env:COMPUTERNAME)]$UserState ..$((Get-Location).Path.Remove(0,((Get-Location).Path.LastIndexOf('\'))))$('>' * ($nestedPromptLevel + 1))"
    Write-Host -ForegroundColor (Get-Random -Maximum 15 -Minimum 1)  "[$((Get-Date).ToShortTimeString())][$($env:COMPUTERNAME)]$UserState Pfad: $((Get-Location).Path)"
    return "$('>' * ($nestedPromptLevel + 1))"
}

Set-ConsoleColors
Set-WindowTitle