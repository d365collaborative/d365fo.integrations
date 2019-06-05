
<#
    .SYNOPSIS
        Save an OData config
        
    .DESCRIPTION
        Adds an OData config to the configuration store
        
    .PARAMETER Name
        The logical name of the OData configuration you are about to register in the configuration store
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through OData
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily add the OData configuration in the configuration store
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the OData configuration with the same name
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Add-D365ODataConfig -Name "UAT" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will create an new OData configuration with the name "UAT".
        It will save "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
        It will save "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the D365FO environment.
        It will save "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
        It will save "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.
        
    .NOTES
        Tags: Integrations, Integration, Bearer Token, Token, OData, Configuration
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Clear-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365BroadcastMessageConfig
        
    .LINK
        Remove-D365BroadcastMessageConfig
        
    .LINK
        Send-D365BroadcastMessage
        
    .LINK
        Set-D365ActiveBroadcastMessageConfig
#>

function Add-D365ODataConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Name,

        [Parameter(Mandatory = $false, Position = 1)]
        [Alias('$AADGuid')]
        [string] $Tenant,

        [Parameter(Mandatory = $false, Position = 2)]
        [Alias('Uri')]
        [string] $Url,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $ClientId,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $ClientSecret,

        [switch] $Temporary,

        [switch] $Force,

        [switch] $EnableException
    )

    Write-PSFMessage -Level Verbose -Message "Testing if configuration with the name already exists or not." -Target $configurationValue

    if (((Get-PSFConfig -FullName "d365fo.integrations.odata.*.name").Value -contains $Name) -and (-not $Force)) {
        $messageString = "An OData configuration with <c='em'>$Name</c> as name <c='em'>already exists</c>. If you want to <c='em'>overwrite</c> the current configuration, please supply the <c='em'>-Force</c> parameter."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because an OData configuration already exists with that name." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>','')))
        return
    }

    $configName = ""

    #The ':keys' label is used to have a continue inside the switch statement itself
    :keys foreach ($key in $PSBoundParameters.Keys) {
        
        $configurationValue = $PSBoundParameters.Item($key)
        $configurationName = $key.ToLower()
        $fullConfigName = ""

        Write-PSFMessage -Level Verbose -Message "Working on $key with $configurationValue" -Target $configurationValue
        
        switch ($key) {
            "Name" {
                $configName = $Name.ToLower()
                $fullConfigName = "d365fo.integrations.odata.$configName.name"
            }

            {"Temporary","Force" -contains $_} {
                continue keys
            }
            
            Default {
                $fullConfigName = "d365fo.integrations.odata.$configName.$configurationName"
            }
        }

        Write-PSFMessage -Level Verbose -Message "Setting $fullConfigName to $configurationValue" -Target $configurationValue
        
        Set-PSFConfig -FullName $fullConfigName -Value $configurationValue
        
        if (-not $Temporary) { Register-PSFConfig -FullName $fullConfigName -Scope UserDefault }
    }
}