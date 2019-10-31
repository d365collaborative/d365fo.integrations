
<#
        
    .SYNOPSIS
        Set the active OData configuration
        
    .DESCRIPTION
        Updates the current active OData configuration with a new one
        
    .PARAMETER Name
        Name of the OData configuration you want to load into the active OData configuration
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily override the persisted settings in the configuration store
        
    .EXAMPLE
        PS C:\> Set-D365ActiveODataConfig -Name "UAT"
        
        This will set the OData configuration named "UAT" as the active configuration.
        
    .NOTES
        Tags: Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
#>

function Set-D365ActiveODataConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Name,

        [switch] $Temporary
    )

    if($Name -match '\*') {
        $messageString = "The name cannot contain <c='em'>wildcard character</c>."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because the name contains wildcard character." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>','')))
        return
    }

    if (-not ((Get-PSFConfig -FullName "d365fo.integrations.odata.*.name").Value -contains $Name)) {
        $messageString = "An OData configuration with that name <c='em'>doesn't exists</c>."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because an OData message configuration with that name doesn't exists." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>','')))
        return
    }

    Set-PSFConfig -FullName "d365fo.integrations.active.odata.config.name" -Value $Name
    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.integrations.active.odata.config.name"  -Scope UserDefault }

    Update-ODataVariables
}