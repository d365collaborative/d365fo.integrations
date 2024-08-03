
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
        
        If the payload parameter is NOT null, it will trigger a HTTP POST action against the URL.
        
        But if the payload is null, it will trigger a HTTP GET action against the URL.
        
        Remember that json is text based and can use either single quotes (') or double quotes (") as the text qualifier, so you might need to escape the different quotes in your payload before passing it in
        
    .PARAMETER PayloadCharset
        The charset / encoding that you want the cmdlet to use while invoking the odata entity action
        
        The default value is: "UTF8"
        
        The charset has to be a valid http charset like: ASCII, ANSI, ISO-8859-1, UTF-8
        
    .PARAMETER RetryTimeout
        The retry timeout, before the cmdlet should quit retrying based on the 429 status code
        
        Needs to be provided in the timspan notation:
        "hh:mm:ss"
        
        hh is the number of hours, numerical notation only
        mm is the number of minutes
        ss is the numbers of seconds
        
        Each section of the timeout has to valid, e.g.
        hh can maximum be 23
        mm can maximum be 59
        ss can maximum be 59
        
        Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint
        
    .PARAMETER ThrottleSeed
        Instruct the cmdlet to invoke a thread sleep between 1 and ThrottleSeed value
        
        This is to help to mitigate the 429 retry throttling on the OData / Custom Service endpoints
        
        It makes most sense if you are running things a outer loop, where you will hit the OData / Custom Service endpoints with a burst of calls in a short time
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through REST endpoint
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access through REST endpoint
        
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
        
    .PARAMETER TimeoutSec
        Specifies how long the request can be pending before it times out. Enter a value in seconds. The default value, 0, specifies an indefinite time-out.
        A Domain Name System (DNS) query can take up to 15 seconds to return or time out. If your request contains a host name that requires resolution, and you set TimeoutSec to a value greater than zero, but less than 15 seconds, it can take 15 seconds or more before a WebException is thrown, and your request times out.
        
    .EXAMPLE
        PS C:\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload "{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}"
        
        This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment.
        The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
        The Payload is a valid json string, containing all the needed properties.
        
    .EXAMPLE
        PS C:\> $Payload = '{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
        PS C:\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload $Payload
        
        This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment.
        First the desired json data is put into the $Payload variable.
        The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
        The $Payload variable is passed to the cmdlet.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload "{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}" -Token $token
        
        This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
        The Payload is a valid json string, containing all the needed properties.
        
    .EXAMPLE
        PS C:\> $Payload = '{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
        PS C:\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload $Payload  -RetryTimeout "00:01:00"
        
        This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment, and try for 1 minute to handle 429.
        First the desired json data is put into the $Payload variable.
        The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
        The $Payload variable is passed to the cmdlet.
        It will only try to handle 429 retries for 1 minute, before failing.
        
    .EXAMPLE
        PS C:\> $Payload = '{"RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
        PS C:\> Invoke-D365RestEndpoint -ServiceName "UserSessionService/AifUserSessionService/GetUserSessionInfo" -Payload $Payload -ThrottleSeed 2
        
        This will invoke the REST endpoint in the  Dynamics 365 Finance & Operations environment, and sleep/pause between 1 and 2 seconds.
        First the desired json data is put into the $Payload variable.
        The ServiceName used for the import is "UserSessionService/AifUserSessionService/GetUserSessionInfo".
        The $Payload variable is passed to the cmdlet.
        It will use the ThrottleSeed 2 to sleep/pause the execution, to mitigate the 429 pushback from the endpoint.
        
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

        [string] $PayloadCharset = "UTF-8",

        [Timespan] $RetryTimeout = "00:00:00",
        
        [int] $ThrottleSeed,

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,
        
        [string] $SystemUrl = $Script:ODataSystemUrl,

        [Parameter(Mandatory = $false)]
        [string] $ClientId = $Script:ODataClientId,

        [Parameter(Mandatory = $false)]
        [string] $ClientSecret = $Script:ODataClientSecret,

        [string] $Token,
        
        [switch] $EnableException,

        [Parameter(Mandatory = $false)]
        [int32] $TimeoutSec = 0
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
            URL         = $SystemUrl
            BearerToken = $bearer
        }

        $headers = New-AuthorizationHeaderBearerToken @headerParms

        $PayloadCharset = $PayloadCharset.ToLower()
        if ($PayloadCharset -like "utf*" -and $PayloadCharset -notlike "utf-*") {
            $PayloadCharset = $PayloadCharset -replace "utf", "utf-"
        }
    }

    process {
        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building request for the REST endpoint for the service: $ServiceName." -Target $ServiceName
        
        [System.UriBuilder] $restEndpoint = $URL

        $restEndpoint.Path = "api/services/$ServiceName"

        $params = @{ }
        $params.Uri = $restEndpoint.Uri.AbsoluteUri
        $params.Headers = $headers
        $params.ContentType = "application/json;charset=$PayloadCharset"

        if ($null -ne $Payload) {
            $params.Method = "POST"
            $params.Body = $Payload
        }
        else {
            $params.Method = "GET"
        }

        # set timeout when specified
        if ($TimeoutSec -gt 0) {
            $params.TimeoutSec = $TimeoutSec
        }
        
        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the REST endpoint." -Target $($restEndpoint.Uri.AbsoluteUri)
            Invoke-RequestHandler -Method POST -Uri $restEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType "application/json;charset=$PayloadCharset" -Payload $Payload -RetryTimeout $RetryTimeout

            if (Test-PSFFunctionInterrupt) { return }
        }
        catch {
            $messageString = "Something went wrong while importing data through the REST endpoint for the entity: $ServiceName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $ServiceName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        if ($ThrottleSeed) {
            Start-Sleep -Seconds $(Get-Random -Minimum 1 -Maximum $ThrottleSeed)
        }

        Invoke-TimeSignal -End
    }
}