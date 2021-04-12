
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
        
    .PARAMETER Key
        The key that will select the desired Data Entity uniquely across the OData endpoint
        
        The key would most likely be made up from multiple values, but can also be a single value
        
    .PARAMETER CrossCompany
        Instruct the cmdlet / function to ensure the request against the OData endpoint will work across all companies
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through OData
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself
        
        If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"
        
    .PARAMETER SystemUrl
        URL / URI for the D365FO instance where the OData endpoint is available
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself, which is the same as the Url parameter value
        
        If you are working against a D365 Talent / HR instance, this will to be full instance URL / URI like "https://aos-rts-sf-b1b468164ee-prod-northeurope.hr.talent.dynamics.com/namespaces/0ab49d18-6325-4597-97b3-c7f2321aa80c"
        
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
        PS C:\> Remove-D365ODataEntity -EntityName ExchangeRates -Key "RateTypeName='TEST',FromCurrency='DKK',ToCurrency='EUR',StartDate=2019-01-13T12:00:00Z"
        
        This will remove a Data Entity from the D365FO environment through OData.
        It will use the ExchangeRate entity, and its EntitySetName / CollectionName "ExchangeRates".
        It will use the "RateTypeName='TEST',FromCurrency='DKK',ToCurrency='EUR',StartDate=2019-01-13T12:00:00Z" as the unique key for the entity.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Remove-D365ODataEntity -EntityName ExchangeRates -Key "RateTypeName='TEST',FromCurrency='DKK',ToCurrency='EUR',StartDate=2019-01-13T12:00:00Z" -Token $token
        
        This will remove a Data Entity from the D365FO environment through OData.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        It will use the ExchangeRate entity, and its EntitySetName / CollectionName "ExchangeRates".
        It will use the "RateTypeName='TEST',FromCurrency='DKK',ToCurrency='EUR',StartDate=2019-01-13T12:00:00Z" as the unique key for the entity.
        
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
        [string] $Key,

        [switch] $CrossCompany,

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $SystemUrl = $Script:ODataSystemUrl,
        
        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [string] $Token,
        
        [switch] $EnableException

    )

    begin {
        if ([System.String]::IsNullOrEmpty($SystemUrl)) {
            Write-PSFMessage -Level Verbose -Message "The SystemUrl parameter was empty, using the Url parameter as the OData endpoint base address." -Target $SystemUrl
            $SystemUrl = $Url
        }

        if ([System.String]::IsNullOrEmpty($Url) -or [System.String]::IsNullOrEmpty($SystemUrl)) {
            $messageString = "It seems that you didn't supply a valid value for the Url parameter. You need specify the Url parameter or add a configuration with the <c='em'>Add-D365ODataConfig</c> cmdlet."
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $entityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
        
        if ($Url.Substring($Url.Length - 1) -eq "/") {
            Write-PSFMessage -Level Verbose -Message "The Url parameter had a tailing slash, which shouldn't be there. Removing the tailling slash." -Target $Url
            $Url = $Url.Substring(0, $Url.Length - 1)
        }
    
        if ($SystemUrl.Substring($SystemUrl.Length - 1) -eq "/") {
            Write-PSFMessage -Level Verbose -Message "The SystemUrl parameter had a tailing slash, which shouldn't be there. Removing the tailling slash." -Target $Url
            $SystemUrl = $SystemUrl.Substring(0, $SystemUrl.Length - 1)
        }
        
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

        Write-PSFMessage -Level Verbose -Message "Building request for removing data entity through the OData endpoint for entity named: $EntityName." -Target $EntityName

        [System.UriBuilder] $odataEndpoint = $SystemUrl
        
        if ($odataEndpoint.Path -eq "/") {
            $odataEndpoint.Path = "data/$EntityName($Key)"
        }
        else {
            $odataEndpoint.Path += "/data/$EntityName($Key)"
        }

        if ($CrossCompany) {
            $odataEndpoint.Query = $($odataEndpoint.Query + "&cross-company=true").Replace("?", "")
        }

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            $null = Invoke-RestMethod -Method DELETE -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json'
        }
        catch {
            $messageString = $((ConvertFrom-Json $_).Error.InnerError | ConvertTo-Json -Depth 10)
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($messageString)) -ErrorRecord $_
            return
        }
        
        Invoke-TimeSignal -End
    }
}