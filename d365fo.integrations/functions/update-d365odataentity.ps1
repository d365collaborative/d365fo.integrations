
<#
    .SYNOPSIS
        Update a Data Entity in Dynamics 365 Finance & Operations
        
    .DESCRIPTION
        Updates a Data Entity, defined as a json payload, using the OData endpoint of the Dynamics 365 Finance & Operations platform
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive
        
        Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3
        
        Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name
        
    .PARAMETER Key
        The key that will select the desired Data Entity uniquely across the OData endpoint
        
        The key would most likely be made up from multiple values, but can also be a single value
        
    .PARAMETER Payload
        The entire string contain the json object that you want to import into the D365FO environment
        
        Remember that json is text based and can use either single quotes (') or double quotes (") as the text qualifier, so you might need to escape the different quotes in your payload before passing it in

    .PARAMETER CrossCompany
        Instruct the cmdlet / function to ensure the request against the OData endpoint will search across all companies

    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through OData
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Update-D365ODataEntity -EntityName "CustomersV3" -Key "dataAreaId='DAT',CustomerAccount='123456789'" -Payload '{"NameAlias": "CustomerA"}' -CrossCompany
        
        This will update a Data Entity in Dynamics 365 Finance & Operations using the OData endpoint.
        The EntityName used for the update is "CustomersV3".
        It will use the "dataAreaId='DAT',CustomerAccount='123456789'" as key to identify the unique Customer record.
        The Payload is a valid json string, containing the needed properties that we want to update.
        It will make sure to search across all legal entities / companies inside the D365FO environment.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $Payload = '{"NameAlias": "CustomerA"}'
        PS C:\> Update-D365ODataEntity -EntityName "accounts" -Key "dataAreaId='DAT',CustomerAccount='123456789'" -Payload $Payload
        
        This will update a Data Entity in Dynamics 365 Finance & Operations using the OData endpoint.
        First the desired json data is put into the $Payload variable.
        The EntityName used for the update is "CustomersV3".
        It will use the "dataAreaId='DAT',CustomerAccount='123456789'" as key to identify the unique Customer record.
        The $Payload variable is passed to the cmdlet.
        It will NOT look across companies.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .NOTES
        Tags: OData, Data, Entity, Update, Upload
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Set-D365ActiveODataConfig
#>

function Update-D365ODataEntity {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $EntityName,

        [Parameter(Mandatory = $true)]
        [string] $Key,

        [Parameter(Mandatory = $true)]
        [Alias('Json')]
        [string] $Payload,

        [Parameter(Mandatory = $false)]
        [switch] $CrossCompany,

        [Parameter(Mandatory = $false)]
        [Alias('$AADGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Parameter(Mandatory = $false)]
        [Alias('URI')]
        [string] $URL = $Script:ODataUrl,

        [Parameter(Mandatory = $false)]
        [string] $ClientId = $Script:ODataClientId,

        [Parameter(Mandatory = $false)]
        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $EnableException

    )

    begin {
        $bearerParms = @{
            Url          = $Url
            ClientId     = $ClientId
            ClientSecret = $ClientSecret
            Tenant       = $Tenant
        }

        $bearer = New-BearerToken @bearerParms

        $headerParms = @{
            URL         = $URL
            BearerToken = $bearer
        }

        $headers = New-AuthorizationHeaderBearerToken @headerParms
    }

    process {
        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building request for the OData endpoint for entity named: $EntityName." -Target $EntityName

        [System.UriBuilder] $odataEndpoint = $URL
        
        $odataEndpoint.Path = "data/$EntityName($Key)"

        if ($CrossCompany) {
            $odataEndpoint.Query = "cross-company=true"
        }

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            Invoke-RestMethod -Method Patch -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json' -Body $Payload
        }
        catch [System.Net.WebException]
        {
            $webException = $_.Exception
            
            if(($webException.Status -eq [System.Net.WebExceptionStatus]::ProtocolError) -and (-not($null -eq $webException.Response))) {
                $resp = [System.Net.HttpWebResponse]$webException.Response

                if($resp.StatusCode -eq [System.Net.HttpStatusCode]::NotFound){
                    $messageString = "It seems that the OData endpoint was unable to locate the desired entity: $EntityName, based on the key: <c='em'>$key</c>. Please make sure that the key is <c='em'>valid</c> or try using the <c='em'>-CrossCompany</c> parameter."
                    Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
                    Stop-PSFFunction -Message "Stopping because of HTTP error 404." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
                    return
                }
                else {
                    $messageString = "Something went wrong while updating the data entity through the OData endpoint for the entity: $EntityName"
                    Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
                    Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
                    return
                }
            }
        }
        catch {
            $messageString = "Something went wrong while updating the data entity through the OData endpoint for the entity: $EntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    }
}