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
        
    .PARAMETER URL
        URL / URI for the D365FO environment you want to access through OData
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application

    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts

.EXAMPLE
PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=1'

This will get Customers from the OData endpoint.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will get the top 1 results from the list of customers.

.EXAMPLE
PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=10' -CrossCompany

This will get Customers from the OData endpoint.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will get the top 10 results from the list of customers.
It will make sure to search across all legal entities / companies inside the D365FO environment.

.EXAMPLE
PS C:\> Get-D365ODataEntityData -EntityName CustomersV3 -ODataQuery '$top=10&$filter=dataAreaId eq ''Comp1''' -CrossCompany

This will get Customers from the OData endpoint.
It will use the CustomerV3 entity, and its EntitySetName / CollectionName "CustomersV3".
It will get the top 10 results from the list of customers.
It will make sure to search across all legal entities / companies inside the D365FO environment.
It will search the customers inside the "Comp1" legal entity / company.

((Get-D365ODataPublicEntity -EntityNameContains customersv3).Value | Get-D365ODataEntityData -ODataQuery '$top=1&$filter=dataAreaId eq ''empd''' -CrossCompany)| fl

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
        [Alias('Name')]
        [string] $EntityName,

        [Parameter(Mandatory = $true, ParameterSetName = "Default", ValueFromPipelineByPropertyName = $true)]
        [Alias('CollectionName')]
        [string] $EntitySetName,

        [Parameter(Mandatory = $false)]
        [string] $ODataQuery,

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
            Resource     = $URL
            ClientId     = $ClientId
            ClientSecret = $ClientSecret
        }

        $bearerParms.AuthProviderUri = "https://login.microsoftonline.com/$Tenant/oauth2/token"

        $bearer = Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken

        $headerParms = @{
            URL         = $URL
            BearerToken = $bearer
        }

        $headers = New-AuthorizationHeaderBearerToken @headerParms
    }

    process {
        $entity = "$EntityName$EntitySetName"

        Write-PSFMessage -Level Verbose -Message "Working against $entity" -Target $entity

        [System.UriBuilder] $odataEndpoint = $URL
        
        $odataEndpoint.Path = "data/$entity"

        if (-not ([string]::IsNullOrEmpty($ODataQuery))) {
            $odataEndpoint.Query = "$ODataQuery"
        }
        
        if($CrossCompany){
            $odataEndpoint.Query = $($odataEndpoint.Query + "&cross-company=true").Replace("?", "")
        }

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            Invoke-RestMethod -Method Get -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json'
        }
        catch {
            $messageString = "Something went wrong while retrieving data from the OData endpoint for the entity: $entity"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $entity
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>',''))) -ErrorRecord $_
            return
        }
    }
}