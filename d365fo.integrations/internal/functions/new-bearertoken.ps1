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

    $azureUri = Get-PSFConfigValue -FullName "d365fo.integrations.azure.tenant.oauth.token"
    
    $bearerParms.AuthProviderUri = $azureUri -f $Tenant

    Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken
}