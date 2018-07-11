
<#
.SYNOPSIS
Command for getting template for integration

.DESCRIPTION
Returns a json configuration, used for integration with D365FO

.EXAMPLE
Get-IntegrationTemplate | Out-File "C:\Temp\Integration.json"

.NOTES
General notes
#>
function Get-D365IntegrationTemplate
{
    $template = [IO.File]::ReadAllText("$script:PSModuleRoot\internal\json\Integrationtemplate.json")

    $template

}

