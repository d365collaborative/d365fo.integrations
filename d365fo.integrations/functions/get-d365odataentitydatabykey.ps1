
<#
    .SYNOPSIS
        Get data from an Data Entity using OData, providing a key
        
    .DESCRIPTION
        Get data from an Data Entity, by providing a key, using the OData endpoint of the Dynamics 365 Finance & Operations
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365FO is Case Sensitive
        
        Remember that most Data Entities in a D365FO environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The version 3 of the customers Data Entity is named CustomerV3, but can only be retrieving using CustomersV3
        
        Look at the Get-D365ODataPublicEntity cmdlet to help you obtain the correct name
        
    .PARAMETER Key
        A string value that contains all needed fields and value to be a valid OData key
        
        The key needs to be a valid http encoded value and each datatype needs to handled appropriately
        
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
        
    .PARAMETER OutputAsJson
        Instructs the cmdlet to convert the output to a Json string
        
    .EXAMPLE
        PS C:\> Get-D365ODataEntityDataByKey -EntityName CustomersV3 -Key "dataAreaId='DAT',CustomerAccount='123456789'"
        
        This will get the specific Customer from the OData endpoint.
        It will use the "CustomerV3" entity, and its EntitySetName / CollectionName "CustomersV3".
        It will use the "dataAreaId='DAT',CustomerAccount='123456789'" as key to identify the unique Customer record.
        It will NOT look across companies.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataEntityDataByKey -EntityName CustomersV3 -Key "dataAreaId='DAT',CustomerAccount='123456789'"
        
        This will get the specific Customer from the OData endpoint.
        It will use the "CustomerV3" entity, and its EntitySetName / CollectionName "CustomersV3".
        It will use the "dataAreaId='DAT',CustomerAccount='123456789'" as key to identify the unique Customer record.
        It will make sure to search across all legal entities / companies inside the D365FO environment.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> $token = Get-D365ODataToken
        PS C:\> Get-D365ODataEntityDataByKey -EntityName CustomersV3 -Key "dataAreaId='DAT',CustomerAccount='123456789'" -Token $token
        
        This will get the specific Customer from the OData endpoint.
        It will get a fresh token, saved it into the token variable and pass it to the cmdlet.
        It will use the "CustomerV3" entity, and its EntitySetName / CollectionName "CustomersV3".
        It will use the "dataAreaId='DAT',CustomerAccount='123456789'" as key to identify the unique Customer record.
        It will NOT look across companies.
        
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

function Get-D365ODataEntityDataByKey {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [Alias('Name')]
        [string] $EntityName,

        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [string] $Key,

        [string] $ODataQuery,

        [switch] $CrossCompany,

        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [string] $Url = $Script:ODataUrl,

        [string] $SystemUrl = $Script:ODataSystemUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [string] $Token,
        
        [switch] $EnableException,

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
        if (Test-PSFFunctionInterrupt) { return }

        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building request for the OData endpoint for entity: $entity." -Target $entity

        [System.UriBuilder] $odataEndpoint = $SystemUrl
        
        if ($odataEndpoint.Path -eq "/") {
            $odataEndpoint.Path = "data/$EntityName($Key)"
        }
        else {
            $odataEndpoint.Path += "/data/$EntityName($Key)"
        }

        if (-not ([string]::IsNullOrEmpty($ODataQuery))) {
            $odataEndpoint.Query = "$ODataQuery"
        }
        
        if ($CrossCompany) {
            $odataEndpoint.Query = $($odataEndpoint.Query + "&cross-company=true").Replace("?", "")
        }

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            $res = Invoke-RestMethod -Method Get -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json'

            if ($OutputAsJson) {
                $res | ConvertTo-Json -Depth 10
            }
            else {
                $res
            }
        }
        catch [System.Net.WebException] {
            $webException = $_.Exception
            
            if (($webException.Status -eq [System.Net.WebExceptionStatus]::ProtocolError) -and (-not($null -eq $webException.Response))) {
                $resp = [System.Net.HttpWebResponse]$webException.Response

                if ($resp.StatusCode -eq [System.Net.HttpStatusCode]::NotFound) {
                    $messageString = "It seems that the OData endpoint was unable to locate the desired entity: $EntityName, based on the key: <c='em'>$key</c>. Please make sure that the key is <c='em'>valid</c> or try using the <c='em'>-CrossCompany</c> parameter."
                    Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
                    Stop-PSFFunction -Message "Stopping because of HTTP error 404." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
                    return
                }
                else {
                    $messageString = "Something went wrong while retrieving data from the OData endpoint for the entity: $EntityName"
                    Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
                    Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
                    return
                }
            }
        }
        catch {
            $messageString = "Something went wrong while retrieving data from the OData endpoint for the entity: $EntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    }
}