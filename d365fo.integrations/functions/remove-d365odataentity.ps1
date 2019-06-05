
<#
    .SYNOPSIS
        Remove a Data Entity from Dynamics 365 Finance & Operations
        
    .DESCRIPTION
        Removes a Data Entity, defined by the EntityKey, using the OData endpoint of the Dynamics 365 Finance & Operations
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive
        
        Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3
        
        Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name
        
    .PARAMETER EntityKey
        The key that will select the desired Data Entity uniquely across the OData endpoint
        
        The key would most likely be made up from multiple values, but can also be a single value
        
    .PARAMETER CrossCompany
        Instruct the cmdlet / function to ensure the request against the OData endpoint will work across all companies
        
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
        PS C:\> Remove-D365ODataEntity -EntityName ExchangeRates -EntityKey "RateTypeName='TEST'","FromCurrency='DKK'","ToCurrency='EUR'","StartDate=2019-01-13T12:00:00Z"
        
        This will remove a Data Entity from the D365FO environment through OData.
        It will use the ExchangeRate entity, and its EntitySetName / CollectionName "ExchangeRates".
        It will use the "RateTypeName='TEST'","FromCurrency='DKK'","ToCurrency='EUR'","StartDate=2019-01-13T12:00:00Z" as the unique key for the entity.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .NOTES
        Tags: OData, Data, Entity, Import, Upload
        
        Author: Mötz Jensen (@Splaxi)
#>

function Remove-D365ODataEntity {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $EntityName,

        [Parameter(Mandatory = $true)]
        [string[]] $EntityKey,

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
            Url     = $Url
            ClientId     = $ClientId
            ClientSecret = $ClientSecret
            Tenant = $Tenant
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

        Write-PSFMessage -Level Verbose -Message "Building request for removing data entity through the OData endpoint for entity named: $EntityName." -Target $EntityName

        $keyBuilder = [System.Text.StringBuilder]::new()

        $null = $keyBuilder.Append("(")

        foreach ($item in $EntityKey) {
            $null = $keyBuilder.Append("$item,")
        }
        $keyBuilder.Length--
        $null = $keyBuilder.Append(")")

        [System.UriBuilder] $odataEndpoint = $URL

        $odataEndpoint.Path = "data/$EntityName$($keyBuilder.ToString())"

        if ($CrossCompany) {
            $odataEndpoint.Query = $($odataEndpoint.Query + "&cross-company=true").Replace("?", "")
        }

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            Invoke-RestMethod -Method DELETE -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json'
        }
        catch {
            $messageString = $((ConvertFrom-Json $_).Error.InnerError | ConvertTo-Json)
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($messageString)) -ErrorRecord $_
            return
        }
        
        Invoke-TimeSignal -End
    }
}