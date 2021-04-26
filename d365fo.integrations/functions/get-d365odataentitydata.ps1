
<#
    .SYNOPSIS
        Get data from an Data Entity using OData
        
    .DESCRIPTION
        Get data from an Data Entity using the OData endpoint of the Dynamics 365 Finance & Operations
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive
        
        Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3
        
        Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name
        
    .PARAMETER EntitySetName
        Name of the Data Entity you want to work against
        
        The parameter is created specifically to be used when piping from Get-D365ODataPublicEntity
        
    .PARAMETER Top
        Number of records that you want returned from the OData endpoint
        
        Setting this will override anything in the OData parameter
        
    .PARAMETER Filter
        Filter statements to limit the records outputted from the OData endpoint
        
        Supports an array of filter statements, so you don't need to know the syntax of combining filter statements
        
        Setting this will override anything in the OData parameter
        
    .PARAMETER Select
        List of properties/columns that you want to return for the records outputted from the OData endpoint
        
        Setting this will override anything in the OData parameter
        
    .PARAMETER Expand
        List of navigation properties/related properties that you want to include for the records outputted from the OData endpoint
        
        Setting this will override anything in the OData parameter
        
    .PARAMETER ODataQuery
        Valid OData query string that you want to pass onto the D365 OData endpoint while retrieving data
        
        OData specific query options are:
        $filter
        $expand
        $select
        $orderby
        $top
        $skip
        
        Each option has different characteristics, which is well documented at: http://docs.oasis-open.org/odata/odata/v4.0/odata-v4.0-part2-url-conventions.html
        
    .PARAMETER CrossCompany
        Instruct the cmdlet / function to ensure the request against the OData endpoint will search across all companies
        
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
        
    .PARAMETER TraverseNextLink
        Instruct the cmdlet to keep traversing the NextLink if the result set from the OData endpoint is larger than what one round trip can handle
        
        The system default is 10,000 (10 thousands) at the time of writing this feature in December 2020
        
    .PARAMETER ThrottleSeed
        Instruct the cmdlet to invoke a thread sleep between 1 and ThrottleSeed value
        
        This is to help to mitigate the 429 retry throttling on the OData / Custom Service endpoints
        
        It will only be available in combination with the TraverseNextLink parameter
        
    .PARAMETER Token
        Pass a bearer token string that you want to use for while working against the endpoint
        
        This can improve performance if you are iterating over a large collection/array
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .PARAMETER RawOutput
        Instructs the cmdlet to include the outer structure of the response received from OData endpoint
        
        The output will still be a PSCustomObject
        
    .PARAMETER OutputAsJson
        Instructs the cmdlet to convert the output to a Json string
        
    .EXAMPLE
        PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=1'
        
        This will get Customers from the OData endpoint.
        It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
        It will get the top 1 results from the list of customers.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=10' -CrossCompany
        
        This will get Customers from the OData endpoint.
        It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
        It will get the top 10 results from the list of customers.
        It will make sure to search across all legal entities / companies inside the D365FO environment.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=10&$filter=dataAreaId eq ''Comp1''' -CrossCompany
        
        This will get Customers from the OData endpoint.
        It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
        It will get the top 10 results from the list of customers.
        It will make sure to search across all legal entities / companies inside the D365FO environment.
        It will search the customers inside the "Comp1" legal entity / company.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -TraverseNextLink
        
        This will get Customers from the OData endpoint.
        It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
        It will traverse all NextLink that will occur while fetching data from the OData endpoint.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -TraverseNextLink -ThrottleSeed 2
        
        This will get Customers from the OData endpoint, and sleep/pause between 1 and 2 seconds.
        It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
        It will traverse all NextLink that will occur while fetching data from the OData endpoint.
        It will use the ThrottleSeed 2 to sleep/pause the execution, to mitigate the 429 pushback from the endpoint.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=1' -Token $token
        
        This will get Customers from the OData endpoint.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
        It will get the top 1 results from the list of customers.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=1' -RetryTimeout "00:01:00"
        
        This will get Customers from the OData endpoint, and try for 1 minute to handle 429.
        It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
        It will get the top 1 results from the list of customers.
        It will only try to handle 429 retries for 1 minute, before failing.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Set-D365ActiveODataConfig
        
    .NOTES
        The OData standard is using the $ (dollar sign) for many functions and features, which in PowerShell is normally used for variables.
        
        Whenever you want to use the different query options, you need to take the $ sign and single quotes into consideration.
        
        Example of an execution where I want the top 1 result only, from a specific legal entity / company.
        This example is using single quotes, to help PowerShell not trying to convert the $ into a variable.
        Because the OData standard is using single quotes as text qualifiers, we need to escape them with multiple single quotes.
        
        -ODataQuery '$top=1&$filter=dataAreaId eq ''Comp1'''
        
        Tags: OData, Data, Entity, Query
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365ODataEntityData {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [Parameter(ParameterSetName = "NextLink")]
        [Alias('Name')]
        [string] $EntityName,

        [Parameter(Mandatory = $true, ParameterSetName = "Default", ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = "NextLink", ValueFromPipelineByPropertyName = $true)]
        [Alias('CollectionName')]
        [string] $EntitySetName,

        [int] $Top,

        [string[]] $Filter,

        [string[]] $Select,

        [string[]] $Expand,

        [string] $ODataQuery,

        [switch] $CrossCompany,

        [Timespan] $RetryTimeout = "00:00:00",

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $SystemUrl = $Script:ODataSystemUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [Parameter(Mandatory = $true, ParameterSetName = "NextLink")]
        [switch] $TraverseNextLink,

        [Parameter(ParameterSetName = "NextLink")]
        [int] $ThrottleSeed,

        [string] $Token,
        
        [switch] $EnableException,

        [Parameter(ParameterSetName = "Specific")]
        [Parameter(ParameterSetName = "Default")]
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

        $odataAppend = "&"

        $sbODataQuery = [System.Text.StringBuilder]::new()
        if ($Top -gt 0) {
            [void]$sbODataQuery.AppendFormat("`$top={0}", $top)
        }

        if (-not [System.String]::IsNullOrEmpty($Filter)) {
            if ($sbODataQuery.Length -gt 0) {
                $odataFilterAppend = $odataAppend
            }

            [void]$sbODataQuery.AppendFormat("{0}`$filter={1}", $odataFilterAppend, $($Filter -join " and "))
        }
        
        if (-not [System.String]::IsNullOrEmpty($Select)) {
            if ($sbODataQuery.Length -gt 0) {
                $odataSelectAppend = $odataAppend
            }

            [void]$sbODataQuery.AppendFormat("{0}`$select={1}", $odataSelectAppend, $($Select -join ","))
        }

        if (-not [System.String]::IsNullOrEmpty($Expand)) {
            if ($sbODataQuery.Length -gt 0) {
                $odataExpandAppend = $odataAppend
            }

            [void]$sbODataQuery.AppendFormat("{0}`$expand={1}", $odataExpandAppend, $($Expand -join ","))
        }

        if ($sbODataQuery.Length -gt 0) {
            $ODataQuery = $sbODataQuery.ToString()
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building request for the OData endpoint for entity: $entity." -Target $entity

        #A simple hack to select either names as the name going forward
        $entity = "$EntityName$EntitySetName"

        [System.UriBuilder] $odataEndpoint = $SystemUrl
        
        if ($odataEndpoint.Path -eq "/") {
            $odataEndpoint.Path = "data/$entity"
        }
        else {
            $odataEndpoint.Path += "/data/$entity"
        }

        if (-not ([string]::IsNullOrEmpty($ODataQuery))) {
            $odataEndpoint.Query = "$ODataQuery"
        }
        
        if ($CrossCompany) {
            $odataEndpoint.Query = $($odataEndpoint.Query + "&cross-company=true").Replace("?", "")
        }

        try {
            [System.Collections.Generic.List[System.Object]] $resArray = @()

            $localUri = $odataEndpoint.Uri.AbsoluteUri
            do {
                Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $localUri
                $resGet = Invoke-RequestHandler -Method Get -Uri $localUri -Headers $headers -ContentType 'application/json' -RetryTimeout $RetryTimeout
                
                if (Test-PSFFunctionInterrupt) { return }
                
                if (-not $RawOutput) {
                    $resArray.AddRange($resGet.Value)
                }
                else {
                    $res = $resGet
                }
                
                if ($($resGet.'@odata.nextLink') -match ".*(/data/.*)") {
                    $localUri = "$SystemUrl$($Matches[1])"
                }

                if ($ThrottleSeed) {
                    Start-Sleep -Seconds $(Get-Random -Minimum 1 -Maximum $ThrottleSeed)
                }
            } while ($TraverseNextLink -and $resGet.'@odata.nextLink')

            if ($resArray.Count -gt 0) {
                $res = $resArray.ToArray()
            }

            if ($OutputAsJson) {
                $res | ConvertTo-Json -Depth 10
            }
            else {
                $res
            }
        }
        catch {
            $messageString = "Something went wrong while retrieving data from the OData endpoint for the entity: $entity"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $entity
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    }
}