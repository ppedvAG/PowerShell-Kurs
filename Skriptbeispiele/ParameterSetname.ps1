[cmdletBinding()]
param(
    [Parameter(Mandatory=$true, ParameterSetName="Set1")]
    $Param1,
    [Parameter(Mandatory=$true, ParameterSetName="Set2")]
    $Param2,
    [Parameter(Mandatory=$false, ParameterSetName="Set1")]
    [Parameter(Mandatory=$true, ParameterSetName="Set2")]
    $Param3

)