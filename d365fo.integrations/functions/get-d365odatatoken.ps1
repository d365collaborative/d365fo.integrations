
<#
    .SYNOPSIS
        Get data from an Data Entity using OData
        
    .DESCRIPTION
        Get data from an Data Entity using the OData endpoint of the Dynamics 365 Finance & Operations
        
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
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
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

function Get-D365ODataToken {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [Alias('$AADGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
        [Alias('AuthenticationUrl')]
        [string] $Url = $Script:ODataUrl,

        [string] $SystemUrl = $Script:ODataSystemUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $EnableException,

        [switch] $RawOutput
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
    }

    process {
        $bearerParms = @{
            Resource     = $Url
            ClientId     = $ClientId
            ClientSecret = $ClientSecret
        }
    
        $azureUri = $Script:AzureTenantOauthToken
        
        $bearerParms.AuthProviderUri = $azureUri -f $Tenant

        $tokenObj = Invoke-ClientCredentialsGrant @bearerParms
            
        if ($RawOutput) {
            $tokenObj
        }
        else {
            $tokenObj | Get-BearerToken
        }
    }
}