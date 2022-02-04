<#
# Example:
Register-PSFTeppArgumentCompleter -Command Get-Alcohol -Parameter Type -Name d365fo.integrations.alcohol
#>

Register-PSFTeppArgumentCompleter -Command Get-D365ODataConfig -Parameter Name -Name "d365odata.config.names"
Register-PSFTeppArgumentCompleter -Command Set-D365ActiveODataConfig -Parameter Name -Name "d365odata.config.names"
