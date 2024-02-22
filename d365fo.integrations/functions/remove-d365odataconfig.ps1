
<#
    .SYNOPSIS
        Remove an OData config
        
    .DESCRIPTION
        Removes an OData config from the configuration store
        
    .PARAMETER Name
        The name of the OData configuration you are about to remove from the configuration store
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily remove the OData configuration from the configuration store
        
    .EXAMPLE
        PS C:\> Remove-D365ODataConfig -Name "UAT"
        
        This will create an new OData configuration with the name "UAT".
        
    .NOTES
        Tags: Integrations, Integration, Bearer Token, Token, OData, Configuration
        
        Author: Mötz Jensen (@Splaxi)
#>

function Remove-D365ODataConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [switch] $Temporary
    )

    $Name = $Name.ToLower()

    if ($Name -match '\*') {
        Write-PSFMessage -Level Host -Message "The name cannot contain <c='em'>wildcard character</c>."
        Stop-PSFFunction -Message "Stopping because the name contains wildcard character."
        return
    }

    if (-not ((Get-PSFConfig -FullName "d365fo.integrations.odata.*.name").Value -contains $Name)) {
        Write-PSFMessage -Level Host -Message "An OData configuration with that name <c='em'>doesn't exists</c>."
        Stop-PSFFunction -Message "Stopping because an OData configuration with that name doesn't exists."
        return
    }

    $res = (Get-PSFConfig -FullName "d365fo.integrations.active.odata.config.name").Value

    if ($res -eq $Name) {
        Write-PSFMessage -Level Host -Message "The active OData configuration is the <c='em'>same as the one you're trying to remove</c>. Please set another configuration as active, before removing this one."
        Stop-PSFFunction -Message "Stopping because the active OData configuration is the same as the one trying to be removed."
        return
    }

    foreach ($config in Get-PSFConfig -FullName "d365fo.integrations.odata.$Name.*") {
        Set-PSFConfig -FullName $config.FullName -Value ""

        if (-not $Temporary) { Unregister-PSFConfig -FullName $config.FullName -Scope UserDefault }
    }
}