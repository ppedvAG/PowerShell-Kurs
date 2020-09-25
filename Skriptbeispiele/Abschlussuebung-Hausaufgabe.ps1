[cmdletBinding()]
param(

)
if(Test-Path -Path C:\Gewinnspiel)
{
    Get-ChildItem -Path C:\Gewinnspiel -File | Remove-Item
}
else
{
    New-Item -Path C:\Gewinnspiel -ItemType Directory
}

$Users = Get-ADUser -Filter * 
[string[]]$Files = "Niete"
foreach($User in $Users)
{
    if($user.givenName.Length -gt 2 -and $user.SurName.Length -gt 2)
    {
        Out-File -FilePath "C:\Gewinnspiel\$($user.SamAccountName).txt" -InputObject "$($User.GivenName), $($User.SurName)"
        $Files += "C:\Gewinnspiel\$($user.SamAccountName).txt"
    }
}

$Gewinner = Get-Random -InputObject $Files
if($Gewinner -ne "Niete")
{
    Out-Voice -InputText (Get-Content -Path $Gewinner)
}
else
{
    Out-Voice -InputText $Gewinner
}