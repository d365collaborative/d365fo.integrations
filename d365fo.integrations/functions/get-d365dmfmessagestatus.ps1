
<#
    .SYNOPSIS
        Get Message Status from the DMF
        
    .DESCRIPTION
        Get the Message Status based on the MessageId from the DMF Endpoint of the Dynamics 365 for Finance & Operations environment
        
    .PARAMETER MessageId
        MessageId of the message that you want to query the status for
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through DMF
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through DMF
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER WaitForCompletion
        Instruct the cmdlet to wait until the Message Status is in a terminating state
        
    .PARAMETER Token
        Pass a bearer token string that you want to use for while working against the endpoint
        
        This can improve performance if you are iterating over a large collection/array
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365DmfMessageStatus -MessageId "84a383c8-336d-45e4-9933-0c3e8bfb734a"
        
        This will get the message status through the DMF endpoint.
        It will use "84a383c8-336d-45e4-9933-0c3e8bfb734a" as the MessageId parameter passed to the DMF endpoint.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365DmfMessageStatus -MessageId "84a383c8-336d-45e4-9933-0c3e8bfb734a" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will import a package into the 123456789 job through the DMF endpoint.
        It will use "84a383c8-336d-45e4-9933-0c3e8bfb734a" as the MessageId parameter passed to the DMF endpoint.
        It will use "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the base D365FO environment url.
        It will use "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
        It will use "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Get-D365DmfMessageStatus -MessageId "84a383c8-336d-45e4-9933-0c3e8bfb734a" -Token $token
        
        This will get the message status through the DMF endpoint.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        It will use "84a383c8-336d-45e4-9933-0c3e8bfb734a" as the MessageId parameter passed to the DMF endpoint.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Import-D365DmfPackage
        
    .LINK
        Set-D365ActiveODataConfig
        
    .NOTES
        Tags: Import, Upload, DMF, Package, Packages, Message, MessageId, Message Status
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365DmfMessageStatus {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $MessageId,

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $WaitForCompletion,

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

        Write-PSFMessage -Level Verbose -Message "Building request for the Message Status OData endpoint."

        $payload = "{'messageId':'$MessageId'}"

        [System.UriBuilder] $odataEndpoint = $URL
        
        $odataEndpoint.Path = "data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.GetMessageStatus"

        try {
            do {
                $res = $null
                
                if ($WaitForCompletion) {
                    Start-Sleep -Seconds 60
                }
                
                Write-PSFMessage -Level Verbose -Message "Executing http request against the Message Status OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
                
                $res = Invoke-RestMethod -Method Post -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json' -Body $payload

                Write-PSFMessage -Level Verbose -Message "Message Status is: $($res.Value) - MessageId: $MessageId" -Target $res.Value
            }
            while ((($res.Value -ne "Processed") -and ($res.Value -ne "PreProcessingError") -and ($res.Value -ne "ProcessedWithErrors") -and ($res.Value -ne "PostProcessingFailed")) -and $WaitForCompletion)

            $res | Add-Member -NotePropertyName "MessageId" -NotePropertyValue $MessageId
            
            $res | Select-PSFObject "Value as MessageStatus", "MessageId", "@odata.context"
        }
        catch {
            $messageString = "Something went wrong while retrieving data from the Message Status OData endpoint for MessageId: $MessageId"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $MessageId
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    
    }

    end {
    }
}