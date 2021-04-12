
<#
    .SYNOPSIS
        Invoke DMF Initialize, which will refresh all Data Management Entities
        
    .DESCRIPTION
        Invokes the DMF initialization from the DMF Endpoint of the Dynamics 365 for Finance & Operations environment
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through DMF
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through DMF
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER Token
        Pass a bearer token string that you want to use for while working against the endpoint
        
        This can improve performance if you are iterating over a large collection/array
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365DmfInit
        
        This will invoke the DMF initialization through the DMF endpoint.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Invoke-D365DmfInit -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will invoke the DMF initialization through the DMF endpoint.
        It will use "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
        It will use "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
        It will use "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Invoke-D365DmfInit -Token $token
        
        This will invoke the DMF initialization through the DMF endpoint.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Set-D365ActiveODataConfig
        
    .NOTES
        Tags: DMF, Entities, Enitity, Init, Initialize, Refresh
        
        Author: Mötz Jensen (@Splaxi), Gert Van Der Heyden (@gertvdheyden)
#>

function Invoke-D365DmfInit {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [string] $Token,

        [switch] $EnableException
    )

    begin {
        if (-not $Token) {
            $bearerParms = @{
                Url          = $Url
                ClientId     = $ClientId
                ClientSecret = $ClientSecret
                Tenant       = $Tenant
            }

            $bearer = New-BearerToken @bearerParms
        }
        else {
            $bearer = $Token
        }
        
        $headerParms = @{
            URL         = $Url
            BearerToken = $bearer
        }

        $headers = New-AuthorizationHeaderBearerToken @headerParms
    }

    process {
        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building request for the DMF Initialize OData endpoint."

        [System.UriBuilder] $odataEndpoint = $URL
        
        $odataEndpoint.Path = "data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.InitializeDataManagement"

        try {
            
            Write-PSFMessage -Level Verbose -Message "Executing http request against the DMF Initialize OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
                
            Invoke-RestMethod -Method Post -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json' -Body '{}'
        }
        catch {
            $messageString = "Something went wrong while retrieving data from the DMF Initialize OData endpoint"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    
    }

    end {
    }
}