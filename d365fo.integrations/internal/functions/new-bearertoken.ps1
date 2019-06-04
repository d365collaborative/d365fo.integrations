function New-BearerToken {
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

    $bearerParms = @{
        Resource     = $Url
        ClientId     = $ClientId
        ClientSecret = $ClientSecret
    }

    $azureUri = $Script:AzureTenantOauthToken
    
    $bearerParms.AuthProviderUri = $azureUri -f $Tenant

    Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken
}