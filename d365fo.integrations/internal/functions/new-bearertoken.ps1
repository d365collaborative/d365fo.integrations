
<#
    .SYNOPSIS
        Get a new bearer token
        
    .DESCRIPTION
        Obtain a new bearer token to be used for the different HTTP request against the Dynamics 365 for Finance & Operations environment
        
    .PARAMETER Url
        URL / URI for web endpoint that you want the token to be valid for
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to authenticate against
        
    .EXAMPLE
        PS C:\> New-BearerToken -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -Tenant "e674da86-7ee5-40a7-b777-1111111111111"
        
        This will obtain a new and valid bearer token.
        It will use "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the resource url that you want the token to be valid for.
        It will use "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
        It will use "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret
        It will use "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
        
    .NOTES
        Tags: OAuth, OAuth 2.0, Token, Bearer, JWT
        
        Author: Mötz Jensen (@Splaxi)
#>

function New-BearerToken {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Uri')]
        [string] $Url,

        [Parameter(Mandatory = $true)]
        [string] $ClientId,

        [Parameter(Mandatory = $true)]
        [string] $ClientSecret,

        [Parameter(Mandatory = $true)]
        [string] $Tenant

    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Building request for fetching the bearer token." -Target $Var
    $bearerParms = @{
        Resource     = $Url
        ClientId     = $ClientId
        ClientSecret = $ClientSecret
    }

    $azureUri = $Script:AzureTenantOauthToken
    
    $bearerParms.AuthProviderUri = $azureUri -f $Tenant

    Write-PSFMessage -Level Verbose -Message "Fetching the bearer token." -Target ($bearerParms -join ", ")

    Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken

    Invoke-TimeSignal -End
}