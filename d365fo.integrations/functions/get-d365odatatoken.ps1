
<#
    .SYNOPSIS
        Get OAuth 2.0 token to be used against OData or Custom Service
        
    .DESCRIPTION
        Get an OAuth 2.0 bearer token to be used against the OData or Custom Service endpoints of the Dynamics 365 Finance & Operations
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to be working against
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself
        
        If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"
        
    .PARAMETER SystemUrl
        URL / URI for the D365FO instance you want to be working against
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself, which is the same as the Url parameter value
        
        If you are working against a D365 Talent / HR instance, this will to be full instance URL / URI like "https://aos-rts-sf-b1b468164ee-prod-northeurope.hr.talent.dynamics.com/namespaces/0ab49d18-6325-4597-97b3-c7f2321aa80c"
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .PARAMETER RawOutput
        Instructs the cmdlet to output the raw token object and all its properties
        
    .EXAMPLE
        PS C:\> Get-D365ODataToken
        
        This will get a bearetrtoken string.
        The output will be a formal formatted bearer token, ready to be used right away.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365ODataToken -RawOutput
        
        This will get an OAuth 2.0 token.
        It will output all properties of the token.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .LINK
        Add-D365ODataConfig
        
    .LINK
        Get-D365ActiveODataConfig
        
    .LINK
        Set-D365ActiveODataConfig
        
    .NOTES
        Tags: OData, OAuth, Token, JWT
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365ODataToken {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [Alias('$AadGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('Uri')]
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