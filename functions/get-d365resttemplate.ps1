<#
.SYNOPSIS
Command for getting template for OData

.DESCRIPTION
Returns a json configuration, used for OData with D365FO

.EXAMPLE
Get-D365RestTemplate | Out-File "C:\Temp\ODataConfiguration.json"

.NOTES
General notes
#>
function Get-D365RestTemplate
{
    $template = [IO.File]::ReadAllText("$script:PSModuleRoot\internal\json\odatatemplate.json")

    $template

}

