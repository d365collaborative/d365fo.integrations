
<#
    .SYNOPSIS
        Get OData configs
        
    .DESCRIPTION
        Get all OData configuration objects from the configuration store
        
    .PARAMETER Name
        The name of the OData configuration you are looking for
        
        The parameter supports wildcards. E.g. -Name "*Customer*"
        
        Default value is "*" to display all OData configs
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365ODataConfig
        
        This will display all OData configurations on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365ODataConfig -OutputAsHashtable
        
        This will display all OData configurations on the machine.
        Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.
        
    .EXAMPLE
        PS C:\> Get-D365ODataConfig -Name "UAT"
        
        This will display the OData configuration that is saved with the name "UAT" on the machine.
        
    .NOTES
        Tags: OData, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365BroadcastMessageConfig
        
    .LINK
        Clear-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365ActiveBroadcastMessageConfig
        
    .LINK
        Remove-D365BroadcastMessageConfig
        
    .LINK
        Send-D365BroadcastMessage
        
    .LINK
        Set-D365ActiveBroadcastMessageConfig
#>

function Get-D365ODataConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param (
        [string] $Name = "*",

        [switch] $OutputAsHashtable,

        [switch] $EnableException
    )
    
    Write-PSFMessage -Level Verbose -Message "Fetch all configurations based on $Name" -Target $Name

    $Name = $Name.ToLower()
    $configurations = Get-PSFConfig -FullName "d365fo.integrations.odata.$Name.name"

    if($($configurations.count) -lt 1) {
        $messageString = "No configurations found <c='em'>with</c> the name."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because no configuration found." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>','')))
        return
    }

    foreach ($configName in $configurations.Value.ToLower()) {
        Write-PSFMessage -Level Verbose -Message "Working against the $configName configuration" -Target $configName
        $res = @{}

        $configName = $configName.ToLower()

        foreach ($config in Get-PSFConfig -FullName "d365fo.integrations.odata.$configName.*") {
            $propertyName = $config.FullName.ToString().Replace("d365fo.integrations.odata.$configName.", "")
            $res.$propertyName = $config.Value
        }
        
        if($OutputAsHashtable) {
            $res
        } else {
            [PSCustomObject]$res
        }
    }
}