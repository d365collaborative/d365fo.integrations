
<#
    .SYNOPSIS
        Invoke a REST Endpoint in Dynamics 365 Finance & Operations
        
    .DESCRIPTION
        Invokce any REST Endpoint available in a Dynamics 365 Finance & Operations environment

        It can be REST endpoints that are available out of the box or custom REST endpoints based on X++ classesrations platform
        
    .PARAMETER ServiceName
        The "name" of the REST endpoint that you want to invoke

        The REST endpoints consists of the following elementes:
        ServiceGroupName/ServiceName/MethodName

        E.g. "UserSessionService/AifUserSessionService/GetUserSessionInfo"
        
    .PARAMETER Payload
        The entire string contain the json object that you want to pass to the REST endpoint

        If the payload parameter is NOT blank, it will trigger a HTTP POST action against the URL.

        But if the payload is null / blank or empty, it will trigger a HTTP GET action against the URL.

        Remember that json is text based and can use either single quotes (') or double quotes (") as the text qualifier, so you might need to escape the different quotes in your payload before passing it in
        
    .PARAMETER CrossCompany
        Instruct the cmdlet / function to ensure the request against the REST endpoint will work across all companies
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through REST endpoint
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through REST endpoint
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload ""
        
        This will import a Data Entity into Dynamics 365 Finance & Operations using the OData endpoint.
        The EntityName used for the import is ExchangeRates.
        The Payload is a valid json string, containing all the needed properties.
        
    .EXAMPLE
        PS C:\> $Payload = '{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
        PS C:\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload $Payload
        
        This will import a Data Entity into Dynamics 365 Finance & Operations using the OData endpoint.
        First the desired json data is put into the $Payload variable.
        The EntityName used for the import is ExchangeRates.
        The $Payload variable is passed to the cmdlet.
        
    .NOTES
        Tags: REST, Endpoint, Custom Service, Services
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365RestEndpoint {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ServiceName,

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

        Write-PSFMessage -Level Verbose -Message "Building request for the REST endpoint for the service: $ServiceName." -Target $ServiceName
        
        [System.UriBuilder] $restEndpoint = $URL

        $restEndpoint.Path = "api/services/$ServiceName"

        if ($CrossCompany) {
            $restEndpoint.Query = "cross-company=true"
        }

        $params = @{ }
        $params.Uri = $restEndpoint.Uri.AbsoluteUri
        $params.Headers = $headers
        $params.ContentType = "application/json"

        if ($null -ne $Payload) {
            $params.Method = "POST"
            $params.Body = $Payload
        }
        else {
            $params.Method = "GET"
        }
        
        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the REST endpoint." -Target $($restEndpoint.Uri.AbsoluteUri)
            Invoke-RestMethod @params
        }
        catch {
            $messageString = "Something went wrong while importing data through the REST endpoint for the entity: $ServiceName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $ServiceName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    }
}