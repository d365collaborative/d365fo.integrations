
<#
    .SYNOPSIS
        Get Service Group from the Json Service endpoint
        
    .DESCRIPTION
        Get available Service Group from the Json Service endpoint of the Dynamics 365 Finance & Operations instance
        
    .PARAMETER Name
        Name of the Service Group that you are looking for
        
        The parameter supports wildcards. E.g. -Name "*Timesheet*"
        
        Default value is "*" to list all service groups
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself
        
        If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"
        
    .PARAMETER SystemUrl
        URL / URI for the D365FO instance where the Json Service endpoint is available
        
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
        
    .PARAMETER RawOutput
        Instructs the cmdlet to include the outer structure of the response received from Json Service endpoint
        
        The output will still be a PSCustomObject
        
    .PARAMETER OutputAsJson
        Instructs the cmdlet to convert the output to a Json string
        
    .EXAMPLE
        PS C:\> Get-D365RestServiceGroup
        
        This will list all available Service Groups from the Dynamics 365 Finance & Operations instance.
        
        It will use the default configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365RestServiceGroup -Name "*service*"
        
        This will list all available Service Groups, which matches the "*service*" pattern, from the Dynamics 365 Finance & Operations instance.
        
        It will use the default configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Get-D365RestServiceGroup -Token $token
        
        This will list all available Service Groups from the Dynamics 365 Finance & Operations instance.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        
        It will use the default configuration details that are stored in the configuration store.
        
    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Set-D365ActiveODataConfig
        
    .NOTES
        Tags: Json, Data, Service, Operations
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365RestServiceGroup {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [string] $Name = "*",

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $SystemUrl = $Script:ODataSystemUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [string] $Token,
        
        [switch] $EnableException,

        [switch] $RawOutput,

        [switch] $OutputAsJson

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

        Write-PSFMessage -Level Verbose -Message "Building request for the Json Services endpoint"
        
        [System.UriBuilder] $restEndpoint = $SystemUrl

        if ($restEndpoint.Path -eq "/") {
            $restEndpoint.Path = "api/services"
        }
        else {
            $restEndpoint.Path += "/api/services"
        }

        $params = @{ }
        $params.Uri = $restEndpoint.Uri.AbsoluteUri
        $params.Headers = $headers
        $params.ContentType = "application/json"
        $params.Method = "GET"
        
        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the REST endpoint." -Target $($restEndpoint.Uri.AbsoluteUri)
            $res = Invoke-RestMethod @params

            if (-not $RawOutput) {
                $res = $res.ServiceGroups | Where-Object { $_.Name -Like $Name -or $_.Name -eq $Name } | Sort-Object Name
            }
            else {
                $res.ServiceGroups = @($res.ServiceGroups | Where-Object { $_.Name -Like $Name -or $_.Name -eq $Name }) | Sort-Object Name
            }
        
            $res = $res | Select-PSFObject "Name as ServiceGroupName"

            if ($OutputAsJson) {
                $res | ConvertTo-Json -Depth 10
            }
            else {
                $res
            }
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