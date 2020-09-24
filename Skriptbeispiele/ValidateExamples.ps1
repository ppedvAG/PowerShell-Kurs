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